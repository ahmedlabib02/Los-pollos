import 'dart:math';

import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/shared/AvatarGroup.dart';
import 'package:los_pollos_hermanos/shared/CustomChip.dart';
import 'package:los_pollos_hermanos/shared/Styles.dart';

class TableRing extends StatelessWidget {
  final double progressValue;
  final List<Map<String, dynamic>> members;
  final Color ringColor;

  TableRing({
    required this.progressValue,
    required this.members,
    this.ringColor = const Color(0xFFF2C230),
  });

  final double avatarRadius = 30;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Circular progress indicator
              SizedBox(
                width: 260,
                height: 260,
                child: CircularProgressIndicator(
                  value: progressValue,
                  strokeWidth: 4.5,
                  color: ringColor,
                  backgroundColor: Colors.grey.shade200,
                ),
              ),

              // Blobs inside the ring
              _buildAvatarGroups(members),
            ],
          ),
        ),
        // Code chip
        _buildCodeChip('BFR193')
      ],
    ));
  }

  Widget _buildAvatarGroups(List<Map<String, dynamic>> members) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 3 * 2 * avatarRadius),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: -15,
        runSpacing: -15,
        children: [
          AvatarGroup(
              content: members.take(3).toList(),
              spacing: -10,
              radius: avatarRadius,
              cutoff: 3),
          AvatarGroup(
              content: members.skip(3).toList(),
              spacing: -10,
              radius: avatarRadius,
              cutoff: 2,
              overflowFontSizeMultiplier: 0.75)
        ],
      ),
    );
  }

  Widget _buildCodeChip(String code) {
    return Positioned(
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
                offset: const Offset(0.0, 0.0),
                blurRadius: 4.0,
              ),
            ]),
        child: Text(
          code,
          style: const TextStyle(
              fontSize: 14.0,
              color: Color.fromARGB(255, 80, 80, 80),
              fontWeight: FontWeight.w100),
        ),
      ),
    );
  }
}
