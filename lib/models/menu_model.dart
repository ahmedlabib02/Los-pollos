class Menu {
  String id;
  Map<String, List<String>> categories; // Map of categories to list of menu item IDs

  Menu({required this.id, required this.categories});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categories': categories,
    };
  }

  factory Menu.fromMap(Map<String, dynamic> map) {
    var categoriesMap = map['categories'] as Map<String, dynamic>;
    Map<String, List<String>> categories = {};
    categoriesMap.forEach((category, itemIds) {
      categories[category] = List<String>.from(itemIds);
    });
    return Menu(
      id: map['id'],
      categories: categories,
    );
  }
}