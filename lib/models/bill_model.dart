class Bill {
  String id;
  List<String> orderItemIds;
  double amount;
  bool isPaid;
  String userId;
  String
      restaurantId; // New field to track the restaurant associated with the bill

  Bill({
    required this.id,
    required this.orderItemIds,
    required this.amount,
    required this.isPaid,
    required this.userId,
    required this.restaurantId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderItemIds': orderItemIds,
      'amount': amount,
      'isPaid': isPaid,
      'userId': userId,
      'restaurantId': restaurantId, // Add to map conversion
    };
  }

  factory Bill.fromMap(Map<String, dynamic> map, String documentId) {
    return Bill(
      id: documentId,
      orderItemIds: List<String>.from(map['orderItemIds']),
      amount: (map['amount'] is int)
          ? (map['amount'] as int).toDouble() // Convert int to double
          : map['amount'],
      isPaid: map['isPaid'],
      userId: map['userId'],
      restaurantId: map['restaurantId'],
    );
  }
}
