// lib/models/notification_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  discount,
  invite,
}

class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String body;
  final DateTime timestamp;
  final String sentBy;
  final NotificationType type;
  final String? orderId; // Add orderId as an optional field

  AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.sentBy,
    required this.type,
    this.orderId, // Make it optional to support other notification types
  });

  factory AppNotification.fromDocument(DocumentSnapshot doc) {
    String typeStr = doc['type'] ?? 'invite';
    NotificationType notifType = typeStr == 'discount'
        ? NotificationType.discount
        : NotificationType.invite;

    return AppNotification(
      id: doc.id,
      userId: doc['userId'] ?? '',
      title: doc['title'] ?? '',
      body: doc['body'] ?? '',
      timestamp: (doc['timestamp'] as Timestamp).toDate(),
      sentBy: doc['sentBy'] ?? 'unknown',
      type: notifType,
      orderId: doc['orderId'], // Extract orderId from the database
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
      'timestamp': Timestamp.fromDate(timestamp),
      'sentBy': sentBy,
      'type': type == NotificationType.discount ? 'discount' : 'invite',
      'orderId': orderId, // Include orderId in the database representation
    };
  }
}
