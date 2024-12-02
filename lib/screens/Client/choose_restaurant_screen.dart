import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/restaurant_model.dart';
import 'package:los_pollos_hermanos/services/client_services.dart';
import 'main_page.dart';

class ChooseRestaurantScreen extends StatefulWidget {
  @override
  _ChooseRestaurantScreenState createState() => _ChooseRestaurantScreenState();
}

class _ChooseRestaurantScreenState extends State<ChooseRestaurantScreen> {
  final ClientService _clientService = ClientService();

  Map<String, List<Restaurant>> categorizedRestaurants = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  Future<void> _fetchRestaurants() async {
    try {
      Map<String, List<Restaurant>> fetchedData =
          await _clientService.getRestaurantsAndCategories();
      setState(() {
        categorizedRestaurants = fetchedData;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching restaurants: $e')),
      );
    }
  }

  // Capitalizes the first letter of a string
  String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
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
                ...categorizedRestaurants.keys.map((category) {
                  return _buildCategory(
                      category, categorizedRestaurants[category]!);
                }).toList(),
              ],
            ),
    );
  }

  Widget _buildCategory(String category, List<Restaurant> restaurants) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            capitalize(category), // Capitalize the category name
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 16.0, // Horizontal space between items
            runSpacing: 16.0, // Vertical space between rows
            children: restaurants.map((restaurant) {
              return GestureDetector(
                onTap: () {
                  // Navigate to the main page for the selected restaurant
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                },
                child: Column(
                  children: [
                    // Grey Rectangle
                    Container(
                      width: 80,
                      height: 90,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                            255, 235, 234, 234), // Grey background
                        borderRadius:
                            BorderRadius.circular(5), // Rounded corners
                      ),
                      child: Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, // Circle shape
                            image: restaurant.imageUrl !=
                                    null // Check if imageUrl is not null
                                ? DecorationImage(
                                    image: NetworkImage(restaurant.imageUrl!),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                  )
                                : null, // No image if imageUrl is null
                            color: restaurant.imageUrl == null
                                ? Colors.grey[400]
                                : null, // Placeholder color for no image
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      restaurant.name,
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
