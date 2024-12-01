import 'package:flutter/material.dart';
import 'table_screen.dart'; // Your home screen
import 'menu_screen.dart';
import 'updates_screen.dart';
import 'account_screen.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Screens for each tab
  final List<Widget> _screens = [
    TableScreen(), // Table (Home)
    MenuScreen(),
    UpdatesScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Table',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Updates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromRGBO(239, 180, 7, 1), // Highlighted color
        unselectedItemColor: Colors.grey, // Unselected icon color
        onTap: _onItemTapped,
      ),
    );
  }
}
