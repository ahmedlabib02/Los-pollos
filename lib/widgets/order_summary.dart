import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/customUser.dart';
import 'package:los_pollos_hermanos/models/order_item_model.dart';
import 'package:los_pollos_hermanos/services/client_services.dart';
import 'package:los_pollos_hermanos/widgets/order_item.dart';
import 'package:los_pollos_hermanos/models/table_model.dart';
import 'package:provider/provider.dart';

class OrderSummary extends StatefulWidget {
  final String tableId;

  const OrderSummary({super.key, required this.tableId});

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  final ClientService _clientService = ClientService();

  List<OrderItem> orderItems = [];

  Future<List<OrderItem>> getOrderItems() async {
    return await _clientService.getOrderPerTable(widget.tableId);
  }

  // //=============================================
  // // DUMMY DATA
  // //=============================================
  //   final Map<String, dynamic> mockTable = {
  //   'id': 'table_123',
  //   'isTableSplit': false,
  //   'userIds': ['user_1', 'user_2', 'user_3'],
  //   'orderItemIds': ['order_001', 'order_002', 'order_003'],
  //   'billIds': ['bill_1'],
  //   'totalAmount': 45.50,
  //   'tableCode': 'ABCD',
  //   'isOngoing': true,
  //   'restaurantId': 'restaurant_123',
  //   };

  // // Dummy data for order items
  // final List<OrderItem> mockOrderItems = [
  //   OrderItem(
  //     id: 'order_001',
  //     userIds: ['user_1', 'user_2'],
  //     menuItemId: 'menu_001',
  //     tableId: 'table_01',
  //     status: OrderStatus.inProgress,
  //     itemCount: 2,
  //     notes: ['Extra cheese'],
  //     price: 300.0,
  //     name: 'Cheeseburger',
  //   ),
  //   OrderItem(
  //     id: 'order_002',
  //     userIds: ['user_2'],
  //     menuItemId: 'menu_004',
  //     tableId: 'table_01',
  //     status: OrderStatus.served,
  //     itemCount: 1,
  //     notes: ['Hot Sauce'],
  //     price: 200.0,
  //     name: 'Chicken Wings',
  //   ),
  //   OrderItem(
  //     id: 'order_003',
  //     userIds: ['user_3'],
  //     menuItemId: 'menu_003',
  //     tableId: 'table_01',
  //     status: OrderStatus.accepted,
  //     itemCount: 2,
  //     notes: [],
  //     price: 250.0,
  //     name: 'Salad',
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    String loggedInUserId = Provider.of<CustomUser?>(context)!.uid;

    return Scaffold(
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
            // Assign orderItems inside setState if needed
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: orderItems.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0.0),
                            child: OrderItemCard(
                              orderItem: orderItems[index],
                            ),
                          ),
                          if (index != orderItems.length - 1)
                            Divider(
                              color: Colors.grey.shade200,
                              thickness: 1,
                            ),
                          if (index == orderItems.length - 1)
                            const SizedBox(height: 80),
                        ],
                      );
                    },
                  ),
                )
              ],
            );
          }
        },
      ),
      // /// For Dummy Data
      // ///
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
