import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/bill_model.dart';
import 'package:los_pollos_hermanos/models/order_item_model.dart';
import 'package:los_pollos_hermanos/models/restaurant_model.dart';
import 'package:los_pollos_hermanos/services/client_services.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Bill bill;
  final Restaurant restaurant;

  OrderDetailsScreen({required this.bill, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final serviceFee = bill.amount * 0.12;
    final tax = bill.amount * 0.14;
    final totalAmount = bill.amount + serviceFee + tax;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(242, 194, 48, 1),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: restaurant.imageUrl != null
                        ? NetworkImage(restaurant.imageUrl!)
                        : null,
                    backgroundColor: Colors.grey[300],
                    child: restaurant.imageUrl == null
                        ? Icon(Icons.restaurant, color: Colors.grey[600])
                        : null,
                    radius: 40,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '18/10/2024 18:54', // Dummy date for now
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Order ID: ${bill.id}',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(thickness: 1, height: 32),
              Text('Order Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              FutureBuilder<List<OrderItem>>(
                future: ClientService().getOrderPerBill(bill.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text(
                        'Error fetching order items: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No items found in this order.');
                  } else {
                    final items = snapshot.data!;
                    return Column(
                      children: items.map((item) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: item.imageUrl != null
                                      ? Image.network(
                                          item.imageUrl!,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          width: 60,
                                          height: 60,
                                          color: Colors.grey[300],
                                          child: Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name ?? 'Unnamed Item',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Quantity: ${item.itemCount}',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'EGP ${item.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
              Divider(thickness: 1, height: 32),
              SizedBox(height: 16),
              Text(
                'Subtotal: EGP ${bill.amount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Service Fee (12%): EGP ${serviceFee.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Tax (14%): EGP ${tax.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),
              Divider(thickness: 1),
              Text(
                'Total: EGP ${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
