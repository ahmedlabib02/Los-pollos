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
  final TextEditingController _searchController = TextEditingController();

  Map<String, List<Restaurant>> allRestaurants = {}; // Original data
  Map<String, List<Restaurant>> filteredRestaurants = {}; // Filtered data
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();

    // Listen to search input
    _searchController.addListener(_filterRestaurants);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchRestaurants() async {
    try {
      Map<String, List<Restaurant>> fetchedData =
          await _clientService.getRestaurantsAndCategories();
      setState(() {
        allRestaurants = fetchedData; // Store original data
        filteredRestaurants = fetchedData; // Initially, show all data
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching restaurants: $e')),
      );
    }
  }

  void _filterRestaurants() {
    String query = _searchController.text.toLowerCase();

    if (query.isEmpty) {
      // If query is empty, show all restaurants
      setState(() {
        filteredRestaurants = Map.from(allRestaurants);
      });
    } else {
      // Filter restaurants based on the search query
      Map<String, List<Restaurant>> tempFiltered = {};
      allRestaurants.forEach((category, restaurants) {
        final filteredList = restaurants
            .where((restaurant) =>
                restaurant.name.toLowerCase().contains(query) ||
                category.toLowerCase().contains(query))
            .toList();
        if (filteredList.isNotEmpty) {
          tempFiltered[category] = filteredList;
        }
      });

      setState(() {
        filteredRestaurants = tempFiltered;
      });
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
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromRGBO(242, 194, 48, 1),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 16.0,
                    right: 16.0,
                    bottom: 8.0,
                  ),
                  child: TextField(
                    controller: _searchController, // Attach the controller
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Search for restaurants by name or cuisine',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10.0),
                    ),
                  ),
                ),
                ...filteredRestaurants.keys.map((category) {
                  return _buildCategory(
                      category, filteredRestaurants[category]!);
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
            capitalize(category),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 90,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 235, 234, 234),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: restaurant.imageUrl != null
                                    ? DecorationImage(
                                        image:
                                            NetworkImage(restaurant.imageUrl!),
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                        onError: (exception, stackTrace) {
                                          print(
                                              'Error loading image: $exception');
                                        },
                                      )
                                    : null,
                                color: restaurant.imageUrl == null
                                    ? Colors.grey[400]
                                    : null,
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
