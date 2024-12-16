// Dummy Services
import 'package:cloud_firestore/cloud_firestore.dart';

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
