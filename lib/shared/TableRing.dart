import 'dart:math';

import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/shared/CustomChip.dart';
import 'package:los_pollos_hermanos/shared/Styles.dart';

class TableRing extends StatelessWidget {
  final double progressValue;
  final List<String> initials;
  final Color ringColor;

  TableRing({
    required this.progressValue,
    required this.initials,
    this.ringColor = const Color(0xFFF2C230),
  });

  final double avatarRadius = 30;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Circular progress indicator
                SizedBox(
                  width: 260,
                  height: 260,
                  child: CircularProgressIndicator(
                    value: progressValue,
                    strokeWidth: 4,
                    color: ringColor,
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),

                // Blobs inside the ring
                _buildBlobRows(initials),
              ],
            ),
          ),
        ),
        Positioned(
          top: 7,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1.5),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(24.0),
                border: Border.all(
                  color: Styles.inputFieldBorderColor,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0.0, 0.0),
                    blurRadius: 4.0,
                  ),
                ]),
            child: Text(
              'BFR193',
              style: const TextStyle(
                  fontSize: 14.0,
                  color: Color.fromARGB(255, 80, 80, 80),
                  fontWeight: FontWeight.w100),
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildBlobRows(List<String> initials) {
    List<String> displayedInitials =
        initials.length > 5 ? initials.sublist(0, 5) : initials;

    List<String> topRow = displayedInitials.take(3).toList();
    List<String> bottomRow = displayedInitials.skip(3).toList();

    if (initials.length > 5) {
      bottomRow.add("+${initials.length - 5}");
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 3 * 2 * avatarRadius),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: -15,
        runSpacing: -15,
        children: [
          buildBlobRow(topRow, avatarRadius),
          buildBlobRow(bottomRow, avatarRadius),
        ],
      ),
    );
  }
}

Widget buildBlobRow(List<String> initials, double avatarRadius) {
  return Wrap(
    alignment: WrapAlignment.center,
    spacing: -10,
    runSpacing: -10,
    children: initials.map((initial) {
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
          radius: avatarRadius,
          backgroundColor: const Color.fromARGB(255, 250, 250, 250),
          child: Text(
            initial[0],
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );
    }).toList(),
  );
}
