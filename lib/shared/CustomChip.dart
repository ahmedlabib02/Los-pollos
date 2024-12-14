import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/shared/Styles.dart';

Widget CustomChip(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1.5),
    decoration: BoxDecoration(
      color: Styles.inputFieldBgColor,
      borderRadius: BorderRadius.circular(24.0),
      border: Border.all(
        color: Styles.inputFieldBorderColor,
        width: 0.0,
      ),
    ),
    child: Text(
      text,
      style: const TextStyle(
          fontSize: 12.0,
          color: Color.fromARGB(255, 80, 80, 80),
          fontWeight: FontWeight.w100),
    ),
  );
}
