import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/client_model.dart';
import 'package:los_pollos_hermanos/models/customUser.dart';
import 'package:los_pollos_hermanos/models/menu_item_model.dart';
import 'package:los_pollos_hermanos/models/order_item_model.dart';
import 'package:los_pollos_hermanos/services/client_services.dart';

import 'package:los_pollos_hermanos/services/notification_services.dart';

import 'package:los_pollos_hermanos/services/manager_services.dart';

import 'package:los_pollos_hermanos/shared/AvatarGroup.dart';
import 'package:los_pollos_hermanos/shared/Dropdown.dart';
import 'package:los_pollos_hermanos/shared/Styles.dart';
import 'package:provider/provider.dart';

class OrderItemCard extends StatefulWidget {
  final OrderItem orderItem;

  const OrderItemCard({
    required this.orderItem,
    Key? key,
  }) : super(key: key);

  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  late Future<Map<String, dynamic>> _fetchFuture;
  OrderItem? _orderItem;

  @override
  void initState() {
    super.initState();
    _orderItem = widget.orderItem;
    _fetchFuture = _fetchData();
  }

  Future<Map<String, dynamic>> _fetchData() async {
    final clientService = ClientService();

    // Fetch the updated OrderItem from the backend to ensure userIds are up to date
    OrderItem? updatedOrderItem =
        await clientService.getOrderItem(_orderItem!.id);
    if (updatedOrderItem == null) {
      throw 'Order item not found on re-fetch';
    }

    _orderItem = updatedOrderItem; // Update the local state reference

    // Fetch menuItem
    MenuItem? menuItem =
        await clientService.getMenuItem(_orderItem!.menuItemId);

    // Fetch users based on updated _orderItem
    List<Map<String, dynamic>> users = [];
    for (String userId in _orderItem!.userIds) {
      if (userId.isEmpty) continue;
      Client? client = await clientService.getClient(userId);
      if (client != null) {
        users.add(client.toMap());
      }
    }

    return {
      'orderItem': _orderItem,
      'menuItem': menuItem,
      'users': users,
    };
  }

