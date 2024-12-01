import 'package:flutter/material.dart';
import 'main_page.dart';

class ChooseRestaurantScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick a Restaurant'),
        backgroundColor: Color.fromRGBO(242, 194, 48, 1),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for restaurants by name or cuisine',
                prefixIcon: Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) {
                // Add search functionality here
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildCategory('Italian', context),
                _buildCategory('Asian', context),
                _buildCategory('Mexican', context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(String category, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            category,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  // Navigate to the main page for the selected restaurant
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    child: Text(category[0]), // Placeholder for restaurant logo
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
