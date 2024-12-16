import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/customUser.dart';
import 'package:los_pollos_hermanos/provider/selected_restaurant_provider.dart';
import 'package:los_pollos_hermanos/provider/table_state_provider.dart';
import 'package:provider/provider.dart';
import '../../services/client_services.dart';
import 'package:los_pollos_hermanos/models/table_model.dart' as custom_table;

class CreateTableScreen extends StatelessWidget {
  final Function(String) onTableCreated; // Callback for table creation
  final ClientService _clientServices = ClientService();

  CreateTableScreen({required this.onTableCreated});

  @override
  Widget build(BuildContext context) {
    final TextEditingController tableCodeController = TextEditingController();
    final user = Provider.of<CustomUser?>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image Section
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/restaurant_background.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(flex: 1, child: SizedBox()), // Space for the sheet
              ],
            ),
          ),

          // Bottom Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Create Table Button
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        String restaurantId =
                            Provider.of<SelectedRestaurantProvider?>(context,
                                        listen: false)
                                    ?.selectedRestaurantId ??
                                '';
                        custom_table.Table table = await _clientServices
                            .createTable(user!.uid, restaurantId);
                        String createdTableCode = table.tableCode;
                        Provider.of<TableState>(
                          context,
                          listen: false,
                        ).joinTable();

                        // Show Bill Splitting Mode Popup
                        showBillSplittingPopup(context, table.id);

                        onTableCreated(
                            createdTableCode); // Pass table code to callback
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Table created successfully!')),
                        );
                      } catch (e) {
                        String errorMessage =
                            e.toString().contains('Exception: ')
                                ? e.toString().split('Exception: ').last
                                : e.toString();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage)),
                        );
                      }
                    },
                    child: Text(
                      'Create Table',
                      style: TextStyle(
                        color: Color.fromRGBO(128, 123, 123, 1),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(239, 193, 52, 1),
                      minimumSize: Size(double.infinity, 50), // Wider buttons
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Less circular
                      ),
                    ),
                  ),
                  SizedBox(height: 40),

                  // Join Table Button
                  ElevatedButton(
                    onPressed: () {
                      // Show popup dialog with table code input
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Color.fromARGB(
                                255, 245, 245, 245), // Light gray background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: Center(
                              child: Text(
                                'Join a Table',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: tableCodeController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Table Code',
                                    labelText: 'Table Code',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    filled: true,
                                    fillColor:
                                        Color.fromARGB(255, 246, 246, 246),
                                  ),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 240, 240, 240),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  )),
                              ElevatedButton(
                                onPressed: () async {
                                  String inputTableCode =
                                      tableCodeController.text;
                                  if (inputTableCode.isNotEmpty) {
                                    try {
                                      String tableId = await _clientServices
                                          .joinTable(inputTableCode, user!.uid);
                                      Provider.of<TableState>(
                                        context,
                                        listen: false,
                                      ).joinTable();
                                      onTableCreated(
                                          tableId); // Pass joined table code
                                      Navigator.pop(
                                          context); // Close the dialog
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Joined table successfully!')),
                                      );
                                    } catch (e) {
                                      String errorMessage =
                                          e.toString().contains('Exception: ')
                                              ? e
                                                  .toString()
                                                  .split('Exception: ')
                                                  .last
                                              : e.toString();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text(errorMessage)),
                                      );
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Please enter a table code')),
                                    );
                                  }
                                },
                                child: Text('Join',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromRGBO(239, 193, 52, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      'Join Table',
                      style: TextStyle(color: Color.fromRGBO(128, 123, 123, 1)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(239, 193, 52, 1),
                      minimumSize: Size(double.infinity, 50), // Wider buttons
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Less circular
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showBillSplittingPopup(BuildContext context, String tableId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Choose Your Bill Splitting Mode',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Split Equally'),
                subtitle: const Text(
                    'The whole table bill is divided equally among diners.'),
                leading: const Icon(Icons.people),
                onTap: () {
                  updateTableStatus(tableId, true);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Fair Share, No More'),
                subtitle: const Text(
                    'Each diner pays only for what they ordered. Shared items divided equally.'),
                leading: const Icon(Icons.fastfood),
                onTap: () {
                  updateTableStatus(tableId, false);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // update table statis in firestore
  void updateTableStatus(String tableId, bool billSplittingMode) async {
    await ClientService().updateTableSplitStatus(tableId, billSplittingMode);
  }
}
