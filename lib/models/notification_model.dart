// lib/models/notification_model.dart

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final String sentBy; // manager or restaurant ID

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.sentBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'sentBy': sentBy,
    };
  }

  // Create AppNotification from a Map retrieved from Firestore
  factory AppNotification.fromMap(Map<String, dynamic> map, String id) {
    return AppNotification(
      id: id,
      title: map['title'],
      body: map['body'],
      timestamp: DateTime.parse(map['timestamp']),
      sentBy: map['sentBy'],
    );
  }
}
