// import 'package:flutter/material.dart';
// import 'package:los_pollos_hermanos/provider/table_state_provider.dart';
// import 'package:provider/provider.dart';

// class TableScreen extends StatelessWidget {
//   final String tableCode;

//   TableScreen({required this.tableCode});

//   @override
//   Widget build(BuildContext context) {

//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             'Table Screen',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 16),
//           Text(
//             'Your table code: $tableCode',
//             style: TextStyle(fontSize: 18),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/provider/table_state_provider.dart';
import 'package:provider/provider.dart';

class TableScreen extends StatefulWidget {
  final String tableCode;

  TableScreen({required this.tableCode});

  @override
  _TableScreenState createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  @override
  void initState() {
    super.initState();
    // Call joinTable when the screen is initialized
    Future.delayed(Duration.zero, () {
      // Ensures that joinTable is called after the build phase
      Provider.of<TableState>(context, listen: false).joinTable();
    });
  }

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
            'Your table code: ${widget.tableCode}',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
