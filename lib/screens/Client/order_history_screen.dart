import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/customUser.dart';
import 'package:provider/provider.dart';
import '../../services/client_services.dart'; // Import your ClientService
import '../../models/bill_model.dart';
import '../../models/order_item_model.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final ClientService _clientService = ClientService();

  List<Bill> pastBills = [];
  List<OrderItem> billOrders = [];
  bool isLoadingBills = true;
  bool isLoadingOrders = false;

  // Flag to check if data has already been fetched
  bool hasFetchedBills = false;

  @override
  Widget build(BuildContext context) {
    // Access the userID (replace with your actual method of obtaining userID)
    final user = Provider.of<CustomUser?>(context);

    if (!hasFetchedBills) {
      // Fetch past bills when the userID is available
      _fetchPastBills(user!.uid);
      hasFetchedBills = true; // Ensure this is only called once
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
                      // Fetch orders for the selected bill
                      _fetchOrdersForBill(bill.id);
                    },
                  ),
                );
              },
            ),
    );
  }

  Future<void> _fetchPastBills(String userID) async {
    try {
      setState(() {
        isLoadingBills = true;
      });
      List<Bill> fetchedBills =
          await _clientService.getPastBillsPerUser(userID);
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

  Future<void> _fetchOrdersForBill(String billID) async {
    try {
      setState(() {
        isLoadingOrders = true;
      });
      List<OrderItem> fetchedOrders =
          await _clientService.getOrderPerBill(billID);
      setState(() {
        billOrders = fetchedOrders;
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
              title: Text(order.name ??
                  "Unnamed Item"), // Now this field will have the menu item name
              subtitle: Text('Price: \$${order.price.toStringAsFixed(2)}'),
              trailing: Text('Quantity: ${order.itemCount}'),
            );
          },
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching orders for bill: $e')),
      );
    }
  }
}
