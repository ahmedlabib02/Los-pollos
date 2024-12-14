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


  // // Dummy data for the bill
  // final Map<String, dynamic> mockBill = {
  //   'id': 'bill_001',
  //   'orderItemIds': ['order_001', 'order_002'],
  //   'amount': 1500.0,
  //   'isPaid': false,
  //   'userId': 'user_123',
  // };

  // // Dummy data for order items
  // final List<OrderItem> mockOrderItems = [
  //   OrderItem(
  //     id: 'order_001',
  //     userIds: ['user_123'],
  //     menuItemId: 'menu_001',
  //     tableId: 'table_01',
  //     status: OrderStatus.accepted,
  //     itemCount: 2,
  //     notes: ['Extra cheese'],
  //     price: 300.0,
  //     name: 'Cheeseburger',
  //   ),
  //   OrderItem(
  //     id: 'order_002',
  //     userIds: ['user_123'],
  //     menuItemId: 'menu_002',
  //     tableId: 'table_01',
  //     status: OrderStatus.inProgress,
  //     itemCount: 1,
  //     notes: ['No onions'],
  //     price: 200.0,
  //     name: 'Veggie Burger',
  //   ),
  // ];

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

      // body: mockOrderItems.isEmpty
      //     ? const Center(child: Text('No Order Items available'))
      //     : Column(
      //         children: [
      //           Expanded(
      //             child: ListView.builder(
      //               itemCount: mockOrderItems.length,
      //               itemBuilder: (context, index) {
      //                 return OrderItemCard(orderItem: mockOrderItems[index]);
      //               },
      //             ),
      //           ),
      //         ],
      //       ),
    );
  }
}
