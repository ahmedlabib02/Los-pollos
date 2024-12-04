import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/screens/Client/add_menu_item_screen.dart';
import 'package:los_pollos_hermanos/screens/Client/order_history_screen.dart';
import 'table_screen.dart'; // Your home screen
import 'menu_screen.dart';
import 'updates_screen.dart';
import 'create_table_screen.dart'; // Import Create Table screen
import 'choose_restaurant_screen.dart'; // Import Choose Restaurant screen
import 'account_screen.dart'; // Import Account screen

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Screens for each tab
  final List<Widget> _screens = [
    AddMenuItemScreen(), // Table (Home)
    MenuScreen(),
    UpdatesScreen(),
    CreateTableScreen(), // Create Table screen added
    OrderHistoryScreen(), // Order Summary screen added
  ];

  final List<String> _titles = [
    'Table',
    'Menu',
    'Updates',
    'Create Table',
    'Order Summary',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToAccountScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text(
              'Account',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Color.fromRGBO(242, 194, 48, 1),
            centerTitle: true,
          ),
          body: AccountScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: TextStyle(fontWeight: FontWeight.bold), // Optional: Bold title
        ),
        backgroundColor: Color.fromRGBO(242, 194, 48, 1),
        centerTitle: true, // Centers the title
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back icon
          tooltip: 'Back to Choose Restaurant',
          onPressed: () {
            // Navigate back to Choose Restaurant screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ChooseRestaurantScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person), // Account icon
            tooltip: 'Account',
            onPressed: () {
              _navigateToAccountScreen(context); // Navigate to AccountScreen
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory, // Removes ripple effect
          highlightColor: Colors.transparent, // Removes highlight effect
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Prevent tab enlargement
          elevation: 0.0, // Removes shadow effect
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
              icon: Icon(Icons.add_circle_outline),
              label: 'Create Table',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Order Summary',
            ),
          ],
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
