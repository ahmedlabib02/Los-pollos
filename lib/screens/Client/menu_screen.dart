import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/menu_item_model.dart';
import 'package:los_pollos_hermanos/services/client_services.dart';
import 'package:los_pollos_hermanos/shared/Styles.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MenuList(
          menuItemsFuture: ClientService()
              .getMenuItemsByRestaurantId('da3ZRVRibXeFl2Vw30ya'),
        ),
      ),
    );
  }
}

class MenuList extends StatefulWidget {
  final Future<Map<String, List<MenuItem>>> menuItemsFuture;

  const MenuList({required this.menuItemsFuture});

  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _categoryKeys = {};
  late List<String> _categories;
  Map<String, List<MenuItem>>?
      _originalMenuItems; // Nullable to avoid late initialization error
  late Map<String, List<MenuItem>> _filteredMenuItems;
  String? _activeCategory;
  String _searchQuery = '';
  bool _showSelectorShadow = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _scrollController.addListener(() {
      setState(() {
        _showSelectorShadow = _scrollController.offset > 0;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCategory(String category) {
    final key = _categoryKeys[category];
    if (key != null) {
      final context = key.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          alignment: 0.1,
        );
      }
    }
  }

  void _onScroll() {
    // We iterate through categories and find the first one that's currently near the top.
    for (var category in _categories) {
      final key = _categoryKeys[category];
      if (key != null) {
        final context = key.currentContext;
        if (context != null) {
          final renderBox = context.findRenderObject() as RenderBox;
          final position = renderBox.localToGlobal(Offset.zero);

          // Check if the category heading is near the top of the viewport
          if (position.dy >= 0 && position.dy < 120) {
            // If we're looking at the first category that appears close to the top, set it active.
            if (_activeCategory != category) {
              setState(() {
                _activeCategory = category;
              });
            }
            break;
          }
        }
      }
    }
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredMenuItems = Map.from(_originalMenuItems!);
        _categories = _originalMenuItems!.keys.toList();
      } else {
        _filteredMenuItems = _originalMenuItems!.map((category, items) {
          final filteredItems = items
              .where((item) =>
                  item.name.toLowerCase().contains(query.toLowerCase()) ||
                  item.description.toLowerCase().contains(query.toLowerCase()))
              .toList();
          return MapEntry(category, filteredItems);
        });

        _filteredMenuItems.removeWhere((key, value) => value.isEmpty);
        _categories = _filteredMenuItems.keys.toList();
      }

      _activeCategory = _categories.isNotEmpty ? _categories.first : null;
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

        final menuItems = snapshot.data!;

        // Initialize _originalMenuItems and _filteredMenuItems on first load
        if (_originalMenuItems == null) {
          _originalMenuItems = menuItems;
          _filteredMenuItems = Map.from(_originalMenuItems!);
          _categories = _originalMenuItems!.keys.toList();
          _activeCategory = _categories.first;
        }

        for (var category in _categories) {
          _categoryKeys[category] = GlobalKey();
        }

        return Column(
          children: [
            // Search Bar
            Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  onChanged: _onSearch,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Styles.inputFieldBgColor,
                    hintText: 'Search for items by name or description',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    hintStyle: TextStyle(
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
                )),

            // Category Selector
            if (_searchQuery.isEmpty)
              CategorySelector(
                categories: _categories,
                activeCategory: _activeCategory,
                onCategoryTap: (category) {
                  _scrollToCategory(category);
                },
                showShadow: _showSelectorShadow,
              ),

            // Menu List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(top: 10),
                itemCount: _filteredMenuItems.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final items = _filteredMenuItems[category]!;

                  return Column(
                    key: _categoryKeys[category],
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: items.length,
                        separatorBuilder: (context, _) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 22.0),
                          child: const Divider(
                            thickness: 0.5,
                            color: Styles.inputFieldBorderColor,
                          ),
                        ),
                        itemBuilder: (context, itemIndex) {
                          final item = items[itemIndex];
                          return MenuItemWidget(item: item);
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
  final bool showShadow;

  const CategorySelector({
    required this.categories,
    required this.activeCategory,
    required this.onCategoryTap,
    required this.showShadow,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      height: 50,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              // Ensure that the Row takes up at least the full width
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: categories.map((category) {
                  final isActive = activeCategory == category;
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onCategoryTap(category),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
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
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isActive ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  );
                }).toList(),
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
  final double hPad = 22.0;
  final double vPad = 6.0;

  const MenuItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    // Calculate discounted price if a discount exists
    final hasDiscount = item.discount > 0;
    final discountedPrice =
        hasDiscount ? item.price * (1 - item.discount / 100) : item.price;

    return Container(
      padding: EdgeInsets.symmetric(vertical: vPad, horizontal: hPad),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text content on the left
            Flexible(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title and description
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
                      // Description
                      Text(
                        item.description.length > 140
                            ? '${item.description.substring(0, 140)}...'
                            : item.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 140, 140, 140),
                        ),
                      ),
                    ],
                  ),
                  // Price (with discount if applicable)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // color: Colors.red,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'EGP ',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 1),
                            Text(
                              discountedPrice.toStringAsFixed(2),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),
                      Container(
                          // color: Colors.blue,
                          child: hasDiscount
                              ?
                              // Old price with a strikethrough
                              Text(
                                  'EGP ${item.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 135, 135, 135),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                )
                              : null),
                      // New price
                    ],
                  ),
                ],
              ),
            ),

            // Image on the right with rounded corners
            Flexible(
              flex: 3,
              child: MenuItemImageWidget(imageUrl: item.imageUrl),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItemImageWidget extends StatelessWidget {
  final String imageUrl;

  const MenuItemImageWidget({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8), // Rounded corners
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: 110, // Fixed width for the image
            height: 110, // Fixed height for the image
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child; // Image loaded successfully
              }
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Icon(Icons.error)); // Error handling
            },
          ),
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: GestureDetector(
            onTap: () {
              // Handle add to cart action
            },
            child: Container(
              decoration: BoxDecoration(
                // color: const Color(0xFFF2C230), // Background color
                color: Colors.white,
                shape: BoxShape.circle, // Makes the container circular
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    blurRadius: 6, // Softness of the shadow
                    spreadRadius: 2, // How far the shadow spreads
                    offset: const Offset(0, 0), // Position of the shadow (x, y)
                  ),
                ],
              ),
              child: const CircleAvatar(
                backgroundColor: Colors
                    .transparent, // Set transparent if using the container color
                radius: 18,
                child: Icon(
                  Icons.add,
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
