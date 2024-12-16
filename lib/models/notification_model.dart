// lib/models/notification_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  discount,
  invite,
}

class AppNotification {
  final String id;
  final String
      userId; // The recipient's user ID (optional for topic notifications)
  final String title;
  final String body;
  final DateTime timestamp;
  final String sentBy; // Sender's identifier (e.g., manager or user ID)
  final NotificationType type;

  AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.sentBy,
    required this.type,
  });

  factory AppNotification.fromDocument(DocumentSnapshot doc) {
    try {
      // Defensive check for missing fields
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      String typeStr = data.containsKey('type')
          ? data['type']
          : 'invite'; // Default to 'invite'
      NotificationType notifType;

      switch (typeStr) {
        case 'discount':
          notifType = NotificationType.discount;
          break;
        case 'invite':
        default:
          notifType = NotificationType.invite;
      }

      return AppNotification(
        id: doc.id,
        userId: data['userId'] ?? '',
        title: data['title'] ?? 'No Title',
        body: data['body'] ?? 'No Body',
        timestamp: data['timestamp'] != null
            ? (data['timestamp'] as Timestamp).toDate()
            : DateTime.now(), // Default to current time if missing
        sentBy: data['sentBy'] ?? 'Unknown',
        type: notifType,
      );
    } catch (e) {
      print('Error parsing notification document: ${doc.id}, Error: $e');
      throw Exception('Error parsing notification data');
    }
  }

  Map<String, dynamic> toMap() {
    String typeStr = type == NotificationType.discount ? 'discount' : 'invite';
    return {
      'userId': userId,
      'title': title,
      'body': body,
      'timestamp': Timestamp.fromDate(timestamp),
      'sentBy': sentBy,
      'type': typeStr,
    };
  }
}
