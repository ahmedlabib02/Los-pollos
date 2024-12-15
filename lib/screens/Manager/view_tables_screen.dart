import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:los_pollos_hermanos/shared/AvatarGroup.dart';
import 'package:los_pollos_hermanos/shared/PaymentProgressIndicator.dart';
import 'package:los_pollos_hermanos/shared/Styles.dart';
import 'package:los_pollos_hermanos/shared/TableCard.dart';
import 'package:los_pollos_hermanos/shared/temp_vars.dart';

class TablesScreen extends StatefulWidget {
  TablesScreen({super.key});

  static const List<Map<String, String>> users = TempVars.users;
  List<Map<String, dynamic>> tables = [
    {
      'tableNumber': 1,
      'code': 'BFR193',
      'startTime': 'Jan 30, 2024 - 5:40 PM',
      'paidPercentage': 0.8,
      'orderStatus': 'No orders placed',
      'members': [users[0], users[1], users[2]]
    },
    {
      'tableNumber': 2,
      'code': 'FKS385',
      'startTime': 'Jan 30, 2024 - 7:00 PM',
      'paidPercentage': 0,
      'orderStatus': 'Orders in progress',
      'members': [users[3], users[4]]
    },
    {
      'tableNumber': 3,
      'code': 'KDS265',
      'startTime': 'Jan 30, 2024 - 7:20 PM',
      'paidPercentage': 1,
      'orderStatus': 'All orders served',
      'members': [users[5], users[6], users[7], users[8], users[0], users[1]]
    }
  ];

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  List<Map<String, dynamic>> _tables = [];
  void initState() {
    _tables = widget.tables;
  }

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
            ListView.separated(
              padding: EdgeInsets.all(screenWidth * 0.03),
              itemCount: _tables.length,
              separatorBuilder: (context, index) => Container(
                  // color: Colors.transparent,
                  height: 10.0), // Adjust height as needed
              itemBuilder: (context, index) {
                final table = _tables[index];

                return TableCard(
                  screenWidth: screenWidth,
                  tableName: 'Table ${table['tableNumber']} - ' + table['code'],
                  startTime: table['startTime'],
                  members: table['members'],
                  paidPercentage: table['paidPercentage'].toDouble(),
                  orderStatus: table['orderStatus'],
                );
              },
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
}
