import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/shared/BlobRow.dart';
import 'package:los_pollos_hermanos/shared/PaymentProgressIndicator.dart';
import 'package:los_pollos_hermanos/shared/Styles.dart';

void main() {
  runApp(MaterialApp(
    home: TablesScreen(),
  ));
}

class TablesScreen extends StatelessWidget {
  // double screenWidth,
  //     String tableName,
  //     String startTime,
  //     int members,
  //     double paidStatus,
  //     String orderStatus,
  //     List<String> initials

  List<Map<String, dynamic>> tables = [
    {
      'tableNumber': 1,
      'tableCode': 'BFR193',
      'startTime': 'Jan 30, 2024 - 5:40 PM',
      'members': 4,
      'paidPercentage': 0.8,
      'orderStatus': 'No orders placed',
      'initials': ['A', 'B', 'C']
    },
    {
      'tableNumber': 2,
      'tableCode': 'FKS385',
      'startTime': 'Jan 30, 2024 - 7:00 PM',
      'members': 6,
      'paidPercentage': 0,
      'orderStatus': 'Orders in progress',
      'initials': ['D', 'E']
    },
    {
      'tableNumber': 3,
      'tableCode': 'KDS265',
      'startTime': 'Jan 30, 2024 - 7:20 PM',
      'members': 6,
      'paidPercentage': 1,
      'orderStatus': 'All orders served',
      'initials': ['V', 'W', 'X', 'Y', 'Z']
    }
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Center(
            child: Text(
              'Tables',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.06,
                color: Colors.black,
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(screenHeight * 0.06),
            child: const TabBar(
              indicatorColor: Color(0xFFF2C230),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'On-going'),
                Tab(text: 'Past'),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // On-going Tab
            ListView(
              padding: EdgeInsets.all(screenWidth * 0.03),
              children: tables.map((table) {
                return tableCard(
                  screenWidth,
                  'Table ' +
                      table['tableNumber'].toString() +
                      ' - ' +
                      table['tableCode'],
                  table['startTime'],
                  table['members'],
                  table['paidPercentage'].toDouble(),
                  table['orderStatus'],
                  table['initials'],
                );
              }).toList(),
            ),
            // Past Tab
            const Center(
              child: Text('Past Tables'),
            ),
          ],
        ),
      ),
    );
  }

  Widget tableCard(
      double screenWidth,
      String tableName,
      String startTime,
      int members,
      double paidStatus,
      String orderStatus,
      List<String> initials) {
    Map<String, Color> colorMap = {
      'No orders placed': const Color.fromARGB(255, 235, 235, 235),
      'Orders in progress': const Color(0xFFFFEBAE).withOpacity(0.5),
      'All orders served': const Color(0xFFF2C230),
    };
    // Entire card
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(screenWidth * 0.015),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header with Bottom Divider
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.0,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      tableName,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    BlobRow(initials, -screenWidth * 0.01, screenWidth * 0.025),
                  ],
                ),
              ),
            ),
          ),
          // Start Time, Members, and Status
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.03, vertical: screenWidth * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Start Time and Chip
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          // color: Colors.purple,
                          height: screenWidth * 0.04,
                          width: screenWidth * 0.04,
                          child: const FittedBox(
                            child: Icon(Icons.access_time, color: Colors.black),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.015),
                        Text(
                          startTime,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth * 0.035),
                        ),
                      ],
                    ),
                    // Order Status
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: screenWidth * 0.004),
                      decoration: BoxDecoration(
                        color: colorMap[orderStatus],
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      ),
                      child: Text(
                        orderStatus,
                        style: TextStyle(
                            color: Colors.black, fontSize: screenWidth * 0.025),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenWidth * 0.015),
                // Members Info
                Row(
                  children: [
                    Container(
                      // color: Colors.blue,
                      height: screenWidth * 0.04,
                      width: screenWidth * 0.04,
                      child: const FittedBox(
                        child: Icon(Icons.people, color: Colors.black),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.015),
                    Text(
                      '$members members',
                      style: TextStyle(
                          color: Colors.black, fontSize: screenWidth * 0.035),
                    ),
                  ],
                ),
                SizedBox(height: screenWidth * 0.015),
                // Paid Status and Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(screenWidth * 0.004),
                          height: screenWidth * 0.04,
                          width: screenWidth * 0.04,
                          child: FittedBox(
                            child: PaymentProgressIndicator(
                                screenWidth * 0.012, paidStatus),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.015),
                        Text(
                          '${(paidStatus * 100).round()}% paid',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: screenWidth * 0.035),
                        ),
                      ],
                    ),
                    // View Button
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: screenWidth * 0.07,
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.015),
                          ),
                        ),
                        child: Text(
                          'View',
                          style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
