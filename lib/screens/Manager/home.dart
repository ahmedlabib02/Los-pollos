// lib/screens/manager_home.dart

import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/services/auth.dart';
import 'package:los_pollos_hermanos/services/notification_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:los_pollos_hermanos/models/customUser.dart';

class ManagerHome extends StatefulWidget {
  const ManagerHome({Key? key}) : super(key: key);

  @override
  _ManagerHomeState createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  final AuthService _auth = AuthService();
  final NotificationService _notificationService = NotificationService();

  // Example User ID for testing
  final String testUserId = "testUser123";

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

            // Button to Create Offer
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance.collection('offers').add({
                    'description': '20% off on all chicken meals!',
                    'createdAt': FieldValue.serverTimestamp(),
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Offer created in Firestore!')),
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

            ElevatedButton(
              onPressed: () async {
                try {
                  await _notificationService.sendNotificationToTopic(
                    'offers',
                    'Hot Deal!',
                    'Grab 30% off on all items now!',
                    'manager123',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Offers notification sent successfully!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('Send Offers Notification'),
            ),
            const SizedBox(height: 20),

            // Button to send Notification to a specific user
            // ElevatedButton(
            //   onPressed: () async {
            //     try {
            //       await _notificationService.sendNotificationToTopic(
            //         'offers',
            //         'Special Invitation!',
            //         'fuck off will you',
            //         'manager123',
            //       );
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         const SnackBar(
            //             content: Text('Notification sent to specific user!')),
            //       );
            //     } catch (e) {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(
            //             content: Text('Failed to send user notification: $e')),
            //       );
            //     }
            //   },
            //   child: const Text('Send User Notification'),
            // ),
          ],
        ),
      ),
    );
  }
}
