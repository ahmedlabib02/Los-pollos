import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/menu_item_model.dart';
import 'package:los_pollos_hermanos/services/client_services.dart';

class MenuItemScreen extends StatefulWidget {
  final String menuItemId;

  const MenuItemScreen({required this.menuItemId});

  @override
  _MenuItemScreenState createState() => _MenuItemScreenState();
}

class _MenuItemScreenState extends State<MenuItemScreen> {
  MenuItem? menuItem;
  int quantity = 1;
  Set<String> removedVariants = {};
  Set<String> selectedExtras = {};

//====================================================
//                    DUMMY DATA
//====================================================

//   // Dummy menu items data
// final List<MenuItem> mockMenuItems = [
//   MenuItem(
//     id: "1",
//     name: "Cheese Burger",
//     price: 200.0,
//     description: "Juicy beef patty with cheese and fresh veggies.",
//     variants: ["No tomato", "No lettuce", "No onion"],
//     extras: {
//       "Extra cheese": 20.0,
//       "Extra patty": 50.0,
//       "Bacon": 30.0,
//     },
//     discount: 0.0,
//     reviewIds: [],
//     imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTEJiNX0GZfl21raOShpI3p-W8CkdBITCCwAQ&s",
//   ),
//   MenuItem(
//     id: "103",
//     name: "Pepperoni Pizza",
//     price: 250.0,
//     description:
//         "A classic pepperoni pizza with a crispy crust, tangy tomato sauce, gooey mozzarella cheese, and plenty of spicy pepperoni slices.",
//     variants: ["No pepperoni", "No cheese", "No sauce"],
//     extras: {
//       "Extra cheese": 40.0,
//       "Extra pepperoni": 50.0,
//       "Mushrooms": 30.0,
//       "Olives": 20.0,
//       "Jalapenos": 25.0,
//     },
//     discount: 10.0, // Example: 10% discount
//     reviewIds: ["review6", "review7", "review8"],
//     imageUrl: "https://via.placeholder.com/300x200.png?text=Pepperoni+Pizza",
//   ),
//   MenuItem(
//     id: "102",
//     name: "Garden Salad",
//     price: 150.0,
//     description:
//         "A fresh and healthy salad with mixed greens, cherry tomatoes, cucumbers, shredded carrots, and a light vinaigrette dressing.",
//     variants: ["No tomato", "No cucumber", "No dressing"],
//     extras: {
//       "Grilled chicken": 60.0,
//       "Avocado": 40.0,
//       "Feta cheese": 30.0,
//       "Croutons": 15.0,
//       "Boiled egg": 20.0,
//     },
//     discount: 0.0,
//     reviewIds: ["review4", "review5"],
//     imageUrl: "https://via.placeholder.com/300x200.png?text=Garden+Salad",
//   ),
// ];

//=========================================================================

  @override
  void initState() {
    super.initState();
    fetchMenuItem();
  }

  Future<void> fetchMenuItem() async {
    MenuItem? fetchedMenuItem =
        await ClientService().getMenuItem(widget.menuItemId);
    setState(() {
      menuItem = fetchedMenuItem;
    });
  }


  //======================================================
  //                Fetch Dummy Data
  //======================================================

  //   // Fetch menu item from dummy data
  // void fetchMenuItem() {
  //   MenuItem? fetchedMenuItem = mockMenuItems.firstWhere(
  //     (item) => item.id == widget.menuItemId,
  //     orElse: () => MenuItem(
  //       id: widget.menuItemId,
  //       name: 'Unknown Item',
  //       price: 0.0,
  //       description: 'No description available.',
  //       variants: [],
  //       extras: {},
  //       discount: 0.0,
  //       reviewIds: [],
  //       imageUrl: 'https://via.placeholder.com/150',
  //     ),
  //   );
  //   setState(() {
  //     menuItem = fetchedMenuItem;
  //   });
  // }

  int calculateTotal() {
    double total = menuItem!.price;

    // Add extras prices
    for (var extra in selectedExtras) {
      if (menuItem!.extras.containsKey(extra)) {
        total += menuItem!.extras[extra]!;
      }
    }

    // Apply quantity
    total *= quantity;

    return total.toInt();
  }

  @override
  Widget build(BuildContext context) {
    if (menuItem == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item Image
              if (menuItem!.imageUrl != null)
                Image.network(
                  menuItem!.imageUrl!,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

              // Item Details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          menuItem!.name,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "${menuItem!.price.toStringAsFixed(2)} LE",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(239, 180, 7, 1)),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      menuItem!.description,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),

              // Variants Section (Items to remove for free)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Customize order item",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Remove Items",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    for (var variant in menuItem!.variants)
                      CheckboxListTile(
                        title: Text(variant),
                        activeColor: Color.fromRGBO(239, 180, 7, 1),
                        value: removedVariants.contains(variant),
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              removedVariants.add(variant);
                            } else {
                              removedVariants.remove(variant);
                            }
                          });
                        },
                      ),
                  ],
                ),
              ),

              Divider(
                color: Colors.grey,
                thickness: 0.5,
              ),
              const SizedBox(height: 8),

              // Extras Section (Add ingredients with prices)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Add extras",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    for (var extra in menuItem!.extras.entries)
                      CheckboxListTile(
                        title: Text(
                            "${extra.key} (+${extra.value.toStringAsFixed(2)} LE)"),
                        activeColor: Color.fromRGBO(239, 180, 7, 1),
                        value: selectedExtras.contains(extra.key),
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              selectedExtras.add(extra.key);
                            } else {
                              selectedExtras.remove(extra.key);
                            }
                          });
                        },
                      )
                  ],
                ),
              ),

              // Quantity Selector
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Quantity order",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            if (quantity > 1) {
                              setState(() {
                                quantity--;
                              });
                            }
                          },
                        ),
                        Text(
                          quantity.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Add to Order Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    //Add Item To Order Backend
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(239, 180, 7, 1),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Reduced roundness
                    ),
                  ),
                  child: Text(
                    "Add to order - ${calculateTotal()} LE",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Floating Back Button
        Positioned(
          top: 40,
          left: 16,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous page
            },
            mini: true, // Makes the button smaller
            backgroundColor: Colors.white.withOpacity(0.9),
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
      ]),
    );
  }
}
