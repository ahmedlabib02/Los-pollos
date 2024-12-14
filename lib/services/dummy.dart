import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:los_pollos_hermanos/models/order_item_model.dart';

class DummyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to populate dummy order items in Firestore
  Future<void> populateDummy(int itemCount) async {
    final List<String> menuItemIds = [
      '3sXDXoKSz6mmL7ePJdVl',
      '8TIVWBFQE4u4kw8txuAL',
      '92Arcge8w0FncEvrgNSM',
      'ANb6xQg9bVyCM1Dn1x69',
      'Cg258hP81rSvkVGejowj',
      'ErTOLm1XTepIm9rxsFL9',
      'OB1FTRIpRjT8BSlHUszC',
      'cK4UseFoAmDR3crI3cqN',
      'ci1Hdc6iE003mj02KUpc',
    ];

    final List<OrderStatus> statuses = [
      OrderStatus.accepted,
      OrderStatus.inProgress,
      OrderStatus.served,
    ];

    final Random random = Random();

    for (int i = 0; i < itemCount; i++) {
      // Select a random menu item
      final menuItem = menuItemIds[random.nextInt(menuItemIds.length)];

      // Generate random values
      OrderStatus status = statuses[random.nextInt(statuses.length)];

      int itemQuantity =
          random.nextInt(3) + 1; // Random quantity between 1 and 3

      // Create an OrderItem object
      OrderItem orderItem = OrderItem(
        id: '', // Firestore will auto-generate this
        userIds: ['9J1G53aUWiUVLEWjl4b1wxXwsJj1'],
        menuItemId: menuItem,
        tableId: '1NpOwtwTXls1HLAwmGyK',
        status: status,
        itemCount: itemQuantity,
        notes: ['No onions', 'Extra cheese'], // Example notes
        price: 10.0 * itemQuantity, // Multiply price by quantity
      );

      try {
        // Add the OrderItem to Firestore
        await _firestore.collection('orders').add(orderItem.toMap());
        print('Order item added successfully: ${orderItem.name}');
      } catch (e) {
        print('Failed to add order item: $e');
      }
    }
  }
}
