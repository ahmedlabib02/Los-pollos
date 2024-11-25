// lib/screens/home/home.dart

import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/services/auth.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await _auth.signOut();
                // Optionally show a confirmation message
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
      body: const Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}
