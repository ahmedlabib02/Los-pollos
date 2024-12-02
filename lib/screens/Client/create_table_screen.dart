import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/customUser.dart';
import 'package:provider/provider.dart';
import '../../services/client_services.dart';

class CreateTableScreen extends StatelessWidget {
  final ClientService _clientServices = ClientService();

  @override
  Widget build(BuildContext context) {
    final TextEditingController tableCodeController = TextEditingController();
    final user = Provider.of<CustomUser?>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                // Call backend to create table
                try {
                  String tableCode =
                      await _clientServices.createTable(user!.uid);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Table Created'),
                      content: Text('Your table code is: $tableCode'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error creating table: $e')),
                  );
                }
              },
              child: Text('Create a Table'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(239, 180, 7, 1)),
            ),
            SizedBox(height: 20),
            TextField(
              controller: tableCodeController,
              decoration: InputDecoration(
                hintText: 'Enter Table Code to Join',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Call backend to join table
                String tableCode = tableCodeController.text;
                if (tableCode.isNotEmpty) {
                  try {
                    await _clientServices.getTableByID(tableCode);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Joined table successfully!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error joining table: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a table code')),
                  );
                }
              },
              child: Text('Join Table'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(239, 180, 7, 1)),
            ),
          ],
        ),
      ),
    );
  }
}
