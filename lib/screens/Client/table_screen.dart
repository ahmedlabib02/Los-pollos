import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/screens/Client/bill_summary_screen.dart';
import 'package:los_pollos_hermanos/services/client_services.dart';
import 'package:los_pollos_hermanos/shared/CustomChip.dart';
import 'package:los_pollos_hermanos/shared/Styles.dart';
import 'package:los_pollos_hermanos/shared/TableRing.dart';
import 'package:los_pollos_hermanos/shared/temp_vars.dart';
import 'package:los_pollos_hermanos/widgets/order_summary.dart';
import 'package:los_pollos_hermanos/models/table_model.dart' as TableModel;

class TableScreen extends StatefulWidget {
  final String tableCode;
  final String role; // "user" or "manager"

  const TableScreen({
    Key? key,
    required this.tableCode,
    required this.role, // pass the role as well
  }) : super(key: key);

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  final double pad = 24.0;
  final ClientService _clientService = ClientService();
  TableModel.Table? currentTable;
  bool isLoading = true;
  List<Map<String, dynamic>> users = [];
  double paidPercentage = 0.0;

  @override
  void initState() {
    super.initState();
    _loadTableData();
  }

  Future<void> _loadTableData() async {
    try {
      TableModel.Table? table =
          await _clientService.getTableByCode(widget.tableCode);
      if (table != null) {
        List<Map<String, dynamic>> fetchedUsers =
            await _fetchUsers(table.userIds);
        double percentage =
            await _clientService.calculatePaidPercentage(table.id);
        setState(() {
          currentTable = table;
          users = fetchedUsers;
          // paidPercentage = percentage; (assign if you need to use the value)
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading table: $e');
      setState(() {
        isLoading = false;
      });
    }
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
    return Scaffold(
      // Conditionally add an app bar only if role == "manager"
      appBar: widget.role == 'manager'
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Table',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26.0,
                ),
              ),
              backgroundColor: Colors.white,
              scrolledUnderElevation: 0,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(10.0),
                child: Container(
                  color: Styles.inputFieldBorderColor,
                  height: 1.0,
                ),
              ),
              centerTitle: true,
            )
          : null, // If "user", no app bar

      body: Padding(
        padding: EdgeInsets.only(left: pad, right: pad, top: 10),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : currentTable == null
                ? const Center(child: Text('Table not found'))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        TableRing(
                          tableCode: widget.tableCode,
                          progressValue: paidPercentage / 100,
                          members: users,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: Styles.inputFieldBorderColor,
                                      width: 0.8,
                                    ),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: CustomChip('${paidPercentage}% paid'),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    right: BorderSide(
                                      color: Styles.inputFieldBorderColor,
                                      width: 0.8,
                                    ),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: CustomChip(
                                  '${currentTable!.totalAmount} EGP due',
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxHeight: 30,
                                    maxWidth: 80,
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BillSummaryScreen(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF2C230),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 0.0),
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Track bill',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: Styles.inputFieldTextColor,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        const Text(
                          'Order Summary',
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            height: 500,
                            decoration: BoxDecoration(
                              color: Styles.inputFieldBgColor,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: OrderSummary(tableId: currentTable!.id),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
