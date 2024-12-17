import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/table_model.dart' as TableModel;
import 'package:los_pollos_hermanos/services/client_services.dart';
import 'package:los_pollos_hermanos/services/manager_services.dart';
import 'package:los_pollos_hermanos/shared/TableCard.dart';

class TablesScreen extends StatefulWidget {
  final String restaurantId;

  const TablesScreen({super.key, required this.restaurantId});

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  final ManagerServices _managerServices = ManagerServices();
  final ClientService _clientService = ClientService();
  List<Map<String, dynamic>> _currentTables = [];
  List<Map<String, dynamic>> _pastTables = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTablesData();
  }

  Future<void> _loadTablesData() async {
    try {
      // Fetch current tables
      List<TableModel.Table> currentTables =
          await _managerServices.getCurrentTables(widget.restaurantId);
      // Fetch past tables
      List<TableModel.Table> pastTables =
          await _managerServices.getPastTables(widget.restaurantId);

      // Process and fetch users for each table
      List<Map<String, dynamic>> processedCurrentTables =
          await _processTables(currentTables);
      List<Map<String, dynamic>> processedPastTables =
          await _processTables(pastTables);

      setState(() {
        _currentTables = processedCurrentTables;
        _pastTables = processedPastTables;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading tables: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> _processTables(
      List<TableModel.Table> tables) async {
    List<Map<String, dynamic>> processedTables = [];
    for (var table in tables) {
      try {
        // Fetch users for the table
        List<Map<String, dynamic>> users = await _fetchUsers(table.userIds);
        double paidPercentage =
            await _clientService.calculatePaidPercentage(table.id);

        processedTables.add({
          'tableNumber': table.tableCode,
          'code': table.tableCode,
          'startTime':
              'Jan 30, 2024 - 7:00 PM', // Replace with real start time if available
          'paidPercentage': paidPercentage,
          'orderStatus': table.isOngoing ? 'On-going' : 'Completed',
          'members': users,
        });
      } catch (e) {
        print('Error processing table ${table.id}: $e');
      }
    }
    return processedTables;
  }

  Future<List<Map<String, dynamic>>> _fetchUsers(List<String> userIds) async {
    List<Map<String, dynamic>> fetchedUsers = [];
    for (String userId in userIds) {
      try {
        Map<String, dynamic> user = await _clientService.getUserById(userId);
        fetchedUsers.add(user);
      } catch (e) {
        print('Error fetching user $userId: $e');
      }
    }
    return fetchedUsers;
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
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  // On-going Tab
                  ListView.separated(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    itemCount: _currentTables.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final table = _currentTables[index];
                      return TableCard(
                        screenWidth: screenWidth,
                        tableName: 'Table - ${table['code']}',
                        startTime: table['startTime'],
                        members: table['members'],
                        paidPercentage: table['paidPercentage'],
                        orderStatus: table['orderStatus'],
                        tableCode: table['code'],
                        role: 'manager',
                        context: context,
                      );
                    },
                  ),
                  // Past Tab
                  ListView.separated(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    itemCount: _pastTables.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final table = _pastTables[index];
                      return TableCard(
                        screenWidth: screenWidth,
                        tableName: 'Table - ${table['code']}',
                        startTime: table['startTime'],
                        members: table['members'],
                        paidPercentage: table['paidPercentage'],
                        orderStatus: table['orderStatus'],
                        tableCode: table['code'], // Pass the table code
                        role: 'manager',
                        context: context,
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
