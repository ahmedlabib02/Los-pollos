import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import '../models/notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:los_pollos_hermanos/models/customUser.dart';
import 'package:los_pollos_hermanos/services/client_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

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

  // Initialize FirebaseFunctions instance
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  // Initialize notifications
  Future<void> init(BuildContext context) async {
    await Firebase.initializeApp(); // Ensure Firebase is initialized
    await _requestPermission();
    await _initializeLocalNotifications(context);
    await _createNotificationChannel();
    _configureForegroundNotificationListener(context);
    _configureBackgroundNotificationHandler();
    await _saveFcmToken(context);
    _handleTokenRefresh(context);
    await _subscribeToOffers(); // Subscribe to offers topic
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
  void _configureForegroundNotificationListener(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Received a foreground message');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      Map<String, dynamic> data = message.data;

      if (notification != null && android != null) {
        _localNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body, // Corrected typo from 'notfication.body'
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

        // Save the notification to Firestore
        final user = Provider.of<CustomUser?>(context, listen: false);
        if (user != null) {
          // Create a new Notification object
          AppNotification newNotification = AppNotification(
            id: message.messageId ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            title: notification.title ?? '',
            body: notification.body ?? '',
            timestamp: DateTime.now(),
            sentBy: data['sentBy'] ?? 'unknown',
          );

          // Add the notification to Firestore
          await ClientService().addNotification(user.uid, newNotification);
          print('Notification saved to Firestore');
        }
      }
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

  // 8. Subscribe to Offers Topic
  Future<void> _subscribeToOffers() async {
    try {
      await _messaging.subscribeToTopic('offers');
      print('Subscribed to offers topic');
    } catch (e) {
      print('Error subscribing to offers topic: $e');
    }
  }

  // Optional: Delete FCM Token
  Future<void> deleteFcmToken(String? uid) async {
    await ClientService().removeClientFcmToken(uid);
    await _messaging.deleteToken();
    print('FCM Token deleted');
  }

  // Clean up local notifications
  void dispose() {
    _localNotificationsPlugin.cancelAll();
  }

  // Updated method sending to the "offers" topic
  Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "los-pollos-a9354",
      "private_key_id": "e0eb360b9fd14c49f24e0d6f57e5100d629c3a35",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCeO1VqiN2aCQnw\nWt5KODbhes0ZVMnz+McSXsurAAtlmOARSU4+Hbm34Al95vm/QhtQsmGM6NMp1OsS\nF9FgCtRHiA2z02uV71Hjqa6u4DTu+9Gt3t63+fZ1Ivn7Vv+pNHY51N1tQ+JMJkLT\nKYk2HOYbCsC+Fd8gC6F5cvgzEB5q7+9ZB1tvdJdr5paKud41wQ9stOI7Z5GqkdW0\nX5sxdeiVJ8Hkb9iRVHgpKogQKcji9i826xRXO7H4C6mfHFiXf+87zjj4TgTTe7OI\nzX6xkrK6QGr6H/ji2gHpd1zPvzn54z3ZLXJ5yhFR7Fw+qOlKul7+tjpQ4Z8vSkiN\nvWHvBZOXAgMBAAECggEAOzytSpf4lk0h+miaZaDL8vf9Rql2fa66IEd66ga3PY7Q\n+8e80gZg29S02PyarR57iWdum8kiHLwIURq3mMQVGr51msfgtB4HQzroGbH4Pyvp\nILWaHbgnq0yv14eHaPop9JabWueaFbYROGqJYsfI4YDSDZe0k5OnHQeModk7+f5I\nniNSdaCLleWtLYkBhOZ4b6t0d/NHyKMltubJczmQl0psjMVWq1uWi/ti5LFNFueQ\nUv+Ro45h8nRALDNMxh6MvI04Xgi14PNQKZpVpa4O9sTU+nW85nULEIpQtyOhzKi4\nTrJLwaNR7lVRLPtoIi+lhgv58QuUTzr1063aBAqHKQKBgQDMpJNyqLhq3PomnAG7\n3m7uhZqmYSdiXjj3k2a0VGFnDw4CT0olj/cZA1h8sJQZMCfqp2bBCIb7DxmdNk8B\nKIF0rvbXH2h7i4EYVTUSnJFNmSMWIpmjcjTNyD8kgq7qqGV3/eukaKrLGAF0Ynsr\nx5da+0N8koElj8sFRtNT2/Fv0wKBgQDF8QtH1MzVxgNEJh9OQlPbaQywXZjzQEE4\nbL1ByTal7gjDa5mV/ch9JnJ9kCSSoy3aGzhGdjgzDmbZ9LfWUWZPR2yEbFGfrR1J\ntlmbQR0Eiv3Csv99jpd6NZfofG5HnWzRXxB9IWYFlzzEIXRwu25PnI12hTwDxawu\nTuuqPg+2rQKBgQCWG4IscKYVfNHg0D5VV+t2+nld4ZXKCeMvdue3Ds4Dkn9sIkz5\nEIjnyBR4Ie4AK9qbvP8aSO756TGYp+V7rAKJXG2jjl5NgR7IgnfTlxTeHp4l9mtM\nANHKwD/QwCsd5TfItHDMwBnHr2whursuedED45q1HaGts7PvwuvwbzzCEQKBgG5H\nwpItpEXCAZXZa32thIzstS4Zp5p3BR9LrhHV6gV+XhGKhFJFx4q6ffUo9sdf9K7c\nlXjkaqE/d9wc9MOKLGclEvegZcWBrJyh5MCUAXfDfGgaVC/+3rQu4cicctChi7wG\nq+gbUHzy6t8XCIm6U1Y1kbcjufEcE7blL3V1CEotAoGAWdXdhcKHecQgtj5K51jQ\nsfbsSLgNsFu6bYtAPBTRJeVAw+LYM4dxThs/1FdmD//uLyNyBhZ2+yfCsJvs2Kli\nCsoioA68giTIuz5hW55XrWjibNJo7Qe581IdH6eJUF+9KYlerDCpaeapV/A3btIz\nuGLjjxc+jko0miE+HivhT9c=\n-----END PRIVATE KEY-----\n",
      "client_email": "los-pollos@los-pollos-a9354.iam.gserviceaccount.com",
      "client_id": "112875429706990528449",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/los-pollos%40los-pollos-a9354.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    client.close();

    return credentials.accessToken.data;
  }

  Future<void> sendNotificationToTopic(
      String topic, String title, String body, String sentBy) async {
    final String serverAccessToken = await getAccessToken();
    String endPointFireBaseCloudMessaging =
        "https://fcm.googleapis.com/v1/projects/los-pollos-a9354/messages:send";

    final Map<String, dynamic> message = {
      'message': {
        'topic': topic, // Specify the topic here
        'notification': {
          'title': title,
          'body': body,
        },
        'data': {
          'sentBy': sentBy, // Include 'sentBy' in data payload
        }
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endPointFireBaseCloudMessaging),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverAccessToken'
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print("Notification sent to topic '$topic'");
      // Save the notification to Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('notifications').add({
        'title': title,
        'body': body,
        'timestamp': FieldValue.serverTimestamp(),
        'sentBy': sentBy,
      });
      print("Notification saved to Firestore");
    } else {
      print("Failed to send notification to topic '$topic': ${response.body}");
    }
  }
}
