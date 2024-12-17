import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/provider/table_state_provider.dart';
import 'package:provider/provider.dart';
import '../../models/customUser.dart';
import 'package:los_pollos_hermanos/models/table_model.dart' as custom_table;
import '../../services/client_services.dart';
import 'create_table_screen.dart';
import 'table_screen.dart';

class TableScreenWrapper extends StatefulWidget {
  @override
  _TableScreenWrapperState createState() => _TableScreenWrapperState();
}

class _TableScreenWrapperState extends State<TableScreenWrapper> {
  final ClientService _clientService = ClientService();
  String? tableCode; // Tracks the ongoing table code
  bool isLoading = true; // Tracks whether we are checking ongoing tables

  @override
  void initState() {
    super.initState();
    _checkOngoingTable();
  }

  @override
  void dispose() {
    // Cancel ongoing tasks or subscriptions
    super.dispose();
  }

  Future<void> _checkOngoingTable() async {
    if (!mounted) {
      return;
    }
    final user = Provider.of<CustomUser?>(context, listen: false);
    if (user != null) {
      try {
        custom_table.Table? ongoingTable =
            await _clientService.getOngoingTableForUser(user.uid);
        setState(() {
          tableCode = ongoingTable?.tableCode; // Set the table code if found
          isLoading = false; // Finished loading
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error checking ongoing table: $e')),
        );
        setState(() {
          isLoading = false; // Finished loading even if there's an error
        });
      }
    } else {
      setState(() {
        isLoading = false; // Finished loading if no user
      });
    }
  }

  void _setTableCode(String code) {
    setState(() {
      tableCode = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tableState = Provider.of<TableState>(context);

    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: tableCode == null || !tableState.isInTable
          ? CreateTableScreen(onTableCreated: _setTableCode)
          : TableScreen(tableCode: tableCode!, role: 'user'),
    );
  }
}
