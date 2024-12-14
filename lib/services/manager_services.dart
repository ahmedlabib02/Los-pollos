// lib/services/restaurant_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant_model.dart';

class ManagerServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath =
      'restaurants'; // Firestore collection for restaurants

  /// Adds a new restaurant to Firestore
  Future<void> addRestaurant(Restaurant restaurant) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(restaurant.id)
          .set(restaurant.toMap());
    } catch (e) {
      throw Exception('Error adding restaurant: $e');
    }
  }

  /// Retrieves a restaurant by ID
  Future<Restaurant?> getRestaurant(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(collectionPath).doc(id).get();
      if (doc.exists) {
        return Restaurant.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching restaurant: $e');
    }
  }

  /// Streams real-time updates of a restaurant by ID
  Stream<Restaurant?> streamRestaurant(String id) {
    return _firestore.collection(collectionPath).doc(id).snapshots().map((doc) {
      if (doc.exists) {
        return Restaurant.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    });
  }

  /// Updates an existing restaurant's information
  Future<void> updateRestaurant(Restaurant restaurant) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(restaurant.id)
          .update(restaurant.toMap());
    } catch (e) {
      throw Exception('Error updating restaurant: $e');
    }
  }

  /// Deletes a restaurant from Firestore
  Future<void> deleteRestaurant(String id) async {
    try {
      await _firestore.collection(collectionPath).doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting restaurant: $e');
    }
  }
}
