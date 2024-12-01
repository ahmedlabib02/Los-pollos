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
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'],
      userIds: List<String>.from(map['userIds']),
      menuItemId: map['menuItemId'],
      tableId: map['tableId'],
      status: OrderStatus.values
          .firstWhere((e) => e.toString().split('.').last == map['status']),
      itemCount: map['itemCount'],
      notes: List<String>.from(map['notes']),
      price: map['price'],
      name: map['name'],
    );
  }
}
