// lib/screens/notifications_screen.dart

import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/notification_model.dart';
import 'package:los_pollos_hermanos/models/customUser.dart';
import 'package:los_pollos_hermanos/services/client_services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  /// Formats the timestamp to a readable string.
  String _formatTimestamp(DateTime timestamp) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd – kk:mm');
    return formatter.format(timestamp);
  }

  /// Returns the appropriate icon based on the notification type.
  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.discount:
        return Icons.local_offer; // Icon for discounts
      case NotificationType.invite:
      default:
        return Icons.person_add; // Icon for invites
    }
  }

  /// Returns the appropriate color based on the notification type.
  Color _getNotificationColor(NotificationType type, BuildContext context) {
    switch (type) {
      case NotificationType.discount:
        return Colors.green; // Color for discounts
      case NotificationType.invite:
      default:
        return Theme.of(context).primaryColor; // Color for invites
    }
  }

  @override
  Widget build(BuildContext context) {
    final CustomUser? currentUser = Provider.of<CustomUser?>(context);

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
        ),
        body: const Center(
          child: Text('You must be logged in to view notifications.'),
        ),
      );
    }

    final user = Provider.of<CustomUser?>(context);

    // Instantiate ClientService
    final ClientService clientService = ClientService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: FutureBuilder<List<AppNotification>>(
        future: clientService.getNotifications(user!.uid),
        builder: (BuildContext context,
            AsyncSnapshot<List<AppNotification>> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong while fetching notifications.'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Check if there are notifications
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No notifications available.'),
            );
          }

          // Retrieve notifications
          List<AppNotification> notifications = snapshot.data!;

          // Optionally, separate notifications by type
          List<AppNotification> discountNotifications = notifications
              .where((notif) => notif.type == NotificationType.discount)
              .toList();
          List<AppNotification> inviteNotifications = notifications
              .where((notif) => notif.type == NotificationType.invite)
              .toList();

          return ListView(
            children: [
              if (discountNotifications.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Discounts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ),
                ...discountNotifications.map((notification) =>
                    _buildNotificationTile(notification, context)),
              ],
              if (inviteNotifications.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Invites',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                ...inviteNotifications.map((notification) =>
                    _buildNotificationTile(notification, context)),
              ],
            ],
          );
        },
      ),
    );
  }

  /// Builds a notification tile widget.
  Widget _buildNotificationTile(
      AppNotification notification, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: Icon(
          _getNotificationIcon(notification.type),
          color: _getNotificationColor(notification.type, context),
          size: 30,
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _getNotificationColor(notification.type, context),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.body),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  'From: ${notification.sentBy}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  _formatTimestamp(notification.timestamp),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          // Optional: Handle tap on notification
          // For example, navigate to a detailed view based on notification type
          _handleNotificationTap(notification, context);
        },
      ),
    );
  }

  /// Handles the tap action on a notification tile.
  void _handleNotificationTap(
      AppNotification notification, BuildContext context) {
    switch (notification.type) {
      case NotificationType.discount:
        // Navigate to Discount Details Screen
        Navigator.of(context)
            .pushNamed('/discountDetails', arguments: notification);
        break;
      case NotificationType.invite:
        // Navigate to Invite Details Screen
        Navigator.of(context)
            .pushNamed('/inviteDetails', arguments: notification);
        break;
      default:
        // Handle other types or default action
        break;
    }
  }
}
