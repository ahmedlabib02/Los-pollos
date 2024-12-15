import 'package:flutter/material.dart';

class SelectedRestaurantProvider with ChangeNotifier {
  String? _selectedRestaurantId;

  String? get selectedRestaurantId => _selectedRestaurantId;

  void setRestaurantId(String? restaurantId) {
    _selectedRestaurantId = restaurantId;
    notifyListeners(); // Notify listeners of the change
  }
}
