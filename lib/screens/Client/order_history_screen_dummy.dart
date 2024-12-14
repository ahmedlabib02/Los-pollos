import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/customUser.dart';
import 'package:los_pollos_hermanos/provider/selected_restaurant_provider.dart';
import 'package:provider/provider.dart';
import '../../services/client_services.dart';
import '../../models/bill_model.dart';
import '../../models/order_item_model.dart';

class OrderHistoryScreenDummy extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreenDummy> {
  final ClientService _clientService = ClientService();

  List<Bill> pastBills = [];
  List<OrderItem> billOrders = [];
  bool isLoadingBills = true;
  bool isLoadingOrders = false;

  // Dummy data for bills and orders
  final List<Bill> dummyBills = [
    Bill(
      id: 'bill_1',
      orderItemIds: ['order_1', 'order_2'],
      amount: 45.99,
      isPaid: true,
      userId: 'user_1',
      restaurantId: 'restaurant_1',
    ),
    Bill(
      id: 'bill_2',
      orderItemIds: ['order_3'],
      amount: 19.99,
      isPaid: false,
      userId: 'user_1',
      restaurantId: 'restaurant_1',
    ),
  ];

  final List<OrderItem> dummyOrders = [
    OrderItem(
      id: 'order_1',
      userIds: ['user_1'],
      menuItemId: 'menu_1',
      tableId: 'table_1',
      status: OrderStatus.served,
      itemCount: 2,
      notes: ['Extra spicy'],
      price: 15.99,
      name: 'Taco',
    ),
    OrderItem(
      id: 'order_2',
      userIds: ['user_1'],
      menuItemId: 'menu_2',
      tableId: 'table_1',
      status: OrderStatus.served,
      itemCount: 1,
      notes: [],
      price: 30.00,
      name: 'Steak',
    ),
    OrderItem(
      id: 'order_3',
      userIds: ['user_1'],
      menuItemId: 'menu_3',
      tableId: 'table_2',
      status: OrderStatus.inProgress,
      itemCount: 1,
      notes: ['No onions'],
      price: 19.99,
      name: 'Burger',
    ),
  ];

  // Flag to check if data has already been fetched
  bool hasFetchedBills = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    final selectedRestaurantId =
        Provider.of<SelectedRestaurantProvider>(context).selectedRestaurantId;

    if (!hasFetchedBills) {
      // Use dummy data to simulate fetching bills
      _fetchPastBills(user!.uid);
      hasFetchedBills = true;
    }

    return Scaffold(
      body: isLoadingBills
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pastBills.length,
              itemBuilder: (context, index) {
                final bill = pastBills[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Bill ID: ${bill.id}'),
                    subtitle:
                        Text('Amount: \$${bill.amount.toStringAsFixed(2)}'),
                    trailing: bill.isPaid
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.error, color: Colors.red),
                    onTap: () {
                      // Fetch orders for the selected bill using dummy data
                      _fetchOrdersForBill(bill.id);
                    },
                  ),
                );
              },
            ),
    );
  }

  Future<void> _fetchPastBills(String userID) async {
    setState(() {
      isLoadingBills = true;
    });

    // Simulate fetching bills using dummy data
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    setState(() {
      pastBills = dummyBills; // Use dummy bills
      isLoadingBills = false;
    });
  }

  Future<void> _fetchOrdersForBill(String billID) async {
    setState(() {
      isLoadingOrders = true;
    });

    // Simulate fetching orders using dummy data
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    setState(() {
      billOrders = dummyOrders
          .where((order) => dummyBills
              .firstWhere((bill) => bill.id == billID)
              .orderItemIds
              .contains(order.id))
          .toList(); // Filter orders based on bill ID
      isLoadingOrders = false;
    });

    // Show bill orders in a modal dialog
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: billOrders.length,
        itemBuilder: (context, index) {
          final order = billOrders[index];
          return ListTile(
            title: Text(order.name ?? "Unnamed Item"),
            subtitle: Text('Price: \$${order.price.toStringAsFixed(2)}'),
            trailing: Text('Quantity: ${order.itemCount}'),
          );
        },
      ),
    );
  }
}
