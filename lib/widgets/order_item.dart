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
          : Row(
              children: [
                // Menu Item Image
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

                // Menu Item Details
                Expanded(
                  child: Column(
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
                        '${menuItem!.price.toStringAsFixed(2)} EGP',
                        style: TextStyle(fontSize: 14.0, color: Colors.black),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'x${widget.orderItem.itemCount}',
                        style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                // Total Price
                Text(
                  'Total: ${(menuItem!.price * widget.orderItem.itemCount).toStringAsFixed(2)} EGP',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
    );
  }
}
