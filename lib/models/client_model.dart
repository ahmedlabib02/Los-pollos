class Client {
  final String userID;
  final String name;
  final String email;
  final String role;
  final String phone;
  final List<String> pastBillsIDs;
  final String currentTableID;

  Client({
    required this.userID,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    this.pastBillsIDs = const [],
    this.currentTableID = '',
  });

  // Method to convert Client to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'pastBillsIDs': pastBillsIDs,
      'currentTableID': currentTableID,
    };
  }

  // Method to create a Client instance from Firestore map data
  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      userID: map['userID'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'Client',
      phone: map['phone'] ?? '',
      pastBillsIDs: List<String>.from(map['pastBillsIDs'] ?? []),
      currentTableID: map['currentTableID'] ?? '',
    );
  }
}