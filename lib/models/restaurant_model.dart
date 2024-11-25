class Restaurant {
  String id;
  String name;
  String menuID;

  Restaurant({
    required this.id,
    required this.name,
    required this.menuID,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'menuID': menuID,
    };
  }

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'],
      name: map['name'],
      menuID: map['menuID'],
    );
  }
}