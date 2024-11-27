// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:los_pollos_hermanos/screens/wrapper.dart';
import 'package:los_pollos_hermanos/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:los_pollos_hermanos/models/customUser.dart';
import 'package:los_pollos_hermanos/shared/loadingScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Initialize Firebase in a Future
  Future<FirebaseApp> _initializeFirebase() async {
    return await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeFirebase(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Error initializing Firebase')),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<CustomUser?>.value(
            value: AuthService().user,
            initialData: null,
            catchError: (context, error) => null,
            child: MaterialApp(
              title: 'Los Pollos Hermanos',
              theme: ThemeData(
                primarySwatch: Colors.brown,
              ),
              home: const Wrapper(),
            ),
          );
        }

        return const MaterialApp(
          home: Loading(),
        );
      },
    );
  }
}
