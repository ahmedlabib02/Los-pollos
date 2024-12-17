import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/customUser.dart';
import 'package:los_pollos_hermanos/provider/selected_restaurant_provider.dart';
import 'package:los_pollos_hermanos/screens/Client/menu_item_screen.dart';
import 'package:los_pollos_hermanos/screens/Manager/add_menu_item_screen.dart';
import 'package:los_pollos_hermanos/screens/Manager/edit_menu_item_screen.dart';
import 'package:los_pollos_hermanos/services/manager_services.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:los_pollos_hermanos/models/menu_item_model.dart';
import 'package:los_pollos_hermanos/services/client_services.dart';
import 'package:los_pollos_hermanos/shared/Styles.dart';

class MenuScreen extends StatefulWidget {
  final String role;
  const MenuScreen({Key? key, required this.role}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<Map<String, List<MenuItem>>> _menuItemsFuture;
  String? restaurantId;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<CustomUser?>(context, listen: false);
    if (widget.role == 'manager') {
      restaurantId = user!.uid;
    } else {
      restaurantId =
          Provider.of<SelectedRestaurantProvider>(context, listen: false)
              .selectedRestaurantId;
    }
    // Initialize the future
    _menuItemsFuture =
        ClientService().getMenuItemsByRestaurantId(restaurantId!);
  }

  /// Re-fetch from Firestore (or update your local data) after adding an item
  void _refreshMenuItems() {
    setState(() {
      _menuItemsFuture =
          ClientService().getMenuItemsByRestaurantId(restaurantId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MenuList(
          menuItemsFuture: _menuItemsFuture,
          role: widget.role,
        ),
      ),
      floatingActionButton: widget.role == 'manager'
          ? FloatingActionButton(
              backgroundColor: const Color(0xFFF2C230),
              onPressed: () {
                final user = Provider.of<CustomUser?>(context, listen: false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddMenuItemScreen(restaurantId: user!.uid),
                  ),
                ).then((result) {
                  // result is what we popped from AddMenuItemScreen
                  if (result != null) {
                    // We successfully created a new item. Let’s refetch the data:
                    _refreshMenuItems();
                  }
                });
              },
              child: const Icon(Icons.add, color: Colors.black),
              tooltip: 'Add New Menu Item',
            )
          : null,
    );
  }
}

class MenuList extends StatefulWidget {
  final Future<Map<String, List<MenuItem>>> menuItemsFuture;

  final String role;

  const MenuList({required this.menuItemsFuture, required this.role});

  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  Map<String, List<MenuItem>>? _menuItems; // Nullable initialization
  Map<String, List<MenuItem>> _filteredMenuItems = {};
  List<String> _categories = [];
  String? _activeCategory;
  String _searchQuery = '';
  bool _isUserScrolling = false; // Flag to suppress updates during scroll

