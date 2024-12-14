// lib/models/restaurant.dart

class Restaurant {
  final String id; // Firestore document ID
  final String name;
  final String menuID;

  Restaurant({
    required this.id,
    required this.name,
    required this.menuID,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'menuID': menuID,
    };
  }

  // Create a Restaurant instance from Firestore map data and document ID
  factory Restaurant.fromMap(Map<String, dynamic> map, String documentId) {
    return Restaurant(
      id: documentId,
      name: map['name'] ?? '',
      menuID: map['menuID'] ?? '',
    );
  }
}
