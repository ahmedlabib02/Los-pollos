// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:los_pollos_hermanos/provider/selected_restaurant_provider.dart';
import 'package:los_pollos_hermanos/provider/table_state_provider.dart';
import 'package:los_pollos_hermanos/screens/wrapper.dart';
import 'package:los_pollos_hermanos/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:los_pollos_hermanos/models/customUser.dart';
import 'package:los_pollos_hermanos/shared/loadingScreen.dart';
//import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:google_fonts/google_fonts.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/.env");
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SelectedRestaurantProvider()),
        ChangeNotifierProvider(create: (_) => TableState())
      ],
      child: const MyApp(),
    ),
  );
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
          return MultiProvider(
            providers: [
              StreamProvider<CustomUser?>.value(
                value: AuthService().user,
                initialData: null,
                catchError: (context, error) => null,
              ),
              ChangeNotifierProvider(
                create: (_) => SelectedRestaurantProvider(),
              ),
            ],
            child: MaterialApp(
              title: 'Los Pollos Hermanos',
              theme: ThemeData(
                primarySwatch: Colors.brown,

                // scaffoldBackgroundColor: Color.fromARGB(
                // 255, 246, 246, 246), // Set global background color
                scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
                textTheme: GoogleFonts.madaTextTheme(), // default font for app
                // primaryTextTheme: GoogleFonts.madaTextTheme(),
                // textSelectionTheme: TextSelectionThemeData(
                // cursorColor: const Color.fromARGB(
                // 255, 0, 0, 0), // Change this to the color you want
                // ),
                inputDecorationTheme: InputDecorationTheme(
                  focusColor: Colors.green,
                ),
              ),
              home: const Wrapper(),
            ),
          );
        }

        return const MaterialApp(
          home: Loading(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
