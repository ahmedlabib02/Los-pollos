class MenuItem {
  String id;
  String name;
  double price;
  String description;
  List<String> extras;
  double discount;
  List<String> reviewIds;
  String? imageUrl;

  MenuItem({
    this.id = '',
    required this.name,
    required this.price,
    required this.description,
    required this.extras,
    required this.discount,
    required this.reviewIds,
    this.imageUrl,
  });

  // To convert a MenuItem to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'extras': extras,
      'discount': discount,
      'reviewIds': reviewIds,
      'imageUrl': imageUrl,
    };
  }

  // To convert a Map back to a MenuItem
  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id'] ?? '',
      name: map['name'],
      price: map['price'],
      description: map['description'],
      extras: List<String>.from(map['extras']),
      discount: map['discount'],
      reviewIds: List<String>.from(map['reviewIds']),
      imageUrl: map['imageUrl'],
    );
  }
}
