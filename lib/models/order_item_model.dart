enum OrderStatus { accepted, inProgress, served }

class OrderItem {
  String id;
  List<String> userIds;
  String menuItemId;
  String tableId;
  OrderStatus status;
  int itemCount;
  List<String> notes;
  double price;
  String? name; // Add name as an optional field
  String? imageUrl;
  Map<String, double>? extras;

  OrderItem({
    required this.id,
    required this.userIds,
    required this.menuItemId,
    required this.tableId,
    required this.status,
    required this.itemCount,
    required this.notes,
    required this.price,
    this.name,
    this.imageUrl, // Optional
    this.extras,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userIds': userIds,
      'menuItemId': menuItemId,
      'tableId': tableId,
      'status': status.toString().split('.').last,
      'itemCount': itemCount,
      'notes': notes,
      'price': price,
      'name': name,
      'imageUrl': imageUrl,
      'extras': extras,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map, String documentId) {
    return OrderItem(
      id: documentId,
      userIds: List<String>.from(map['userIds']),
      menuItemId: map['menuItemId'],
      tableId: map['tableId'],
      status: OrderStatus.values
          .firstWhere((e) => e.toString().split('.').last == map['status']),
      itemCount: map['itemCount'],
      notes: List<String>.from(map['notes']),
      price: (map['price'] is int)
          ? (map['price'] as int).toDouble() // Convert int to double
          : map['price'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      extras: (map['extras'] as Map?)?.map((key, value) =>
              MapEntry(key.toString(), (value ?? 0.0).toDouble())) ??
          {},
    );
  }
}
