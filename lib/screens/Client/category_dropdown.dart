import 'package:flutter/material.dart';

class GreyDropdown extends StatefulWidget {
  final List<String> items;
  final String label;
  String? selectedValue;
  GreyDropdown(
      {super.key,
      required this.items,
      required this.label,
      required this.selectedValue});

  @override
  _GreyDropdownState createState() => _GreyDropdownState();
}

class _GreyDropdownState extends State<GreyDropdown> {
  // String? _selectedValue; // Initializing with null

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: widget.label, // Label stays in place
        labelStyle:
            TextStyle(color: Color.fromRGBO(50, 50, 50, 1), fontSize: 16),
        filled: true,
        fillColor: const Color.fromRGBO(244, 244, 244, 1), // Background color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
          borderSide: BorderSide(color: Colors.grey), // No border
        ),
      ),
      value:
          widget.selectedValue, // Keep value as null when no item is selected
      icon: const Icon(Icons.expand_more), // Custom dropdown icon
      elevation: 0,
      dropdownColor: const Color.fromRGBO(
          244, 244, 244, 1), // Background color of dropdown
      style: const TextStyle(
          fontFamily: 'Mada',
          fontSize: 16,
          color: Color.fromRGBO(50, 50, 50, 1)), // Custom font
      items: widget.items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          widget.selectedValue = value; // Update selected value
        });
      },
      menuMaxHeight: 300, // Optional: Set menu height
      borderRadius: BorderRadius.circular(4), // Rounded corners for dropdown
    );
  }
}
