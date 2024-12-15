import 'package:flutter/material.dart';

class TableScreen extends StatelessWidget {
  final String tableCode;

  TableScreen({required this.tableCode});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Table Screen',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Your table code: $tableCode',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
