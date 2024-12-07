import 'package:flutter/material.dart';

Widget PaymentProgressIndicator(double strokeWidth, double paidStatus) {
  return Center(
    child: Stack(
      alignment: Alignment.center,
      children: [
        if (paidStatus == 1)
          Icon(
            Icons.check,
            color: Color(0xFFF2C230),
          ),
        CircularProgressIndicator(
          value: paidStatus,
          strokeWidth: strokeWidth,
          color: Color(0xFFF2C230),
          backgroundColor: Colors.grey.shade200,
        ),
      ],
    ),
  );
}
