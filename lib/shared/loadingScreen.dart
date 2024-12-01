import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Scaffold is now under MaterialApp, so Directionality is provided
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
