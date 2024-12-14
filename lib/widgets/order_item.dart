import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/menu_item_model.dart';
import 'package:los_pollos_hermanos/models/order_item_model.dart';
import 'package:los_pollos_hermanos/services/client_services.dart';

class OrderItemCard extends StatefulWidget {
  final OrderItem orderItem;

  const OrderItemCard({
    required this.orderItem,
  }); 

  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {

  MenuItem? menuItem;
  bool isExpanded = false; // Track expansion state

  // // Dummy menu items data
  // final List<MenuItem> mockMenuItems = [
  //   MenuItem(
  //     id: 'menu_001',
  //     name: 'Cheeseburger',
  //     price: 150.0,
  //     description: 'A juicy beef patty with cheese, lettuce, and tomato.',
  //     extras: ['Extra Cheese', 'Bacon'],
  //     discount: 10.0,
  //     reviewIds: ['review_001', 'review_002'],
  //     imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/4/4d/Cheeseburger.jpg',
  //   ),
  //   MenuItem(
  //     id: 'menu_002',
  //     name: 'Veggie Burger',
  //     price: 120.0,
  //     description: 'A delicious plant-based patty with fresh veggies.',
  //     extras: ['Avocado', 'Extra Sauce'],
  //     discount: 0.0,
  //     reviewIds: ['review_003', 'review_004'],
  //     imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/4/4d/Cheeseburger.jpg',
  //   )
  // ];

   @override
  void initState() {
    super.initState();
    fetchMenuItem();
  }

  Future<void> fetchMenuItem() async {
    MenuItem? fetchedMenuItem = await ClientService().getMenuItem(widget.orderItem.menuItemId);
    setState(() {
      menuItem = fetchedMenuItem;
    });
  }

  // // Fetch menu item from dummy data
  // void fetchMenuItem() {
  //   MenuItem? fetchedMenuItem = mockMenuItems.firstWhere(
  //     (item) => item.id == widget.orderItem.menuItemId,
  //     orElse: () => MenuItem(
  //       id: widget.orderItem.menuItemId,
  //       name: 'Unknown Item',
  //       price: 0.0,
  //       description: 'No description available.',
  //       extras: [],
  //       discount: 0.0,
  //       reviewIds: [],
  //       imageUrl: 'https://via.placeholder.com/150',
  //     ),
  //   );
  //   setState(() {
  //     menuItem = fetchedMenuItem;
  //   });
  // }

   @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),

      child: menuItem == null
          ? Center(child: CircularProgressIndicator()) // Loading indicator
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(menuItem!.imageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          menuItem!.name,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'User IDs: ${widget.orderItem.userIds.join(", ")}',   //change to user avatars
                          style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${menuItem!.price.toStringAsFixed(2)} EGP',
                            style: TextStyle(fontSize: 14.0, color: Colors.black),
                          ),
                          SizedBox(height: 4.0),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                            // margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'x${widget.orderItem.itemCount}',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                        Text(
                          'Total: ${(menuItem!.price * widget.orderItem.itemCount).toStringAsFixed(2)} EGP',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        IconButton(
                          icon: Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded; // Toggle expansion state
                            });
                          },
                        ),
                      ],
                    ),

                // Expanded Details
                AnimatedContainer(
                  duration: Duration(milliseconds: 300), // Smooth animation
                  padding: EdgeInsets.only(top: 8.0),
                  child: isExpanded
                      ? IntrinsicHeight( // This will let the container size depend on the content
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notes: ${widget.orderItem.notes.join(", ")}',
                                style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                'Status: ${widget.orderItem.status.toString().split('.').last}',
                                style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        )
                      : Container(), // Empty container when collapsed
                ),
              ]
          )
    );
  }
}
