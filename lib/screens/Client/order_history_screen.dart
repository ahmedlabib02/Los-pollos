import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/customUser.dart';
import 'package:los_pollos_hermanos/screens/Client/order_details_screen.dart';
import 'package:los_pollos_hermanos/services/client_services.dart';
import 'package:provider/provider.dart';
import '../../models/bill_model.dart';
import '../../models/order_item_model.dart';
import '../../models/restaurant_model.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final ClientService _clientService = ClientService();

  List<Bill> pastBills = [];
  Map<String, Restaurant> restaurantCache = {};
  Map<String, bool> expandedState = {};
  bool isLoadingBills = true;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<CustomUser?>(context, listen: false);
    if (user != null) {
      _fetchPastBills(user.uid);
    }
  }

  Future<void> _fetchPastBills(String userID) async {
    try {
      setState(() {
        isLoadingBills = true;
      });

      List<Bill> fetchedBills =
          await _clientService.getPastBillsPerUser(userID);

      for (var bill in fetchedBills) {
        if (!restaurantCache.containsKey(bill.restaurantId)) {
          Restaurant restaurant =
              await _clientService.getRestaurantById(bill.restaurantId);
          restaurantCache[bill.restaurantId] = restaurant;
        }
        expandedState[bill.id] = false;
      }

      setState(() {
        pastBills = fetchedBills;
        isLoadingBills = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching past bills: $e')),
      );
    }
  }

  void _navigateToOrderDetails(
      BuildContext context, Bill bill, Restaurant restaurant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            OrderDetailsScreen(bill: bill, restaurant: restaurant),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
            top: 16.0), // Add space between the first card and app bar
        child: isLoadingBills
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: pastBills.length,
                itemBuilder: (context, index) {
                  final bill = pastBills[index];
                  final restaurant = restaurantCache[bill.restaurantId];

                  return Card(
                    color: Colors.grey[100], // Light grey background color
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: restaurant != null
                                        ? NetworkImage(restaurant.imageUrl!)
                                        : null,
                                    backgroundColor: Colors.grey[300],
                                    child: restaurant == null
                                        ? Icon(Icons.restaurant)
                                        : null,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        restaurant?.name ?? "Restaurant",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Order ID: ${bill.id}',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${bill.orderItemIds.length} items',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      expandedState[bill.id] == true
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        expandedState[bill.id] =
                                            !expandedState[bill.id]!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (expandedState[bill.id] == true)
                            FutureBuilder<List<OrderItem>>(
                              future: _clientService.getOrderPerBill(bill.id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      "Error fetching orders: ${snapshot.error}",
                                    ),
                                  );
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Center(child: Text("No items found"));
                                } else {
                                  final items = snapshot.data!;
                                  return Column(
                                    children: items
                                        .map(
                                          (item) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: item.imageUrl != null
                                                      ? Image.network(
                                                          item.imageUrl!,
                                                          width: 40,
                                                          height: 40,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Container(
                                                          width: 40,
                                                          height: 40,
                                                          color:
                                                              Colors.grey[300],
                                                          child: Icon(
                                                            Icons
                                                                .image_not_supported,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                        ),
                                                ),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    item.name ?? "Unnamed Item",
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(
                                                  'EGP ${item.price.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  );
                                }
                              },
                            ),
                          Divider(color: Colors.grey[300], thickness: 1),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'EGP ${bill.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                                SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () => _navigateToOrderDetails(
                                      context, bill, restaurant!),
                                  child: Text(
                                    'View details',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
