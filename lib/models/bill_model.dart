class Bill {
  String id;
  List<String> orderItemIds;
  double amount;
  bool isPaid;
  String userId;

  Bill({
    required this.id,
    required this.orderItemIds,
    required this.amount,
    required this.isPaid,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderItemIds': orderItemIds,
      'amount': amount,
      'isPaid': isPaid,
      'userId': userId,
    };
  }

  factory Bill.fromMap(Map<String, dynamic> map) {
    return Bill(
      id: map['id'],
      orderItemIds: List<String>.from(map['orderItemIds']),
      amount: map['amount'],
      isPaid: map['isPaid'],
      userId: map['userId'],
    );
  }
}