import 'dart:convert';

class Table {
  String id;
  bool isTableSplit = false;
  List<String> userIds;
  List<String> orderItemIds;
  List<String> billIds;
  double totalAmount;
  String tableCode;
  bool isOngoing = true;
  String restaurantId = '';

  Table(
      {required this.id,
      required this.isTableSplit,
      required this.userIds,
      required this.orderItemIds,
      required this.billIds,
      required this.totalAmount,
      required this.tableCode,
      required this.isOngoing,
      required this.restaurantId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isTableSplit': isTableSplit,
      'userIds': userIds,
      'orderItemIds': orderItemIds,
      'billIds': billIds,
      'totalAmount': totalAmount,
      'tableCode': tableCode,
      'isOngoing': isOngoing,
      'restaurantId': restaurantId,
    };
  }

  factory Table.fromMap(Map<String, dynamic> map) {
    return Table(
        id: map['id'],
        isTableSplit: map['isTableSplit'],
        userIds: List<String>.from(map['userIds']),
        orderItemIds: List<String>.from(map['orderItemIds']),
        billIds: List<String>.from(map['billIds']),
        totalAmount: (map['totalAmount'] is int)
            ? (map['totalAmount'] as int).toDouble() // Convert int to double
            : map['totalAmount'],
        tableCode: map['tableCode'],
        isOngoing: map['isOngoing'],
        restaurantId: map['restaurantId'] ?? '');
  }

  static String generateTableCode() {
    String code = '';
    for (int i = 0; i < 4; i++) {
      code += String.fromCharCode(
          65 + (DateTime.now().microsecondsSinceEpoch % 26));
    }
    return code;
  }

  @override
  String toString() {
    // Serialize the map to JSON
    return jsonEncode(toMap());
  }
}
