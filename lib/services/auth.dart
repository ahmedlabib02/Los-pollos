// lib/services/auth.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/restaurant_model.dart';
import 'package:los_pollos_hermanos/services/manager_services.dart';
import 'package:los_pollos_hermanos/services/notification_services.dart';
import '../models/customUser.dart';
import '../models/client_model.dart';
import 'client_services.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ClientService _clientService = ClientService();
  final ManagerServices _managerServices = ManagerServices();
  final NotificationService _notificationService = NotificationService();

  // Convert Firebase User to CustomUser with role
  Future<CustomUser?> _userFromFirebaseUser(User? user) async {
    if (user == null) return null;

    // Check if user is a client
    Client? client = await _clientService.getClient(user.uid);
    if (client != null) {
      return CustomUser(uid: user.uid, role: 'client');
    }

    // Check if user is a manager
    Restaurant? restaurant = await _managerServices.getRestaurant(user.uid);

    if (restaurant != null) {
      return CustomUser(uid: user.uid, role: 'manager');
    }

    // If not found in either, return user with no role
    return CustomUser(uid: user.uid, role: null);
  }

  // Stream to listen to authentication state changes and include role
  Stream<CustomUser?> get user {
    return _auth.authStateChanges().asyncMap(_userFromFirebaseUser);
  }

  // Sign in with email and password
  Future<CustomUser?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in the user with email and password
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? user = result.user;

      // Get user with role
      return await _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      rethrow; // Handle in UI
    } catch (e) {
      if (kDebugMode) {
        print('SignIn Error: $e');
      }
      rethrow; // Handle in UI
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      final uid = _auth.currentUser?.uid;
      await _notificationService.deleteFcmToken(uid);
      _notificationService.dispose();

      // Sign out the user
      await _auth.signOut();

      // Dispose of notification listeners
      _notificationService.dispose();

      if (kDebugMode) {
        print('User signed out successfully.');
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('FirebaseAuthException during sign out: ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('SignOut Error: $e');
      }
      rethrow;
    }
  }

  // Register Client and add to Firestore
  Future<CustomUser?> registerClient({
    required String email,
    required String password,
    required String name, // Added name parameter
    required String imageUrl,
  }) async {
    try {
      // Register the user with email and password
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? user = result.user;

      // Create a Client object
      Client newClient = Client(
        userID: user!.uid,
        imageUrl: imageUrl,
        name: name,
        email: email,
        pastBillsIDs: [],
        currentTableID: '',
      );

      // Add the client to Firestore using ClientService
      await _clientService.addClient(newClient);

      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('FirebaseAuthException: ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Registration Error: $e');
      }
      rethrow;
    }
  }
}
