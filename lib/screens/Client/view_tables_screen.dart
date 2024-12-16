import 'package:flutter/material.dart';

class TablesPage extends StatefulWidget {
  const TablesPage({super.key});

  @override
  State<TablesPage> createState() => _TablesPageState();
}

class _TablesPageState extends State<TablesPage> {
  bool isOngoingSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Tables",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Toggle Buttons (Ongoing | Past)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFDF4D8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                // On-going Button
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isOngoingSelected = true;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isOngoingSelected
                            ? const Color(0xFFFFF2CC)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "On-going",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                // Past Button
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isOngoingSelected = false;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: !isOngoingSelected
                            ? const Color(0xFFFFF2CC)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Past",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Table List
          Expanded(
            child: ListView(
              children: const [
                TableCard(
                  tableName: "Table 1 - BFR193",
                  time: "Started 5:40 PM",
                  members: 4,
                  paymentStatus: "80% paid",
                  orderStatus: "No orders placed",
                ),
                TableCard(
                  tableName: "Table 2 - FKS385",
                  time: "Started 7:00 PM",
                  members: 6,
                  paymentStatus: "0% paid",
                  orderStatus: "Orders in progress",
                ),
                TableCard(
                  tableName: "Table 3 - KDS265",
                  time: "Started 7:10 PM",
                  members: 3,
                  paymentStatus: "100% paid",
                  orderStatus: "All orders served",
                ),
                TableCard(
                  tableName: "Table 4 - GDF947",
                  time: "Started 5:40 PM",
                  members: 4,
                  paymentStatus: "30% paid",
                  orderStatus: "No orders placed",
                ),
                TableCard(
                  tableName: "Table 5 - VDE166",
                  time: "Started 7:00 PM",
                  members: 6,
                  paymentStatus: "0% paid",
                  orderStatus: "Orders in progress",
                ),
              ],
            ),
          ),

          // Bottom Navigation
          BottomNavigationBar(
            currentIndex: 0,
            selectedItemColor: const Color(0xFFFBC02D),
            unselectedItemColor: Colors.black54,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.table_chart),
                label: "Tables",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: "Menu",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.update),
                label: "Updates",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: "Account",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TableCard extends StatelessWidget {
  final String tableName;
  final String time;
  final int members;
  final String paymentStatus;
  final String orderStatus;

  const TableCard({
    super.key,
    required this.tableName,
    required this.time,
    required this.members,
    required this.paymentStatus,
    required this.orderStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Table Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tableName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.yellow,
                      child: Icon(Icons.person, size: 14),
                    ),
                    const SizedBox(width: 5),
                    const Text("+1"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),

            // Time and Members
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  time,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(width: 15),
                const Icon(Icons.people, size: 16, color: Colors.grey),
                const SizedBox(width: 5),
                Text(
                  "$members members",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 5),

            // Payment Status
            Row(
              children: [
                const Icon(Icons.payments_outlined,
                    size: 16, color: Colors.orange),
                const SizedBox(width: 5),
                Text(
                  paymentStatus,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),

            const SizedBox(height: 5),

            // Order Status and View Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: _getStatusColor(orderStatus),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    orderStatus,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text("View"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "No orders placed":
        return Colors.grey.shade300;
      case "Orders in progress":
        return const Color(0xFFFFF2CC);
      case "All orders served":
        return const Color(0xFFFFE082);
      default:
        return Colors.grey;
    }
  }
}
