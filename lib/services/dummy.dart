import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:los_pollos_hermanos/models/order_item_model.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> addDummyMenuItems() async {
  List<Map<String, dynamic>> dummyMenuItems = [
    {
      'description': 'Creamy tomato soup with basil and a hint of garlic',
      'discount': 0.0,
      'extras': {
        'Croutons': 0.5,
        'Extra Cream': 0.7,
      },
      'imageUrl': 'https://example.com/tomato_soup.jpg',
      'name': 'Tomato Soup',
      'price': 5.99,
      'reviewIds': [],
    },
    {
      'description': 'Classic chicken noodle soup with vegetables',
      'discount': 0.0,
      'extras': {
        'Extra Chicken': 1.0,
        'Extra Noodles': 0.8,
      },
      'imageUrl': 'https://example.com/chicken_noodle_soup.jpg',
      'name': 'Chicken Noodle Soup',
      'price': 6.99,
      'reviewIds': [],
    },
    {
      'description': 'Hearty beef stew with potatoes and carrots',
      'discount': 0.0,
      'extras': {
        'Extra Beef': 1.5,
        'Extra Vegetables': 1.0,
      },
      'imageUrl': 'https://example.com/beef_stew.jpg',
      'name': 'Beef Stew',
      'price': 7.99,
      'reviewIds': [],
    },
    {
      'description': 'Minestrone soup with beans, pasta, and vegetables',
      'discount': 0.0,
      'extras': {
        'Extra Beans': 0.7,
        'Extra Pasta': 0.8,
      },
      'imageUrl': 'https://example.com/minestrone_soup.jpg',
      'name': 'Minestrone Soup',
      'price': 6.49,
      'reviewIds': [],
    },
    {
      'description': 'Crispy spring rolls with a sweet chili dipping sauce',
      'discount': 0.0,
      'extras': {
        'Extra Sauce': 0.5,
        'Extra Filling': 1.0,
      },
      'imageUrl': 'https://example.com/spring_rolls.jpg',
      'name': 'Spring Rolls',
      'price': 4.99,
      'reviewIds': [],
    },
    {
      'description': 'Garlic bread with a side of marinara sauce',
      'discount': 0.0,
      'extras': {
        'Extra Garlic': 0.5,
        'Extra Cheese': 1.0,
      },
      'imageUrl': 'https://example.com/garlic_bread.jpg',
      'name': 'Garlic Bread',
      'price': 3.99,
      'reviewIds': [],
    },
    {
      'description': 'Stuffed mushrooms with cheese and herbs',
      'discount': 0.0,
      'extras': {
        'Extra Cheese': 1.0,
        'Extra Herbs': 0.5,
      },
      'imageUrl': 'https://example.com/stuffed_mushrooms.jpg',
      'name': 'Stuffed Mushrooms',
      'price': 5.49,
      'reviewIds': [],
    },
    {
      'description': 'Buffalo wings with a side of blue cheese dressing',
      'discount': 0.0,
      'extras': {
        'Extra Sauce': 0.5,
        'Extra Dressing': 0.7,
      },
      'imageUrl': 'https://example.com/buffalo_wings.jpg',
      'name': 'Buffalo Wings',
      'price': 6.99,
      'reviewIds': [],
    }
  ];
  try {
    for (var menuItem in dummyMenuItems) {
      DocumentReference menuItemRef = _firestore.collection('menuItems').doc();
      await menuItemRef.set(menuItem);
    }
    print("Dummy menu items added successfully");
  } catch (e) {
    print("Failed to add dummy menu items: $e");
  }
}

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

    int itemQuantity = random.nextInt(3) + 1; // Random quantity between 1 and 3

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

Future<void> populateDummyBills(int billCount) async {
  final List<String> orderItemIds = [
    '5kj5f4rUaCwNI6jveHKy',
    '7bE45XeRrIuORVwp3LHc',
    '8rJEqjcg292AT8093e0l',
    'TYGjBe9GvhXo0OqeYkxi',
    'ZySUVcYzJQ634ZhMDa3j',
    'aOK2k6FDNimCLyWG0xMA',
    'cQcH0t5qbivsj3LrW4Qc',
    'dETVc9CWsXjD8uRNqURq',
    'naborhcEU2H6rJBFnhv1',
    'qofcamX2S6WC9JQKtcNt',
    'uvRaNDHYgghCOlxqxJNf',
  ];

  final List<String> restaurantIds = [
    '4DHnQwOzwfPmeWonwVdH',
    '4NOJDueSIhM45IoLnKNr',
    'IDakGl53E6GKhapv86Vw',
    'QwZlcvF69tNwgkRgkknZ',
    'Z46hV8OcSzNIU3HvUT3Z',
    'hbSqJWIoJ2iol2i0dgxB',
    'knPIve2BMTsiItXsrBJA',
    'oZe29EBtKAate7Fa1VQw',
  ];

  final String userId = '9J1G53aUWiUVLEWjl4b1wxXwsJj1';

  final Random random = Random();

  for (int i = 0; i < billCount; i++) {
    // Select a random number of order items
    int numOrderItems = random.nextInt(5) + 1; // Random number between 1 and 5
    List<String> selectedOrderItemIds = List.generate(numOrderItems, (_) {
      return orderItemIds[random.nextInt(orderItemIds.length)];
    });

    // Calculate the amount based on random prices for each order item
    double amount =
        selectedOrderItemIds.length * (random.nextDouble() * 50 + 10);

    // Select a random restaurant ID
    String restaurantId = restaurantIds[random.nextInt(restaurantIds.length)];

    // Create a Bill object
    Map<String, dynamic> billData = {
      'orderItemIds': selectedOrderItemIds,
      'amount':
          double.parse(amount.toStringAsFixed(2)), // Round to 2 decimal places
      'isPaid': true,
      'userId': userId,
      'restaurantId': restaurantId,
    };

    try {
      // Add the bill to Firestore
      await _firestore.collection('bills').add(billData);
      print('Bill added successfully with data: $billData');
    } catch (e) {
      print('Failed to add bill: $e');
    }
  }
}
