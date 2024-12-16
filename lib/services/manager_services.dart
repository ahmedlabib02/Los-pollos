// lib/services/restaurant_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:los_pollos_hermanos/models/bill_model.dart';
import 'package:los_pollos_hermanos/models/order_item_model.dart';
import 'package:los_pollos_hermanos/models/table_model.dart';
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

  /// Retrieves all restaurants (optional)
  Future<List<Restaurant>> getAllRestaurants() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection(collectionPath).get();
      return snapshot.docs
          .map((doc) =>
              Restaurant.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error fetching restaurants: $e');
    }
  }

  // ------------------  Tables Operations ---------------------------
  Future<List<Table>> getCurrentTables(String restaurantId) async {
    try {
      QuerySnapshot tablesSnapshot = await _firestore
          .collection('tables')
          .where('restaurantId', isEqualTo: restaurantId)
          .where('isOngoing', isEqualTo: true)
          .get();

      return tablesSnapshot.docs
          .map((doc) => Table.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting current tables: $e');
      throw e;
    }
  }

  Future<List<Table>> getPastTables(String restaurantId) async {
    try {
      QuerySnapshot tablesSnapshot = await _firestore
          .collection('tables')
          .where('restaurantId', isEqualTo: restaurantId)
          .where('isOngoing', isEqualTo: false)
          .get();

      return tablesSnapshot.docs
          .map((doc) => Table.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting past tables: $e');
      throw e;
    }
  }

  Future<List<OrderItem>> getTableOrderItems(String tableId) async {
    try {
      DocumentSnapshot tableSnapshot =
          await _firestore.collection('tables').doc(tableId).get();

      List<String> orderItemIds = List<String>.from(
          (tableSnapshot.data()! as Map<String, dynamic>)['orderItemIds']);

      List<OrderItem> orderItems = [];

      // Firestore `whereIn` can only accept up to 10 items per query
      const int batchSize = 10;
      for (int i = 0; i < orderItemIds.length; i += batchSize) {
        // Get a batch of 10 order item IDs (or fewer for the last batch)
        List<String> batch = orderItemIds.skip(i).take(batchSize).toList();

        // Fetch the documents in the current batch
        QuerySnapshot batchSnapshot = await _firestore
            .collection('orderItems')
            .where(FieldPath.documentId, whereIn: batch)
            .get();

        // Add the documents to the orderItems list
        for (var doc in batchSnapshot.docs) {
          orderItems.add(OrderItem.fromMap(doc.data() as Map<String, dynamic>));
        }
      }
      return orderItems;
    } catch (e) {
      print('Error getting table order items: $e');
      throw e;
    }
  }

  Future<List<Bill>> getTableBills(String tableId) async {
    try {
      DocumentSnapshot tableSnapshot =
          await _firestore.collection('tables').doc(tableId).get();

      List<String> billIds = List<String>.from(
          (tableSnapshot.data()! as Map<String, dynamic>)['billIds']);

      List<Bill> bills = [];

      // Firestore `whereIn` can only accept up to 10 items per query
      const int batchSize = 10;
      for (int i = 0; i < billIds.length; i += batchSize) {
        // Get a batch of 10 bill IDs (or fewer for the last batch)
        List<String> batch = billIds.skip(i).take(batchSize).toList();

        // Fetch the documents in the current batch
        QuerySnapshot batchSnapshot = await _firestore
            .collection('bills')
            .where(FieldPath.documentId, whereIn: batch)
            .get();

        // Add the documents to the bills list
        for (var doc in batchSnapshot.docs) {
          bills.add(Bill.fromMap(doc.data() as Map<String, dynamic>));
        }
      }
      return bills;
    } catch (e) {
      print('Error getting table bills: $e');
      throw e;
    }
  }

  
}
