import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/models/restaurant_model.dart';
import 'package:los_pollos_hermanos/screens/Client/change_password.dart';
import 'package:los_pollos_hermanos/services/manager_services.dart';
import 'package:provider/provider.dart';
import 'package:los_pollos_hermanos/models/customUser.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late Future<Restaurant?> _restaurantData;

  Future<void> _fetchRestaurantData(CustomUser user) async {
    try {
      _restaurantData = ManagerServices().getRestaurant(user.uid);
      setState(() {});
    } catch (e) {
      print('Error fetching restaurant data: $e');
    }
  }

  void _showChangeRestaurantNameDialog(Restaurant restaurant) {
    final TextEditingController _nameController =
        TextEditingController(text: restaurant.name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Change Restaurant Name"),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: "Enter new name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty) {
                  restaurant.name = _nameController.text;
                  await ManagerServices().updateRestaurant(restaurant);
                  Navigator.pop(context);
                  setState(() {});
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<CustomUser?>(context);
    if (user != null) {
      _fetchRestaurantData(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Restaurant?>(
        future: _restaurantData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No restaurant data found.'));
          }

          final restaurant = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Aligning to the center
              children: [
                // Display restaurant image at the top
                CircleAvatar(
                  radius: 50, // Adjust size as needed
                  backgroundColor: Colors.grey[300],
                  backgroundImage: restaurant.imageUrl != null
                      ? NetworkImage(restaurant.imageUrl!)
                      : const AssetImage('assets/images/default_image.png') as ImageProvider,
                ),
                const SizedBox(height: 20), // Space between image and other items

                // Restaurant Name
                ListTile(
                  leading: const Icon(Icons.restaurant),
                  title: const Text("Change Restaurant Name"),
                  subtitle: Text(restaurant.name),
                  trailing: const Icon(Icons.edit),
                  onTap: () => _showChangeRestaurantNameDialog(restaurant),
                ),
                const Divider(),
                // Change Password
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text("Change Password"),
                  onTap: () {
                    showChangePasswordSheet(context);
                  },
                ),
                const Divider(),
              ],
            ),
          );
        });
  }
}