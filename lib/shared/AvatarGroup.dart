import 'dart:math';

import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/shared/Styles.dart';

class AvatarGroup extends StatelessWidget {
  List<Map<String, dynamic>> content;
  double spacing;
  double radius;
  int cutoff;
  double overflowFontSizeMultiplier;

  AvatarGroup(
      {super.key,
      required this.content,
      required this.spacing,
      required this.radius,
      required this.cutoff,
      this.overflowFontSizeMultiplier = 1});

  @override
  Widget build(BuildContext context) {
    // If there are more than 3 initials, calculate the extra count
    List<Map<String, dynamic>> toBeDisplayed = content.take(cutoff).toList();

    int extraCount = content.length - cutoff;

    if (extraCount > 0) {
      toBeDisplayed.add({
        'name': '+$extraCount',
      } as Map<String, dynamic>);
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: spacing,
      runSpacing: spacing,
      children: toBeDisplayed.map((element) {
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
          child: element.containsKey('imageUrl')
              ? CircleAvatar(
                  radius: radius,
                  backgroundColor: const Color.fromARGB(255, 250, 250, 250),
                  backgroundImage: NetworkImage(element['imageUrl']),
                )
              : CircleAvatar(
                  radius: radius,
                  backgroundColor: const Color.fromARGB(255, 250, 250, 250),
                  child: Text(
                    element['name'][0] == '+'
                        ? element['name']
                        : element['name'][0],
                    style: TextStyle(
                        color: const Color.fromARGB(255, 70, 70, 70),
                        fontSize: radius * overflowFontSizeMultiplier),
                  ),
                ),
        );
      }).toList(),
    );
  }
}
