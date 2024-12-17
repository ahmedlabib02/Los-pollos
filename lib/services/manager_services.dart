// lib/services/restaurant_service.dart

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:los_pollos_hermanos/models/bill_model.dart';
import 'package:los_pollos_hermanos/models/menu_item_model.dart';
import 'package:los_pollos_hermanos/models/menu_model.dart';
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

  /// Creates a new [MenuItem] in Firestore, updates the corresponding
  /// [Menu] document to include the new item in the specified category.
  ///
  /// [restaurantId] - The ID of the [Restaurant] document.
  /// [category] - The category to which the new menu item belongs.
  /// [menuItem] - The item data (excluding Firestore doc ID) to be created.
  /// [imageFile] - Optional image file to upload to Firebase Storage.
  ///
  /// Returns the newly created [MenuItem] with its assigned Firestore doc ID and image URL.
  Future<MenuItem> createMenuItemForRestaurant({
    required String restaurantId,
    required String category,
    required MenuItem menuItem,
    File? imageFile,
  }) async {
    try {
      // 1. Fetch the Restaurant to get the menuId.
      DocumentSnapshot restaurantSnapshot =
          await _firestore.collection('restaurants').doc(restaurantId).get();

      if (!restaurantSnapshot.exists) {
        throw Exception('Restaurant with ID $restaurantId does not exist.');
      }

      Restaurant restaurant = Restaurant.fromMap(
        restaurantSnapshot.data() as Map<String, dynamic>,
        restaurantSnapshot.id,
      );

      // 2. (Optional) Upload the image to Firebase Storage if present.
      String imageUrl = menuItem.imageUrl;
      if (imageFile != null) {
        // Create a unique path in storage, e.g. /menuItems/{some_unique_id}
        String storagePath =
            'menuItems/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';

        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child(storagePath)
            .putFile(imageFile);
        TaskSnapshot snapshot = await uploadTask;
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      // 3. Create the MenuItem document in Firestore (in `menuItems` collection).
      //    Firestore will auto-generate the ID if you use add().
      final menuItemRef = await _firestore.collection('menuItems').add({
        'name': menuItem.name,
        'price': menuItem.price,
        'description': menuItem.description,
        'variants': menuItem.variants,
        'extras': menuItem.extras,
        'discount': menuItem.discount,
        'reviewIds': menuItem.reviewIds,
        'imageUrl': imageUrl, // The final image URL (download URL if uploaded)
      });

      // 4. After creation, read back the doc to get the newly assigned ID.
      final newMenuItemDoc = await menuItemRef.get();
      final createdMenuItemId = newMenuItemDoc.id;

      // 5. Now, we update the Menu document to include this new item in the specified category.
      final menuDocRef = _firestore.collection('menus').doc(restaurant.menuId);

      DocumentSnapshot menuSnapshot = await menuDocRef.get();
      if (!menuSnapshot.exists) {
        throw Exception('Menu with ID ${restaurant.menuId} does not exist.');
      }

      Menu menu = Menu.fromMap(
        menuSnapshot.data() as Map<String, dynamic>,
        menuSnapshot.id,
      );

      // Add the new item ID to the relevant category list.
      menu.categories[category] ??=
          []; // If category doesn't exist yet, initialize it
      menu.categories[category]!.add(createdMenuItemId);

      // Update the Menu in Firestore
      await menuDocRef.update({
        'categories': menu.categories,
      });

      // 6. Return the newly created MenuItem with the assigned Firestore ID and final image URL
      return MenuItem(
        id: createdMenuItemId,
        name: menuItem.name,
        price: menuItem.price,
        description: menuItem.description,
        variants: menuItem.variants,
        extras: menuItem.extras,
        discount: menuItem.discount,
        reviewIds: menuItem.reviewIds,
        imageUrl: imageUrl,
      );
    } catch (e) {
      rethrow; // Pass the error up for the UI to handle
    }
  }

  Future<void> deleteMenuItemForRestaurant({
    required String restaurantId,
    required MenuItem menuItem,
    required String category,
  }) async {
    try {
      // 1. Fetch Restaurant doc to get menuId
      final restaurantDoc =
          await _firestore.collection('restaurants').doc(restaurantId).get();
      if (!restaurantDoc.exists) {
        throw Exception('Restaurant with ID $restaurantId not found.');
      }
      final restaurant = Restaurant.fromMap(
        restaurantDoc.data() as Map<String, dynamic>,
        restaurantDoc.id,
      );

      // 2. Fetch the Menu doc by menuId
      final menuDocRef = _firestore.collection('menus').doc(restaurant.menuId);
      final menuDocSnap = await menuDocRef.get();
      if (!menuDocSnap.exists) {
        throw Exception('Menu with ID ${restaurant.menuId} not found.');
      }
      Menu menu = Menu.fromMap(
        menuDocSnap.data() as Map<String, dynamic>,
        menuDocSnap.id,
      );

      // 3. Remove the itemId from the relevant category array
      final itemId = menuItem.id;
      if (menu.categories[category] != null) {
        menu.categories[category]!.remove(itemId);

        // If the category becomes empty, optionally remove it entirely
        if (category != 'Offers' && menu.categories[category]!.isEmpty) {
          menu.categories.remove(category);
        }
      }

      // 4. Update the Menu doc in Firestore
      await menuDocRef.update({'categories': menu.categories});

      // 5. Finally, delete the MenuItem doc
      await _firestore.collection('menuItems').doc(itemId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch all unique category names from a Menu doc by menuId.
  Future<List<String>> getAvailableCategories(String restaurantId) async {
    try {
      // 1. Fetch Restaurant doc to get menuId
      final restaurantDoc =
          await _firestore.collection('restaurants').doc(restaurantId).get();
      if (!restaurantDoc.exists) {
        throw Exception('Restaurant with ID $restaurantId not found.');
      }
      final restaurant = Restaurant.fromMap(
        restaurantDoc.data() as Map<String, dynamic>,
        restaurantDoc.id,
      );

      // 2. Fetch the Menu doc by menuId
      final menuDocRef = _firestore.collection('menus').doc(restaurant.menuId);
      final menuDocSnap = await menuDocRef.get();
      if (!menuDocSnap.exists) {
        throw Exception('Menu with ID ${restaurant.menuId} not found.');
      }
      Menu menu = Menu.fromMap(
        menuDocSnap.data() as Map<String, dynamic>,
        menuDocSnap.id,
      );
      String menuId = menu.id;
      DocumentSnapshot menuDoc =
          await _firestore.collection('menus').doc(menuId).get();

      if (!menuDoc.exists) {
        return []; // or throw an error, as you prefer
      }

      Map<String, dynamic>? data = menuDoc.data() as Map<String, dynamic>?;
      if (data == null || data['categories'] == null) {
        return [];
      }

      // 'categories' is presumably a Map<String, dynamic> or Map<String, List<String>>
      Map<String, dynamic> categoriesMap = data['categories'];
      // The unique category names are the keys of categoriesMap
      List<String> categoryNames = categoriesMap.keys.toList();

      return categoryNames;
    } catch (e) {
      rethrow;
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
          orderItems.add(
              OrderItem.fromMap(doc.data() as Map<String, dynamic>, doc.id));
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
          bills.add(Bill.fromMap(doc.data() as Map<String, dynamic>, doc.id));
        }
      }
      return bills;
    } catch (e) {
      print('Error getting table bills: $e');
      throw e;
    }
  }

  Future<void> updateOrderItemStatus({
    required String orderItemId,
    required OrderStatus status,
  }) async {
    await FirebaseFirestore.instance
        .collection('orderItems')
        .doc(orderItemId)
        .update({'status': status.name});
  }
}
