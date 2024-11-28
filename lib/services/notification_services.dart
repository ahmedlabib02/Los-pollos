import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:los_pollos_hermanos/models/customUser.dart';
import 'package:los_pollos_hermanos/services/client_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Top-level background message handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize notifications
  Future<void> init(BuildContext context) async {
    await _requestPermission();
    await _initializeLocalNotifications(context);
    await _createNotificationChannel();
    _configureForegroundNotificationListener();
    _configureBackgroundNotificationHandler();
    await _saveFcmToken(context);
    _handleTokenRefresh(context);
  }

  // 1. Request Notification Permissions
  Future<void> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // 2. Initialize Local Notifications
  Future<void> _initializeLocalNotifications(BuildContext context) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        // Example: Navigate to a specific screen
        // Navigator.of(context).pushNamed('/specificRoute');
      },
    );
  }

  // 3. Create Notification Channel
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel', // id
      'Default Channel', // name
      description: 'This is the default channel for notifications.',
      importance: Importance.max,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // 4. Configure Foreground Listener
  void _configureForegroundNotificationListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a foreground message');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _localNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'default_channel', // Ensure this matches your channel ID
              'Default Channel',
              channelDescription: 'This is the default channel',
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }

      // Optionally, handle data payload or perform other actions
    });
  }

  // 5. Configure Background Handler
  void _configureBackgroundNotificationHandler() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  // 6. Save FCM Token to Firestore
  Future<void> _saveFcmToken(BuildContext context) async {
    final user = Provider.of<CustomUser?>(context, listen: false);
    if (user != null) {
      String? token = await _messaging.getToken();
      if (token != null) {
        print('FCM Token: $token');
        ClientService _clientService = ClientService();
        await _clientService.updateClientFcmToken(user.uid, token);
        print('FCM Token saved to Firestore');
      }
    }
  }

  // 7. Handle Token Refresh
  void _handleTokenRefresh(BuildContext context) {
    _messaging.onTokenRefresh.listen((newToken) async {
      print('FCM Token refreshed: $newToken');
      final user = Provider.of<CustomUser?>(context, listen: false);
      if (user != null) {
        await ClientService().updateClientFcmToken(user.uid, newToken);
        print('FCM Token updated in Firestore');
      }
    });
  }

  Future<void> deleteFcmToken(String? uid) async {
    await ClientService().removeClientFcmToken(uid);
    await _messaging.deleteToken();
    print('FCM Token deleted');
  }

  void dispose() {
    _localNotificationsPlugin.cancelAll();
  }
}
