import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:los_pollos_hermanos/models/order_item_model.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> populateDummyMenuItems() async {
  List<Map<String, dynamic>> dummyMenuItems = [
    // {
    //   'description': 'Delicious grilled chicken with a side of fries',
    //   'discount': 0.1,
    //   'extras': {
    //     'Extra sauce': 0.5,
    //     'Cheese': 1.0,
    //   },
    //   'imageUrl':
    //       'https://kristineskitchenblog.com/wp-content/uploads/2023/05/grilled-chicken-recipe-25-500x500.jpg',
    //   'name': 'Grilled Chicken',
    //   'price': 12.99,
    //   'reviewIds': [],
    //   'variants': ['Spicy', 'Regular'],
    // },
    // {
    //   'description': 'Juicy beef burger with lettuce and tomato',
    //   'discount': 0.15,
    //   'extras': {
    //     'Bacon': 1.5,
    //     'Avocado': 1.0,
    //   },
    //   'imageUrl':
    //       'https://www.seriouseats.com/thmb/uSNXjlR9pQU0Nt9HJTzD2ZhZ45Y=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__serious_eats__seriouseats.com__images__2015__07__20150728-homemade-whopper-food-lab-35-b3500a5c2f3e4e10aa3169d5f76e1468.jpg',
    //   'name': 'Beef Burger',
    //   'price': 10.99,
    //   'reviewIds': [],
    //   'variants': ['Double', 'Single'],
    // },
    // {
    //   'description': 'Fresh garden salad with a variety of vegetables',
    //   'discount': 0.05,
    //   'extras': {
    //     'Croutons': 0.5,
    //     'Feta Cheese': 1.0,
    //   },
    //   'imageUrl':
    //       'https://betterfoodguru.com/wp-content/uploads/2024/05/garden-salad-3.jpg',
    //   'name': 'Garden Salad',
    //   'price': 8.99,
    //   'reviewIds': [],
    //   'variants': ['Large', 'Small'],
    // },
    // {
    //   'description': 'Classic margherita pizza with fresh basil',
    //   'discount': 0.2,
    //   'extras': {
    //     'Extra Cheese': 1.5,
    //     'Olives': 1.0,
    //   },
    //   'imageUrl':
    //       'https://www.acouplecooks.com/wp-content/uploads/2022/10/Margherita-Pizza-093.jpg',
    //   'name': 'Margherita Pizza',
    //   'price': 14.99,
    //   'reviewIds': [],
    // },
    // {
    //   'description': 'Creamy pasta with a rich Alfredo sauce',
    //   'discount': 0.1,
    //   'extras': {
    //     'Grilled Chicken': 2.0,
    //     'Mushrooms': 1.0,
    //   },
    //   'imageUrl':
    //       'https://www.allrecipes.com/thmb/gTibTRJ8MW87L0jMhAvXPjIDD94=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/19402-quick-and-easy-alfredo-sauce-DDMFS-4x3-17abb2055c714807944172db9172b045.jpg',
    //   'name': 'Alfredo Pasta',
    //   'price': 13.99,
    //   'reviewIds': [],
    // },
    {
      'description': 'Spaghetti Carbonara with crispy pancetta',
      'discount': 0.1,
      'extras': {
        'Extra Parmesan': 100,
        'Garlic Bread': 150,
      },
      'variants': {
        'Spicy',
        'Regular',
      },
      'imageUrl': 'https://www.simplyrecipes.com/thmb/2v1G8yZ5v5J5Z5J',
      'name': 'Spaghetti Carbonara',
    },
    {
      'description': 'Penne Arrabbiata with spicy tomato sauce',
      'discount': 0.2,
      'extras': {
        'Extra Chili': 50,
        'Parmesan': 200,
      },
      'imageUrl':
          'https://www.recipetineats.com/wp-content/uploads/2016/05/Penne-Arrabbiata_0.jpg',
      'name': 'Penne Arrabbiata',
    },
    {
      'description': 'Fettuccine Alfredo with creamy sauce',
      'discount': 0,
      'extras': {
        'Grilled Chicken': 100,
        'Broccoli': 20,
      },
      'imageUrl':
          'https://www.simplyrecipes.com/thmb/2v1G8yZ5v5J5Z5J5v1G8yZ5v5J5Z5J5v1G8yZ5v5J5Z5J5.jpg',
      'name': 'Fettuccine Alfredo',
      'price': 14.99,
      'reviewIds': [],
    },
    {
      'description': 'Lasagna with layers of cheese and meat sauce',
      'discount': 0.15,
      'extras': {
        'Extra Cheese': 50,
        'Garlic Bread': 30,
      },
      'imageUrl':
          'https://www.simplyrecipes.com/thmb/2v1G8yZ5v5J5Z5J5v1G8yZ5v5J5Z5J5v1G8yZ5v5J5Z5J5.jpg',
      'name': 'Specialty Lasagna',
      'price': 160,
      'reviewIds': [],
    },
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
