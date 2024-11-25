// lib/services/auth.dart

import 'package:firebase_auth/firebase_auth.dart';
import '../models/customUser.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Convert Firebase User to CustomUser
  CustomUser? _userFromFirebaseUser(User? user) {
    return user != null ? CustomUser(uid: user.uid) : null;
  }

  // Stream to listen to authentication state changes
  Stream<CustomUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
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

      // Convert and return the custom user
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      print('FirebaseAuthException: ${e.message}');
      throw e; // Rethrow the exception to handle it in the UI
    } catch (e) {
      // Handle other errors
      print('SignIn Error: $e');
      throw e; // Rethrow the exception to handle it in the UI
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('User signed out successfully.');
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      print('FirebaseAuthException during sign out: ${e.message}');
      throw e;
    } catch (e) {
      // Handle other errors
      print('SignOut Error: $e');
      throw e;
    }
  }

  // Optional: Register with email and password
  Future<CustomUser?> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Register the user with email and password
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? user = result.user;

      // Convert and return the custom user
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      print('FirebaseAuthException: ${e.message}');
      throw e;
    } catch (e) {
      // Handle other errors
      print('Registration Error: $e');
      throw e;
    }
  }
}
