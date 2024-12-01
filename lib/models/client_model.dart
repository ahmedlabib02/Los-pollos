class Client {
  final String userID;
  final String name;
  final String email;
  final List<String> pastBillsIDs;
  final String currentTableID;
  final String? fcmToken;

  Client({
    required this.userID,
    required this.name,
    required this.email,
    this.pastBillsIDs = const [],
    this.currentTableID = '',
    this.fcmToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'pastBillsIDs': pastBillsIDs,
      'currentTableID': currentTableID,
      'fcmToken': fcmToken,
    };
  }

  // Create a Client instance from Firestore map data
  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      userID: map['userID'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      pastBillsIDs: List<String>.from(map['pastBillsIDs'] ?? []),
      currentTableID: map['currentTableID'] ?? '',
      fcmToken: map['fcmToken'],
    );
  }
}
