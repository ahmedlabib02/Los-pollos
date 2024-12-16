import 'package:flutter/material.dart';

class BillCardWidget extends StatefulWidget {
  final Map<String, dynamic> bill;

  const BillCardWidget({super.key, required this.bill});

  @override
  _BillCardWidgetState createState() => _BillCardWidgetState();
}

class _BillCardWidgetState extends State<BillCardWidget> {
  bool isExpanded = false;

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    List<String> nameParts = name.trim().split(' ');
    String initials = nameParts.map((part) => part[0]).take(2).join();
    return initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser = widget.bill['isCurrentUser'] ?? false;
    List orderItems = widget.bill['orderItems'];
    bool showViewMore = orderItems.length > 1;
    String? imageUrl = widget.bill['imageUrl'];

    return Card(
      color: Colors.grey[50],
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0, // Increase space on the right and left
        vertical: 12.0, // Increase space between each card
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar SectionR
                  CircleAvatar(
                    radius: 30, // Adjust the size as needed
                    backgroundColor: Colors.grey[200],
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Text(
                                  _getInitials(widget.bill['name']),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                );
                              },
                            ),
                          )
                        : Text(
                            _getInitials(widget.bill['name']),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                  ),
                  const SizedBox(width: 16), // Space between avatar and content

                  // Card Content Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with name and amount
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

                        // First order item
                        Text(
                          '${orderItems[0]['itemCount']}x ${orderItems[0]['itemName']}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),

                        // "View More" Button
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

                        // Expanded order items
                        if (isExpanded && orderItems.length > 1)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: orderItems
                                .skip(
                                    1) // Skip the first item as it's already shown
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
                ],
              ),
            ),
            // Divider after the card
            // Divider(
            //   color: Colors.grey[300],
            //   thickness: 1,
            //   indent: 16.0,
            //   endIndent: 16.0,
            // ),
          ],
        ),
      ),
    );
  }
}
