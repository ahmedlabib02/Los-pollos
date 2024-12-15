// // lib/screens/wrapper.dart

// import 'package:flutter/material.dart';
// // import 'package:los_pollos_hermanos/models/client_model.dart';
// import 'package:los_pollos_hermanos/models/customUser.dart';
// import 'package:los_pollos_hermanos/screens/Client/add_menu_item_screen.dart';
// import 'package:los_pollos_hermanos/screens/Client/choose_restaurant_screen.dart';
// import 'package:los_pollos_hermanos/screens/Client/main_page.dart';
// import 'package:los_pollos_hermanos/screens/Client/menu_screen.dart';
// import 'package:los_pollos_hermanos/screens/Client/table_screen.dart';
// import 'package:los_pollos_hermanos/screens/Client/test_screen.dart';
// import 'package:los_pollos_hermanos/screens/Dummy/dummy_screen.dart';
// import 'package:los_pollos_hermanos/screens/Manager/view_tables_screen.dart';
// import 'package:los_pollos_hermanos/screens/authenticate/authenticate.dart';
// import './Manager/home.dart';
// import 'package:provider/provider.dart';

// class Wrapper extends StatelessWidget {
//   const Wrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<CustomUser?>(context);

//     if (user == null) {
//       return const Authenticate();
//     } else {
//       if (user.role == 'client') {
//         // return TestScreen();
//         // return AddMenuItemScreen();
//         // return TableScreen();
//         // return TablesScreen();
//         // return DummyScreen();
//         // return MenuScreen();
//         // return ChooseRestaurantScreen();
//         return MainPage();
//       } else {
//         return const ManagerHome();
//       }
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/customUser.dart';
import 'package:los_pollos_hermanos/provider/table_state_provider.dart';
import 'package:los_pollos_hermanos/screens/Client/bill_summary_screen_dummy_data.dart';
import 'package:los_pollos_hermanos/screens/Client/choose_restaurant_screen.dart';
import 'package:los_pollos_hermanos/screens/Client/main_page.dart';
import 'package:los_pollos_hermanos/screens/Manager/home.dart';
import 'package:los_pollos_hermanos/screens/authenticate/authenticate.dart';
import 'package:los_pollos_hermanos/services/client_services.dart';
import 'package:provider/provider.dart';
import 'package:los_pollos_hermanos/models/table_model.dart' as custom_table;

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  Future<custom_table.Table?> _getOngoingTable(String userId) async {
    try {
      return await ClientService().getOngoingTableForUser(userId);
    } catch (e) {
      debugPrint('Error fetching ongoing table: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    if (user == null) {
      return const Authenticate();
    } else {
      if (user.role == 'client') {
        return FutureBuilder<custom_table.Table?>(
          future: _getOngoingTable(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading data'));
            } else {
              final ongoingTable = snapshot.data;

              // Use WidgetsBinding to update the provider after the build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (ongoingTable != null) {
                  Provider.of<TableState?>(context, listen: false)?.joinTable();
                }
              });
              // Conditionally return MainPage or ChooseRestaurantScreen
              if (ongoingTable != null) {
                // return BillSummaryScreen();
                return MainPage();
              } else {
                return ChooseRestaurantScreen();
              }
            }
          },
        );
      } else {
        return const ManagerHome();
      }
    }
  }
}
