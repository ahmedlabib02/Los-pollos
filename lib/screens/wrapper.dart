// lib/screens/wrapper.dart

import 'package:flutter/material.dart';
// import 'package:los_pollos_hermanos/models/client_model.dart';
import 'package:los_pollos_hermanos/models/customUser.dart';
import 'package:los_pollos_hermanos/screens/Client/add_menu_item_screen.dart';
import 'package:los_pollos_hermanos/screens/Client/menu_screen.dart';
import 'package:los_pollos_hermanos/screens/Client/table_screen.dart';
import 'package:los_pollos_hermanos/screens/Client/test_screen.dart';
import 'package:los_pollos_hermanos/screens/Dummy/dummy_screen.dart';
import 'package:los_pollos_hermanos/screens/Manager/view_tables_screen.dart';
import 'package:los_pollos_hermanos/screens/authenticate/authenticate.dart';
import './Manager/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    if (user == null) {
      return const Authenticate();
    } else {
      if (user.role == 'client') {
        // return TestScreen();
        // return AddMenuItemScreen();
        // return TableScreen();
        // return TablesScreen();
        // return DummyScreen();
        return MenuScreen();
      } else {
        return const ManagerHome();
      }
    }
  }
}
