import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/order_item_model.dart';
import 'package:los_pollos_hermanos/services/client_services.dart';
import 'package:los_pollos_hermanos/widgets/order_item.dart';


class OrderSummary extends StatefulWidget {

  final String billID;

  const OrderSummary({super.key, required this.billID});

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {

  final ClientService _clientService = ClientService();

  List<OrderItem> orderItems = [];

  Future<List<OrderItem>> getOrderItems() async {
    return await _clientService
        .getOrderPerBill(widget.billID);
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Summary',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.yellow[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<OrderItem>>(
        future: getOrderItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading order items'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Order Items available'));
          } else {
            orderItems = snapshot.data!;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: orderItems.length,
                    itemBuilder: (context, index) {
                      return OrderItemCard(orderItem: orderItems[index]);
                    },
                  ),
                )
              ]
            );
          }
        },
      ),
    );
  }
}
