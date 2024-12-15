import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/services/auth.dart';
import 'package:los_pollos_hermanos/services/notification_services.dart';

class ManagerHome extends StatelessWidget {
  const ManagerHome({super.key});

  // Example FCM token provided
  final String fcmToken =
      "fhHY3iUbT0WSOboq7uGed_:APA91bFnLYmoVx8n3_uNH1FzUAqpylqlN0F2PDu-K7t1hj7l4_F_3ViqtHEfFipbI5InKiIY876ozvmcw1JQxGcCUa1eb-PUj_mVSTRLIlcFkusSdy_G_Xk";

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

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
            ElevatedButton(
              onPressed: () async {
                try {
                  // We assume tripId can be anything for testing, e.g. "testTripId"
                  await NotificationService.sendNotificationToSelectedDriver(
                    fcmToken,
                    context,
                    "testTripId",
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notification sent!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Failed to send notification')),
                  );
                }
              },
              child: const Text('Send Test Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
