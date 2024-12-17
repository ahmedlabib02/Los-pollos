import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/screens/Client/table_screen.dart';
import 'package:los_pollos_hermanos/shared/AvatarGroup.dart';
import 'package:los_pollos_hermanos/shared/PaymentProgressIndicator.dart';

Widget TableCard({
  required double screenWidth,
  required String tableName,
  required String startTime,
  required List<Map<String, dynamic>> members,
  required double paidPercentage,
  required String orderStatus,
  required String tableCode, // Add tableCode as a parameter
  required String role,
  required BuildContext context, // Pass BuildContext for navigation
}) {
  Map<String, Color> colorMap = {
    'No orders placed': const Color.fromARGB(255, 235, 235, 235),
    'Orders in progress': const Color(0xFFFFEBAE).withOpacity(0.5),
    'All orders served': const Color(0xFFF2C230),
  };

  return Container(
    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(screenWidth * 0.015),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1.0,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    tableName,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                  AvatarGroup(
                    content: members,
                    spacing: -screenWidth * 0.015,
                    radius: screenWidth * 0.025,
                    cutoff: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03, vertical: screenWidth * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: screenWidth * 0.04,
                        width: screenWidth * 0.04,
                        child: const FittedBox(
                          child: Icon(Icons.access_time, color: Colors.black),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.015),
                      Text(
                        startTime,
                        style: TextStyle(
                            color: Colors.black, fontSize: screenWidth * 0.035),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: screenWidth * 0.015),
              Row(
                children: [
                  Container(
                    height: screenWidth * 0.04,
                    width: screenWidth * 0.04,
                    child: const FittedBox(
                      child: Icon(Icons.people, color: Colors.black),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.015),
                  Text(
                    '${members.length} members',
                    style: TextStyle(
                        color: Colors.black, fontSize: screenWidth * 0.035),
                  ),
                ],
              ),
              SizedBox(height: screenWidth * 0.015),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.004),
                        height: screenWidth * 0.04,
                        width: screenWidth * 0.04,
                        child: FittedBox(
                          child: PaymentProgressIndicator(
                              screenWidth * 0.012, paidPercentage),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.015),
                      Text(
                        '${(paidPercentage * 100).round()}% paid',
                        style: TextStyle(
                            color: Colors.black, fontSize: screenWidth * 0.035),
                      ),
                    ],
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: screenWidth * 0.06,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to TableScreen with the tableCode
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TableScreen(
                              tableCode: tableCode,
                              role: role,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.015),
                        ),
                      ),
                      child: Text(
                        'View',
                        style: TextStyle(
                            fontSize: screenWidth * 0.035, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    ),
  );
}
