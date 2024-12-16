class MenuItem {
  String id;
  String name;
  double price;
  String description;
  List<String> variants;
  Map<String, double> extras;
  double discount;
  List<String> reviewIds;
  String imageUrl;

  MenuItem({
    this.id = '',
    required this.name,
    required this.price,
    required this.description,
    required this.variants,
    required this.extras,
    required this.discount,
    required this.reviewIds,
    required this.imageUrl,
  });

  // To convert a MenuItem to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'variants': variants,
      'extras': extras,
      'discount': discount,
      'reviewIds': reviewIds,
      'imageUrl': imageUrl,
    };
  }

  factory MenuItem.fromMap(Map<String, dynamic> map, String documentId) {
    return MenuItem(
      id: documentId,
      name: map['name'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      description: map['description'] ?? '',
      variants: List<String>.from(map['variants'] ?? []),
      extras: (map['extras'] as Map?)?.map((key, value) =>
              MapEntry(key.toString(), (value ?? 0.0).toDouble())) ??
          {},
      discount: (map['discount'] ?? 0.0).toDouble(),
      reviewIds: List<String>.from(map['reviewIds'] ?? []),
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