  @override
  void initState() {
    super.initState();
    _itemPositionsListener.itemPositions.addListener(_onScroll);
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_isUserScrolling) return;

    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isNotEmpty) {
      final firstVisibleIndex = positions.first.index;
      final newActiveCategory = _categories[firstVisibleIndex];

      if (_activeCategory != newActiveCategory) {
        setState(() {
          _activeCategory = newActiveCategory;
        });
      }
    }
  }

  void _scrollToCategory(String category) async {
    final index = _categories.indexOf(category);
    if (index != -1) {
      setState(() {
        _isUserScrolling = true;
        _activeCategory = category;
      });

      await _itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      setState(() {
        _isUserScrolling = false;
      });
    }
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();

      if (_searchQuery.isEmpty) {
        _filteredMenuItems = Map.from(_menuItems!);
        _categories = _menuItems!.keys.toList();
      } else {
        _filteredMenuItems = {};
        for (var category in _menuItems!.keys) {
          final filteredItems = _menuItems![category]!.where((item) {
            return item.name.toLowerCase().contains(_searchQuery) ||
                item.description.toLowerCase().contains(_searchQuery);
          }).toList();

          if (filteredItems.isNotEmpty) {
            _filteredMenuItems[category] = filteredItems;
          }
        }
        _categories = _filteredMenuItems.keys.toList();
        _activeCategory = _categories.isNotEmpty ? _categories.first : null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<MenuItem>>>(
      future: widget.menuItemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading menu items'));
        }

        if (snapshot.hasData) {
          // Always update _menuItems from snapshot
          _menuItems = snapshot.data!;
          _filteredMenuItems = Map.from(_menuItems!);
          _categories = _menuItems!.keys.toList();
          // Optionally preserve _activeCategory if it's still valid,
          // or reassign if the categories changed.
          if (_activeCategory == null ||
              !_categories.contains(_activeCategory)) {
            _activeCategory = _categories.isNotEmpty ? _categories.first : null;
          }
        }

        // Safeguard in case snapshot.data is empty
        if (_menuItems == null || _menuItems!.isEmpty) {
          return const Center(child: Text('No menu items available.'));
        }

        return Column(
          children: [
            // Search Bar
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 22.0),
              child: TextField(
                onChanged: _onSearch,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Styles.inputFieldBgColor,
                  hintText: 'Search for items by name or description',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                ),
              ),
            ),

            // Category Selector
            CategorySelector(
              categories: _categories,
              activeCategory: _activeCategory,
              onCategoryTap: _scrollToCategory,
            ),

            // Menu List
            Expanded(
              child: ScrollablePositionedList.builder(
                itemCount: _categories.length,
                itemScrollController: _itemScrollController,
                itemPositionsListener: _itemPositionsListener,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final items = _filteredMenuItems[category]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index == 0) const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        separatorBuilder: (context, _) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 22.0),
                          child: const Divider(
                            thickness: 0.5,
                            color: Styles.inputFieldBorderColor,
                          ),
                        ),
                        itemBuilder: (context, itemIndex) {
                          final category = _categories[itemIndex];
                          final item = items[itemIndex];
                          // If the user is "manager", wrap in Dismissible
                          if (widget.role == 'manager') {
                            return Dismissible(
                              key: ValueKey(item.id),
                              direction:
                                  DismissDirection.endToStart, // Swipe left
                              background: Container(
                                alignment: Alignment.centerRight,
                                color: Colors.red,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              confirmDismiss: (direction) async {
                                // Optionally prompt for confirmation
                                return await showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Delete ${item.name}?'),
                                    content: Text(
                                        'Are you sure you want to remove this item?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(false),
                                          child: Text('Cancel')),
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(true),
                                          child: Text('Delete')),
                                    ],
                                  ),
                                );
                              },
                              onDismissed: (direction) async {
                                // 1. Call the manager service to delete the item from Firestore
                                try {
                                  final user = Provider.of<CustomUser?>(context,
                                      listen: false);
                                  await ManagerServices()
                                      .deleteMenuItemForRestaurant(
                                    restaurantId: user!
                                        .uid, // if manager ID is the restaurantId
                                    menuItem: item,
                                    category: category, // from your code
                                  );
                                  // 2. Optionally remove the item from local list:
                                  items.removeAt(itemIndex);
                                } catch (e) {
                                  print('Deletion error: $e');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Error deleting item: $e')),
                                  );
                                }
                              },
                              child: MenuItemWidget(
                                item: item,
                                role: widget.role,
                              ),
                            );
                          } else {
                            // If role is user, just show the normal item (no dismissible)
                            return MenuItemWidget(
                              item: item,
                              role: widget.role,
                            );
                          }
                        },
                      ),
                      Container(
                        height: 6,
                        color: const Color.fromARGB(255, 247, 247, 247),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final String? activeCategory;
  final void Function(String) onCategoryTap;

  const CategorySelector({
    required this.categories,
    required this.activeCategory,
    required this.onCategoryTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: -1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isActive = category == activeCategory;

          return GestureDetector(
            onTap: () => onCategoryTap(category),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: isActive
                    ? const Border(
                        bottom: BorderSide(
                          color: Color(0xFFF2C230),
                          width: 3,
                        ),
                      )
                    : null,
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: isActive ? Styles.primaryYellow : Colors.grey,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MenuItemWidget extends StatelessWidget {
  final MenuItem item;
  final String role; // Role: "user" or "manager"
  final double hPad = 22.0;
  final double vPad = 6.0;

  const MenuItemWidget({required this.item, required this.role});

  @override
  Widget build(BuildContext context) {
    final hasDiscount = item.discount > 0;
    final discountedPrice =
        hasDiscount ? item.price * (1 - item.discount / 100) : item.price;
    final user = Provider.of<CustomUser?>(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: vPad, horizontal: hPad),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item.description.length > 140
                            ? '${item.description.substring(0, 140)}...'
                            : item.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 140, 140, 140),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'EGP ${discountedPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      if (hasDiscount)
                        Text(
                          'EGP ${item.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 135, 135, 135),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 3,
              child: MenuItemImageWidget(
                imageUrl: item.imageUrl,
                icon: role == "user" ? Icons.add : Icons.edit,
                onIconTap: () {
                  if (role == "user") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MenuItemScreen(menuItemId: item.id),
                      ),
                    );
                  } else if (role == "manager") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditMenuItemScreen(
                          restaurantId: user!.uid,
                          menuItemId: item.id,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItemImageWidget extends StatelessWidget {
  final String imageUrl;
  final IconData icon;
  final void Function() onIconTap;

  const MenuItemImageWidget({
    required this.imageUrl,
    required this.icon,
    required this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: 100,
            height: 100,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Icon(Icons.error));
            },
          ),
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: GestureDetector(
            onTap: onIconTap,
            child: Container(
              decoration: BoxDecoration(
                color: Styles.primaryYellow,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 18,
                child: Icon(
                  icon,
                  color: Colors.black,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
