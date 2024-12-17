import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/customUser.dart';
import 'package:los_pollos_hermanos/provider/table_state_provider.dart';
import 'package:los_pollos_hermanos/screens/Client/menu_screen.dart';
import 'package:los_pollos_hermanos/screens/Client/notification_screen.dart';
import 'package:los_pollos_hermanos/screens/chat/chat_overlay.dart';
// import 'package:los_pollos_hermanos/screens/Client/../../shared/TableRing_wrapper.dart';
import 'package:los_pollos_hermanos/screens/wrapper.dart';
import 'package:los_pollos_hermanos/screens/Client/table_screen_wrapper.dart'; // Import TableScreenWrapper
import 'package:los_pollos_hermanos/services/auth.dart';
import 'package:los_pollos_hermanos/services/client_services.dart';
import 'package:los_pollos_hermanos/services/notification_services.dart';
import 'package:los_pollos_hermanos/shared/Styles.dart';
import 'package:provider/provider.dart';
import 'choose_restaurant_screen.dart'; // Import Choose Restaurant screen
import 'account_screen.dart'; // Import Account screen

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.init(context);
  }

  // Screens for each tab
  final List<Widget> _screens = [
    TableScreenWrapper(), // Table (Home)
    MenuScreen(role: 'user'),
    NotificationsScreen(),
    AccountScreen(),
  ];

  final List<String> _titles = [
    'Table',
    'Menu',
    'Updates',
    'Account',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tableState = Provider.of<TableState>(context);
    return Scaffold(
      appBar: _selectedIndex == 2
          ? null // Hide AppBar on Notifications Screen
          : AppBar(
              title: Text(
                _titles[_selectedIndex],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26.0,
                ),
              ),
              // Conditional logic for the 'leading' icon
              leading: (_selectedIndex == 0)
                  ? (tableState.isInTable
                      ? IconButton(
                          icon: const Icon(Icons.keyboard_return,
                              color: Colors.redAccent, size: 30),
                          tooltip: 'Exit Table',
                          onPressed: () async {
                            tableState.leaveTable();
                            // call the server to leave the table
                            try {
                              final user = Provider.of<CustomUser?>(context,
                                  listen: false);
                              await ClientService().leaveTable(user!.uid);
                              tableState.leaveTable();
                              setState(() {
                                _selectedIndex = 0;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Exited the table Successfully')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          },
                        )
                      : IconButton(
                          icon: const Icon(Icons.arrow_back),
                          tooltip: 'Back to Choose Restaurant',
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChooseRestaurantScreen()), // Navigate back
                            );
                          },
                        ))
                  : null, // Null for other pages
              // Logout button only on Account page
              actions: [
                if (_selectedIndex == 3) // Show logout on Account Page
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () async {
                      try {
                        await AuthService().signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const Wrapper()),
                          (route) => false, // Clears the navigation stack
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Signed out successfully')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error signing out')),
                        );
                      }
                    },
                  ),
              ],
              backgroundColor: Colors.white, // Change color for Table Screen
              scrolledUnderElevation: 0,
              elevation: 0,
              // remove border or bottom border
              iconTheme: const IconThemeData(color: Colors.black),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(10.0),
                child: Container(
                  color: Styles.inputFieldBorderColor,
                  height: 1.0,
                ),
              ),
              centerTitle: true,
            ),
      body: _screens[_selectedIndex],
      floatingActionButton: tableState.isInTable
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context, builder: (context) => ChatOverlay());
              },
              child: Icon(Icons.auto_awesome),
              backgroundColor: Color.fromRGBO(239, 180, 7, 1),
            )
          : null,
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
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Updates',
            ),
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
