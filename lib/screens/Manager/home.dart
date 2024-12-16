import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/services/auth.dart';
import 'package:los_pollos_hermanos/services/notification_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore if needed

class ManagerHome extends StatefulWidget {
  const ManagerHome({Key? key}) : super(key: key);

  @override
  _ManagerHomeState createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  final AuthService _auth = AuthService();
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.init(context);
  }

  @override
  void dispose() {
    _notificationService.dispose();
    super.dispose();
  }

  // Example FCM token provided (used for testing)
  final String testFcmToken =
      "fhHY3iUbT0WSOboq7uGed_:APA91bFnLYmoVx8n3_uNH1FzUAqpylqlN0F2PDu-K7t1hj7l4_F_3ViqtHEfFipbI5InKiIY876ozvmcw1JQxGcCUa1eb-PUj_mVSTRLIlcFkusSdy_G_Xk";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hey Boss'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await _auth.signOut();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signed out successfully')),
                );
              } catch (e) {
                // Handle sign-out errors
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error signing out')),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to the Home Screen!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Removed userIds as it's no longer needed
                  // If you still want to send to specific users, keep this button
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Use the Offers Notification button instead')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Failed to send discount notifications')),
                  );
                }
              },
              child: const Text('Send Discount Notifications (Deprecated)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  // For testing: Create a new offer in Firestore
                  // This can trigger another Cloud Function if set up
                  await FirebaseFirestore.instance.collection('offers').add({
                    'description': '20% off on all chicken meals!',
                    'createdAt': FieldValue.serverTimestamp(),
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Offer created and notification sent!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to create offer')),
                  );
                }
              },
              child: const Text('Create Offer'),
            ),
            const SizedBox(height: 20),
            // New button to send notification to "offers" topic
            ElevatedButton(
              onPressed: () async {
                try {
                  await _notificationService.sendOffersNotification(
                    title: 'New Offer!',
                    body: 'Check out our latest 30% discount on all meals.',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Offers notification sent!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Failed to send offers notification')),
                  );
                }
              },
              child: const Text('Send Offers Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
