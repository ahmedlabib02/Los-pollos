import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/client_model.dart';
import 'package:los_pollos_hermanos/models/menu_item_model.dart';
import 'package:los_pollos_hermanos/models/order_item_model.dart';
import 'package:los_pollos_hermanos/services/client_services.dart';
import 'package:los_pollos_hermanos/shared/AvatarGroup.dart';

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
  List<Map<String, dynamic>>? users;


//====================================================
//                    DUMMY DATA
//====================================================

// final List<MenuItem> mockMenuItems = [
//   MenuItem(
//     id: 'menu_001',
//     name: 'Cheeseburger',
//     price: 150.0,
//     description: 'A juicy beef patty with cheese, lettuce, and tomato.',
//     variants: ['Regular', 'Large'],
//     extras: {
//       'Extra Cheese': 10.0,
//       'Bacon': 15.0,
//     },
//     discount: 10.0,
//     reviewIds: ['review_001', 'review_002'],
//     imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/4/4d/Cheeseburger.jpg',
//   ),
//   MenuItem(
//     id: 'menu_002',
//     name: 'Veggie Burger',
//     price: 120.0,
//     description: 'A delicious plant-based patty with fresh veggies.',
//     variants: ['Regular', 'Large'],
//     extras: {
//       'Avocado': 5.0,
//       'Extra Sauce': 2.0,
//     },
//     discount: 0.0,
//     reviewIds: ['review_003', 'review_004'],
//     imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRswygq3C8mTZUXmyl18k8ojtolrjZqVujmWw&s',
//   ),
//   MenuItem(
//     id: 'menu_003',
//     name: 'Garden Salad',
//     price: 75.0,
//     description: 'A fresh mix of lettuce, tomatoes, cucumbers, and carrots, served with your choice of dressing.',
//     variants: ['Small', 'Large'],
//     extras: {
//       'Olives': 3.0,
//       'Feta Cheese': 4.0,
//       'Bacon Bits': 2.0,
//       'Avocado': 5.0,
//     },
//     discount: 5.0,
//     reviewIds: ['review_005', 'review_006'],
//     imageUrl: 'https://garlicsaltandlime.com/wp-content/uploads/2022/07/Garden-salad-thumbnail.jpg',
//   ),
//   MenuItem(
//     id: 'menu_004',
//     name: 'Chicken Wings',
//     price: 100.0,
//     description: 'Crispy chicken wings served with a side of ranch dipping sauce.',
//     variants: ['Small', 'Large'],
//     extras: {
//       'Blue Cheese': 3.0,
//       'Hot Sauce': 2.0,
//     },
//     discount: 15.0,
//     reviewIds: ['review_007', 'review_008'],
//     imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRY1GcVqpDArKT_8uf8T29In7nVRKirjBur3Q&s',
//   ),
//   MenuItem(
//     id: 'menu_005',
//     name: 'Spaghetti Bolognese',
//     price: 200.0,
//     description: 'Classic Italian pasta with a rich and savory meat sauce.',
//     variants: ['Regular', 'Large'],
//     extras: {
//       'Parmesan Cheese': 5.0,
//       'Garlic Bread': 4.0,
//     },
//     discount: 0.0,
//     reviewIds: ['review_009', 'review_010'],
//     imageUrl: 'https://cdn.stoneline.de/media/c5/63/4f/1727429313/spaghetti-bolognese.jpeg',
//   ),
// ];

// //   // Dummy Data for users
//   List<Client> allClients = [
//     Client(userID: 'user_1', name: 'Alice', email: 'alice@example.com', imageUrl: 'https://cdn-icons-png.flaticon.com/512/6858/6858504.png'),
//     Client(userID: 'user_2', name: 'Bob', email: 'bob@example.com', imageUrl: 'https://avatar.iran.liara.run/public/29'),
//     Client(userID: 'user_3', name: 'Charlie', email: 'charlie@example.com', imageUrl: 'https://avatar.iran.liara.run/public/3'),
//   ];

  //==================================================================================


   @override
  void initState() {
    super.initState();
    fetchMenuItem();
    getClientsByIds();
  }

  Future<void> fetchMenuItem() async {
    MenuItem? fetchedMenuItem = await ClientService().getMenuItem(widget.orderItem.menuItemId);
    setState(() {
      menuItem = fetchedMenuItem;
    });
  }


  // fetch clients by a list of user IDs
  Future<void> getClientsByIds() async {
    List<Map<String, dynamic>> clients = [];

    for (String userId in widget.orderItem.userIds) {
      try {
        Client? client = await ClientService().getClient(userId);
        if (client != null) {
          clients.add(client.toMap());        }
      } catch (e) {
        // Handle the error as needed, maybe log or skip
        print('Error fetching client for userID $userId: $e');
      }
    }

    setState(() {
      users = clients;
    });

  }

  //======================================================
  //                Fetch Dummy Data
  //======================================================

  // // Fetch menu item from dummy data
  // void fetchMenuItem() {
  //   MenuItem? fetchedMenuItem = mockMenuItems.firstWhere(
  //     (item) => item.id == widget.orderItem.menuItemId,
  //     orElse: () => MenuItem(
  //       id: widget.orderItem.menuItemId,
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

  // // //get clients from dummy data
  // void getClientsByIds() {
  //   List<Map<String, dynamic>> clients = [];
    
  //   for (String userId in widget.orderItem.userIds) {
  //     Client client = allClients.firstWhere(
  //       (client) => client.userID == userId,
  //       orElse: () => Client(userID: 'default', name: 'Unknown', email: '', imageUrl: ''), // Default Client
  //     );
      
  //     // Only add the client if it isn't the default one
  //     if (client.userID != 'default') {
  //       clients.add({
  //         'name': client.name,
  //         'imageUrl': client.imageUrl,
  //       });
  //     }
  //   }

  //   setState(() {
  //     users = clients;
  //   });
  // }

  //=======================================================================

  Color _getStatusColor(OrderStatus status) {
  switch (status) {
    case OrderStatus.accepted:
      return Colors.blue.withOpacity(0.4); // Pending status color
    case OrderStatus.inProgress:
      return Colors.orange.withOpacity(0.4); // Completed status color
    case OrderStatus.served:
      return Colors.green.withOpacity(0.4); // Cancelled status color
    default:
      return Colors.grey.withOpacity(0.4); // Default color
  }
}

Color _getTextColor(OrderStatus status) {
  switch (status) {
    case OrderStatus.accepted:
      return Colors.blue; // Text color for pending
    case OrderStatus.inProgress:
      return Colors.orange; // Text color for completed
    case OrderStatus.served:
      return Colors.green; // Text color for cancelled
    default:
      return Colors.grey; // Default text color
  }
}


   @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

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
                        // Text(
                        //   'User IDs: ${widget.orderItem.userIds.join(", ")}',   //change to user avatars
                        //   style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                        // ),
                        AvatarGroup(content: users!, spacing: screenWidth * -0.015, radius: screenWidth * 0.025, cutoff: 3)
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
                                'Notes: ${widget.orderItem.notes.length>0? widget.orderItem.notes.join(", "): 'None'}',
                                style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                              ),
                              SizedBox(height: 4.0),
                              // Text(
                              //   'Status: ${widget.orderItem.status.toString().split('.').last}',
                              //   style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                              // ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(widget.orderItem.status),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  'Status: ${widget.orderItem.status.toString().split('.').last}',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    // color: _getTextColor(widget.orderItem.status),
                                    color: Colors.black
                                  ),
                                ),
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
