class Client {
  final String userID;
  final String name;
  final String email;
  final List<String> pastBillsIDs;
  final String currentTableID;

  Client({
    required this.userID,
    required this.name,
    required this.email,
    this.pastBillsIDs = const [],
    this.currentTableID = '',
  });

  // Method to convert Client to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'name': name,
      'email': email,
      'pastBillsIDs': pastBillsIDs,
      'currentTableID': currentTableID,
    };
  }

  // Factory method to create a Client instance from Firestore map data
  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      userID: map['userID'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      pastBillsIDs: List<String>.from(map['pastBillsIDs'] ?? []),
      currentTableID: map['currentTableID'] ?? '',
    );
  }
}
