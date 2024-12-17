import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/notification_model.dart';
import 'package:los_pollos_hermanos/models/customUser.dart';
import 'package:los_pollos_hermanos/provider/selected_restaurant_provider.dart';
import 'package:los_pollos_hermanos/screens/wrapper.dart';
import 'package:los_pollos_hermanos/services/auth.dart';
import 'package:los_pollos_hermanos/services/client_services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Formats the timestamp to a readable string.
  String _formatTimestamp(DateTime timestamp) {
    final DateFormat formatter = DateFormat('h:mm a · MMM d');
    return formatter.format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    final CustomUser? currentUser = Provider.of<CustomUser?>(context);

    if (currentUser == null) {
      return Scaffold(
        body: const Center(
          child: Text('You must be logged in to view notifications.'),
        ),
      );
    }

    final ClientService clientService = ClientService();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Updates",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26.0,
              )),
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0, // Primary Yellow
          elevation: 0,
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Color.fromRGBO(239, 180, 7, 1),
            labelColor: Colors.black,
            unselectedLabelColor: const Color.fromARGB(137, 47, 47, 47),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'All Notifications'),
              Tab(text: 'Invites'),
            ],
          ),
        ),
        body: FutureBuilder<List<AppNotification>>(
          future: clientService.getNotifications(currentUser.uid),
          builder: (BuildContext context,
              AsyncSnapshot<List<AppNotification>> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child:
                    Text('Something went wrong while fetching notifications.'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No notifications available.'),
              );
            }

            // Notifications list
            List<AppNotification> notifications = snapshot.data!;
            notifications.sort(
                (a, b) => b.timestamp.compareTo(a.timestamp)); // Sort by time

            // Separate invites for the second tab
            List<AppNotification> invites = notifications
                .where((notif) => notif.type == NotificationType.invite)
                .toList();

            return TabBarView(
              controller: _tabController,
              children: [
                _buildNotificationsList(notifications, context, currentUser),
                _buildNotificationsList(invites, context, currentUser),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Builds the notification list view.
  Widget _buildNotificationsList(List<AppNotification> notifications,
      BuildContext context, CustomUser currentUser) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        AppNotification notification = notifications[index];
        return _buildNotificationTile(notification, context, currentUser);
      },
    );
  }

  /// Builds a single notification tile.
  Widget _buildNotificationTile(AppNotification notification,
      BuildContext context, CustomUser currentUser) {
    return FutureBuilder<String?>(
      future: ClientService()
          .getUserImage(notification.sentBy, notification.type), // Pass type
      builder: (context, snapshot) {
        String imageUrl = snapshot.data ??
            'https://via.placeholder.com/150'; // Placeholder for missing images

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notification Image
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  const SizedBox(width: 12),

                  // Notification Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.body,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatTimestamp(notification.timestamp),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Accept and Reject Buttons for Invite Type
              if (notification.type == NotificationType.invite) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Accept Button
                    TextButton(
                      onPressed: () async {
                        if (notification.orderId != null) {
                          try {
                            // get restaurant id
                            final String restaurantId =
                                Provider.of<SelectedRestaurantProvider>(context,
                                            listen: false)
                                        .selectedRestaurantId ??
                                    "";
                            await ClientService().acceptInvite(
                                notification.id,
                                notification.orderId!,
                                currentUser
                                    .uid, // Current User ID (to delete the notification)
                                notification.sentBy,
                                restaurantId // Sender ID (to add to userIds)
                                );
                            setState(() {}); // Refresh the notifications list
                          } catch (e) {
                            print("Error accepting invite: $e");
                          }
                        } else {
                          print("Order ID is null. Cannot accept invite.");
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                      child: const Text('Accept'),
                    ),

                    // Reject Button
                    TextButton(
                      onPressed: () async {
                        try {
                          await ClientService().rejectInvite(
                            notification.id,
                            currentUser
                                .uid, // Pass senderId instead of currentUser.uid
                          );
                          setState(() {}); // Refresh the notifications list
                        } catch (e) {
                          print("Error rejecting invite: $e");
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Reject'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
