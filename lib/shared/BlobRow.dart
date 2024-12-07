import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/shared/Styles.dart';

Widget BlobRow(List<String> initials, double spacing, double radius) {
  // Limit the initials list to the first 3 items
  List<String> displayedInitials = initials.take(3).toList();

  // If there are more than 3 initials, calculate the extra count
  int extraCount = initials.length - 3;

  if (extraCount > 0) {
    displayedInitials.add('+3');
  }

  return Wrap(
    alignment: WrapAlignment.center,
    spacing: spacing,
    runSpacing: spacing,
    children: displayedInitials.map((initial) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0.0, 0.0),
              blurRadius: 4.0,
            ),
          ],
          border: Border.all(
              color: Styles
                  .inputFieldBorderColor, // Set your desired border color here
              width: 1.0), // Set your desired border width here
        ),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: const Color.fromARGB(255, 250, 250, 250),
          child: Text(
            initial[0] == '+' ? initial : initial[0],
            style: TextStyle(color: Colors.black, fontSize: radius),
          ),
        ),
      );
    }).toList(),
  );
}
