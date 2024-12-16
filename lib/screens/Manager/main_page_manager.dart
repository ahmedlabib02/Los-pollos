import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/customUser.dart';
import 'package:los_pollos_hermanos/screens/Client/account_screen.dart';
import 'package:los_pollos_hermanos/screens/Client/dummy.dart';
import 'package:los_pollos_hermanos/provider/table_state_provider.dart';
import 'package:los_pollos_hermanos/models/client_model.dart';
import 'package:los_pollos_hermanos/screens/Manager/add_menu_item_screen.dart';
import 'package:los_pollos_hermanos/screens/Client/menu_screen.dart';
import 'package:los_pollos_hermanos/screens/Client/table_screen.dart';
import 'package:los_pollos_hermanos/screens/Manager/view_tables_screen.dart';
import 'package:los_pollos_hermanos/screens/chat/chat_overlay.dart';
import 'package:los_pollos_hermanos/screens/wrapper.dart';
import 'package:los_pollos_hermanos/services/auth.dart';
import 'package:los_pollos_hermanos/shared/Styles.dart';
import 'package:provider/provider.dart';

class MainPageManager extends StatefulWidget {
  @override
  _MainPageManagerState createState() => _MainPageManagerState();
}

class _MainPageManagerState extends State<MainPageManager> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  final List<String> _titles = [
    'Tables',
    'Menu',
    'Tables',
    'Account',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    // Screens for each tab
    final List<Widget> _screens = [
      TablesScreen(
        restaurantId: user!.uid,
      ),
      MenuScreen(),
      // TablesScreen(),
      AccountScreen(),
    ];
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory, // Removes ripple effect
          highlightColor: Colors.transparent, // Removes highlight effect
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Prevent tab enlargement
          elevation: 0.0, // Removes shadow effect
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Table',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Menu',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.notifications),
            //   label: 'Updates',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex,
          selectedItemColor:
              Color.fromRGBO(239, 180, 7, 1), // Highlighted color
          unselectedItemColor: Colors.grey, // Unselected icon color
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
