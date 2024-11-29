import 'package:flutter/material.dart';

class BillCardWidget extends StatefulWidget {
  final Map<String, dynamic> bill;

  const BillCardWidget({super.key, required this.bill});

  @override
  _BillCardWidgetState createState() => _BillCardWidgetState();
}

class _BillCardWidgetState extends State<BillCardWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser = widget.bill['isCurrentUser'] ?? false;
    List orderItems = widget.bill['orderItems'];

    bool showViewMore = orderItems.length > 1;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.bill['name']}\'s Total ${isCurrentUser ? "(You)" : ""}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                      
                    ),
                  ),
                  Text(
                    '${widget.bill['amount']} EGP',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20, 
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                '${orderItems[0]['itemCount']}x ${orderItems[0]['itemName']}',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
              if (showViewMore)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        isExpanded ? "View Less" : "View More",
                        style: TextStyle(
                          color: Colors.yellow[700],
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      Icon(
                        isExpanded
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: Colors.yellow[700],
                      ),
                    ],
                  ),
                ),
              if (isExpanded && orderItems.length > 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: orderItems
                      .skip(1) // Skip the first item as it's already shown
                      .map<Widget>(
                        (item) => Text(
                          '${item['itemCount']}x ${item['itemName']}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
        // Divider after the card
        Divider(
            color: Colors.grey[300],
            thickness: 1,
            indent: 16.0,
            endIndent: 16.0),
      ],
    );
  }
}
