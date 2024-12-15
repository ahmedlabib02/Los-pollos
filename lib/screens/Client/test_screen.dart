// lib/services/restaurant_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide Table;
import 'package:los_pollos_hermanos/models/bill_model.dart';
import 'package:los_pollos_hermanos/models/order_item_model.dart';
import 'package:los_pollos_hermanos/models/table_model.dart';
import 'package:los_pollos_hermanos/services/manager_services.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  ManagerServices _managerServices = ManagerServices();

  bool isLoading = true;

  Future<void> _fetchTables() async {
    try {
      List<Table> fetchedData =
          await _managerServices.getCurrentTables("zhvDif3Jb1TwyJlwetrO");
      print(fetchedData[0]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching restaurants: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pick a Restaurant',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Optional: Make the title bold
          ),
        ),
        backgroundColor: Color.fromRGBO(242, 194, 48, 1),
        centerTitle: true, // Centers the title
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0, // Add top margin
                    left: 16.0,
                    right: 16.0,
                    bottom: 8.0, // Maintain vertical padding for consistency
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true, // Enables the background color
                      fillColor: Colors.grey[200], // Light grey background
                      hintText: 'Search for restaurants by name or cuisine',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400, // Use lighter font weight
                        fontSize: 16, // Adjust font size as needed
                      ), // Style for the hint text
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Rounded corners
                        borderSide: BorderSide.none, // Removes border lines
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10.0),
                    ),
                    onChanged: (value) {
                      // Add search functionality here
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
