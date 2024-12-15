class Restaurant {
  final String id; // Firestore document ID
  final String name;
  final String menuId;
  final String category;
  final String? imageUrl; // Nullable imageUrl field

  Restaurant({
    required this.id,
    required this.name,
    required this.menuId,
    required this.category,
    this.imageUrl, // Optional
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'menuId': menuId,
      'category': category,
      'imageUrl': imageUrl, // Add imageUrl to Firestore data
    };
  }

  factory Restaurant.fromMap(Map<String, dynamic> map, String documentId) {
    return Restaurant(
      id: documentId,
      name: map['name'] ?? '',
      menuId: map['menuId'] ?? '',
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'], // Extract imageUrl from Firestore
    );
  }
}