  void _showBottomDrawer(BuildContext context, MenuItem menuItem,
      List<Map<String, dynamic>> users, String loggedInUserId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return BottomSheetContent(
          menuItem: menuItem,
          users: users,
          orderItem: _orderItem!,
          loggedInUserId: loggedInUserId,
          onOrderItemChanged: () async {
            // Re-fetch data after the user leaves the order
            setState(() {
              _fetchFuture = _fetchData();
            });
          },
        );
      },
    );
  }

  void _showReviewBottomDrawer(
      BuildContext context, MenuItem menuItem, String loggedInUserId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return ReviewBottomSheet(
          menuItem: menuItem,
          loggedInUserId: loggedInUserId,
          onReviewSubmitted: () async {
            // Re-fetch data after the user leaves the order
            setState(() {
              _fetchFuture = _fetchData();
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String loggedInUserId = Provider.of<CustomUser?>(context)!.uid;

    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // empty box of height 50 and margin 16
          return Container(
            height: 50,
            margin: const EdgeInsets.all(20),
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData ||
            snapshot.data!['menuItem'] == null ||
            snapshot.data!['orderItem'] == null) {
          return const Center(child: Text('Menu item or order item not found'));
        }

        final orderItem = snapshot.data!['orderItem'] as OrderItem;
        final menuItem = snapshot.data!['menuItem'] as MenuItem;
        final users = snapshot.data!['users'] as List<Map<String, dynamic>>;

        // Use the newly fetched orderItem instead of _orderItem
        return Container(
          // color: Colors.green,
          // padding: const EdgeInsets.only(top: 2.0),
          margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.circular(12.0),
          //   boxShadow: const [
          //     BoxShadow(
          //       color: Colors.black12,
          //       blurRadius: 0.0,
          //       offset: Offset(0, 0),
          //     ),
          //   ],
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      menuItem.imageUrl!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  menuItem.name,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  ' - x${orderItem.itemCount}',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 0.0),
                              decoration: BoxDecoration(
                                color: _getStatusColor(orderItem.status),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                _getStatusText(orderItem.status),
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 2.0),
                        AvatarGroup(
                          content: users,
                          spacing: screenWidth * -0.015,
                          radius: screenWidth * 0.025,
                          cutoff: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),

              // Details Button
              Container(
                // color: Colors.red,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total  ${(orderItem.price).toStringAsFixed(2)} EGP',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 35),
                          child: TextButton(
                            onPressed: () {
                              _showBottomDrawer(
                                  context, menuItem, users, loggedInUserId);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text(
                              'Details',
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                decoration: TextDecoration.underline,

                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        if (orderItem.status == OrderStatus.served)
                          ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 35),
                            child: TextButton(
                              onPressed: () {
                                _showReviewBottomDrawer(
                                    context, menuItem, loggedInUserId);
                              },
                              style: TextButton.styleFrom(),
                              child: const Text(
                                'Review',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 93, 93, 93),
                                  decoration: TextDecoration.underline,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class BottomSheetContent extends StatefulWidget {
  final MenuItem menuItem;
  final List<Map<String, dynamic>> users;
  final OrderItem orderItem;
  final String loggedInUserId;
  final VoidCallback onOrderItemChanged;

  const BottomSheetContent({
    Key? key,
    required this.menuItem,
    required this.users,
    required this.orderItem,
    required this.loggedInUserId,
    required this.onOrderItemChanged,
  }) : super(key: key);

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  late OrderItem _localOrderItem;
  late List<Map<String, dynamic>> _localUsers;

  @override
  void initState() {
    super.initState();
    _localOrderItem = widget.orderItem;
    _localUsers = List<Map<String, dynamic>>.from(widget.users);
  }

  Future<void> _leaveOrder() async {
    try {
      await ClientService().removeUserFromOrderItem(
        orderItemId: _localOrderItem.id,
        userId: widget.loggedInUserId,
      );

      setState(() {
        // Update order item
        final updatedUserIds = List<String>.from(_localOrderItem.userIds);
        updatedUserIds.remove(widget.loggedInUserId);
        var updatedMap = _localOrderItem.toMap();
        updatedMap['userIds'] = updatedUserIds;
        _localOrderItem = OrderItem.fromMap(updatedMap, _localOrderItem.id);

        // Remove user from local users
        _localUsers
            .removeWhere((user) => user['userID'] == widget.loggedInUserId);
      });

      // Notify parent so it can refetch
      widget.onOrderItemChanged();

      // Close bottom sheet
      // Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have left the shared order successfully.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to leave the order: $e')),
      );
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.accepted:
        return Colors.blue.withOpacity(0.4);
      case OrderStatus.inProgress:
        return Colors.orange.withOpacity(0.4);
      case OrderStatus.served:
        return Colors.green.withOpacity(0.4);
      default:
        return Colors.grey.withOpacity(0.4);
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.accepted:
        return 'Pending';
      case OrderStatus.inProgress:
        return 'In Progress';
      case OrderStatus.served:
        return 'Served';
      default:
        return 'Unknown';
    }
  }

  final NotificationService notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    String? loggedInUserRole = Provider.of<CustomUser?>(context)!.role;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header - Name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.menuItem.name,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('x${_localOrderItem.itemCount}',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ))
              ],
            ),
            const SizedBox(height: 12.0),

            // Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.menuItem.imageUrl!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Status",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                loggedInUserRole == 'manager'
                    ? DropdownButton<OrderStatus>(
                        value: _localOrderItem.status,
                        items: OrderStatus.values.map((OrderStatus status) {
                          return DropdownMenuItem<OrderStatus>(
                            value: status,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: _getStatusColor(status),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                _getStatusText(status),
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (OrderStatus? newStatus) async {
                          if (newStatus != null) {
                            try {
                              // Update the status locally
                              setState(() {
                                _localOrderItem.status = newStatus;
                              });

                              // Call service to update the status in the backend
                              await ManagerServices().updateOrderItemStatus(
                                orderItemId: _localOrderItem.id,
                                status: newStatus,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Order status updated to ${_getStatusText(newStatus)}.',
                                  ),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to update status: $e',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: _getStatusColor(_localOrderItem.status),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          _getStatusText(_localOrderItem.status),
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                      )
              ],
            ),
            const SizedBox(height: 16.0),

            // People Involved
            const Text(
              "Shared With",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8.0),
            AvatarGroup(
              content: _localUsers,
              radius: 20.0,
              spacing: -10.0,
              cutoff: 5,
            ),
            const SizedBox(height: 16.0),

            // Extras
            if (widget.menuItem.extras.isNotEmpty) ...[
              const Text(
                "Extras",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8.0),
              ...widget.menuItem.extras.entries.map((entry) => Text(
                    "${entry.key}: (+${entry.value.toStringAsFixed(2)} EGP)",
                    style: const TextStyle(fontSize: 14.0),
                  )),
              const SizedBox(height: 16.0),
            ],

            // Notes
            const Text(
              "Notes",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              _localOrderItem.notes.isNotEmpty
                  ? _localOrderItem.notes.join(", ")
                  : "No notes provided.",
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 16.0),

            // Variations
            if (widget.menuItem.variants.isNotEmpty) ...[
              const Text(
                "Variations",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.menuItem.variants.join(", "),
                style: const TextStyle(fontSize: 14.0),
              ),
              const SizedBox(height: 16.0),
            ],

            // Total Price
            Text(
              "Total: ${(widget.menuItem.price * _localOrderItem.itemCount).toStringAsFixed(2)} EGP",
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),

            // Buttons: Invite and Leave
            Row(
              children: [
                _localOrderItem.userIds.contains(widget.loggedInUserId)
                    ? Expanded(
                        child: ElevatedButton(
                          onPressed: _leaveOrder,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          child: const Text(
                            "Leave shared order",
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Prepare the parameters for the notification
                            List<String> userIds = _localOrderItem
                                .userIds; // User IDs involved in the order
                            String title =
                                "Join Request for Order"; // Title of the notification
                            String body =
                                "${widget.menuItem.name} - Shared Order Invite"; // Body content
                            String sentBy = widget
                                .loggedInUserId; // ID of the logged-in user
                            String orderId = _localOrderItem
                                .id; // The ID of the order being shared

                            // Call the notification service
                            notificationService.sendNotificationToMultipleUsers(
                              userIds,
                              title,
                              body,
                              sentBy,
                              orderId,
                            );

                            // Show a confirmation snackbar (optional)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Join request notification sent")),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Styles.primaryYellow,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          child: const Text(
                            "Send a join request",
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewBottomSheet extends StatefulWidget {
  final MenuItem menuItem;
  final String loggedInUserId;
  final VoidCallback onReviewSubmitted;

  const ReviewBottomSheet({
    Key? key,
    required this.menuItem,
    required this.loggedInUserId,
    required this.onReviewSubmitted,
  }) : super(key: key);

  @override
  _ReviewBottomSheetState createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  final TextEditingController _reviewController = TextEditingController();
  int _rating = 0; // Rating starts from 0 (no rating)

  Future<void> _submitReview() async {
    final String reviewText = _reviewController.text.trim();
    if (_rating == 0 || reviewText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a rating and a review.')),
      );
      return;
    }

    try {
      // Call a service to save the review
      await ClientService().addReview(
        widget.menuItem.id,
        widget.loggedInUserId,
        reviewText,
        _rating,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted successfully!')),
      );

      widget.onReviewSubmitted();
      Navigator.of(context).pop(); // Close the bottom sheet
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Center(
              child: Text(
                "Write a review for ${widget.menuItem.name}",
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Rating Section
            const Text(
              "Rating",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32.0,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1; // Stars are 1-based
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 16.0),

            // Review Input
            const Text(
              "Your Review",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Write your thoughts about the item...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                child: const Text(
                  "Submit Review",
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _getStatusColor(OrderStatus status) {
  switch (status) {
    case OrderStatus.accepted:
      return Colors.blue.withOpacity(0.2);
    case OrderStatus.inProgress:
      return Colors.orange.withOpacity(0.2);
    case OrderStatus.served:
      return Colors.green.withOpacity(0.2);
    default:
      return Colors.grey.withOpacity(0.2);
  }
}

String _getStatusText(OrderStatus status) {
  switch (status) {
    case OrderStatus.accepted:
      return 'Accepted';
    case OrderStatus.inProgress:
      return 'In Progress';
    case OrderStatus.served:
      return 'Served';
    default:
      return 'Unknown';
  }
}
