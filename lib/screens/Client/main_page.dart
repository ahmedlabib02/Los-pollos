import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/client_model.dart';
import 'package:los_pollos_hermanos/provider/table_state_provider.dart';
import 'package:los_pollos_hermanos/screens/Client/add_menu_item_screen.dart';
import 'package:los_pollos_hermanos/screens/Client/order_history_screen.dart';
// import 'package:los_pollos_hermanos/screens/Client/../../shared/TableRing_wrapper.dart';
import 'package:los_pollos_hermanos/screens/wrapper.dart';
import 'package:los_pollos_hermanos/screens/Client/table_screen_wrapper.dart'; // Import TableScreenWrapper
import 'package:los_pollos_hermanos/services/auth.dart';
import 'package:los_pollos_hermanos/shared/Styles.dart';
import 'package:provider/provider.dart';
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
    TableScreenWrapper(), // Table (Home)
    MenuScreen(),
    UpdatesScreen(),
    OrderHistoryScreen(),
  ];

  final List<String> _titles = [
    'Table',
    'Menu',
    'Updates',
    'Orders',
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
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  try {
                    await AuthService().signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const Wrapper()),
                      (route) =>
                          false, // This removes all previous routes from the stack
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Signed out successfully')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error signing out')),
                    );
                  }
                },
              ),
            ],
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
    final tableState = Provider.of<TableState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            _titles[_selectedIndex],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26.0,
            ),
          ),
        ),
        leading: tableState.isInTable
            ? null
            : IconButton(
                icon: Icon(Icons.arrow_back), // Back icon
                tooltip: 'Back to Choose Restaurant',
                onPressed: () {
                  // Navigate back to Choose Restaurant screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChooseRestaurantScreen()),
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
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: Container(
            color: Styles.inputFieldBorderColor,
            height: 1.0,
          ),
        ),
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
