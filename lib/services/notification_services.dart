import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:los_pollos_hermanos/models/customUser.dart';
import 'package:los_pollos_hermanos/services/client_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

// Top-level background message handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();

  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "los-pollos-a9354",
      "private_key_id": "ad1df6bc1fe9a3a1c1761d48a3da5e4446bd3d43",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDqocrKTqQRuKjK\nBqgar8szHqfBc2+v9AnBgf0vBAWHGE+wq04Dzyu1v6iCE6y3pNnyz5SnYhaNRQqU\n4CQe5c97COSw9z70lF9xRZspsH4c9h/cfe+bLTJX7XkxSxBvggyOF2gnN1vvvvZU\nvGKi6mR3rMgoW9LCaCb7K9+xFqIa8gAHVNvcW0Z/EwwqkNoFagn7fhZ4LYp91QV3\n4dbFWdezoz8M+Kgm9OkEjvWxGxcaXlBmpqX5blWbEEUWeh5oGzRZZ4lZpirHOsXD\nzMOw0wEwVxFPEaJL7anJzg5x20VTJ2fcKOEglYaSuGwZ/X0WHLYjLyVN4l6Rgnay\nwPfSGo8PAgMBAAECggEAGL0iYp5UEkJEGbkF9HpglG1BBtajCgxTEwIfrdtgsdPQ\nYzJMsX4gf7NLkxt79Ij/KejVJajj89U5vmS7qj5U2AYiBr6q9qLGRW0vZP/k7CzP\nQzJMFzJ2wmqZgqcFfpxZsompQ6lEmkyqMFkElWTdXvjqycaUvEa7BXSky0k1ol16\nEDEK2gQQPcUuJQdyn0VwVJ6jto8uEGa5Htl/PiTFL6Y5omjFDqo4p42p3p5gCuoK\nqKicriocgk9rVE/U9sE7Wazl/BhWMERMPodZVUpMfumdfWKkfvZMAqZBMxv3Hk/J\n6tGeHMCxpaZmR/soAzzKuWaZKbrs5q4LaTldqXmu8QKBgQD3FraE30ZYPgFhsGaW\nmKei4vmDGQ2JzOpLz6dghxTfBgXRGFYe/6QUGJNIg6lfb4Rg2v5GCdIt2hMY1ICN\nOXT+mtBwR3By8qFvulPJVawp7mj1HbcULmSdgGk0yA/z7z+vYHg/7VkopvLujyVw\nYo7TofkkRGQv2FSkTSxWwqoyxQKBgQDzGBIJ0OMODBy1lXKE+QUaepWa9YF9Qtsb\n2XqgC+JNDrOvSMrdDPbnrSNpvXoQ1KNX2JiK9OpgDQN7/pQ7Na5bRv2ooaWXgKF3\nuEdpxaP/AH/qShjDQaoh9izD+hISGjh57I3+GiliNK4BMiwl9A/GkEcGbxMXUuRj\nzJ5gffCHwwKBgH+kBQ9ow88L4OzVEnnTTC3x8JEPnRXFfHdDQySzQ03er5yPZNXI\nm7sh4tu/3/wEAK+EEXye0CuNjvXxuKK7vrtTwD9wOB+5RToRV/0Wu8RBe4i8G/pZ\n6PIQBskUXGFYA18Wh6gGdVtxuucPnXiMAVpEPw7EIbkxmK/ziecb0o49AoGAcmtu\n+h3O8Wq0DKgWKg6H32m5hyFtXIceWKJpvHE7iCeWXbe2fItAn9V3qKqdjNR5Obzi\nN+2Fb8ZQUImIPcJLmfz1Ie1L4t6RoackPd3gDgOvMZjExQrgSHH1qhzHaqvaz1CP\nmP25YtcG29tAunCBCGYaeCXJ552FkI/cL/C3ST8CgYEAi7UIqLYrABvvPoaPaYuW\nK8vNEoDktPxB/JNvpTIVcc2HaSpfpRJDjS42N+zxwT9e36bZHNGsG1yolF0y5Mj8\n15F2RY2NDVBcaeMbwmcXN1vazkgZl9E1BzwdaJPuaZ0h9gARgQPp1aAlxP0LXTrZ\nXIQp+Jnjm3HuMJq1c4wDu+g=\n-----END PRIVATE KEY-----\n",
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

  static sendNotificationToSelectedDriver(
      String deviceToken, BuildContext context, String tripId) async {
    final String serverAccessToken = await getAccessToken();
    String endPointFireBaseCloudMessaging =
        "https://fcm.googleapis.com/v1/projects/los-pollos-a9354/messages:send";
    final Map<String, dynamic> message = {
      'message': {
        'token': deviceToken,
        'notification': {
          'title': "hey bitch",
          'body': "I am trying to make things workout",
        },
        'data': {}
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
      print("Notification sent");
    } else {
      print("Failed Notification");
    }
  }

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
