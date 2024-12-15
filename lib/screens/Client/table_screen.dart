import 'package:flutter/material.dart';

import 'package:los_pollos_hermanos/shared/CustomChip.dart';
import 'package:los_pollos_hermanos/shared/Styles.dart';
import 'package:los_pollos_hermanos/shared/TableRing.dart';
import 'package:los_pollos_hermanos/shared/temp_vars.dart';

class TableScreen extends StatelessWidget {
  // Text controllers
  final double pad = 24.0;

  final String tableCode;
  TableScreen({required this.tableCode});

  static const List<Map<String, dynamic>> users = TempVars.users;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: pad, right: pad, top: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              TableRing(tableCode: tableCode, progressValue: 0.70, members: [
                users[0],
                users[1],
                users[6],
                users[4],
                users[2],
                users[7],
                users[5],
                users[3],
              ]),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Styles.inputFieldBorderColor,
                          width: 0.8,
                        ),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: CustomChip('80% paid'),
                  )),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        right: BorderSide(
                          color: Styles.inputFieldBorderColor,
                          width: 0.8,
                        ),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: CustomChip('1500 EGP due'),
                  )),
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                  maxHeight: 30, maxWidth: 80),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Handle "Track bill" button press
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF2C230),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical:
                                          0.0), // Adjust padding as needed
                                  elevation: 0,
                                  shadowColor: Colors.transparent,

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween, // Center the content
                                  crossAxisAlignment: CrossAxisAlignment.center,

                                  children: [
                                    Text(
                                      'Track bill',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    // Space between text and icon
                                    Icon(
                                      Icons.chevron_right, // Chevron icon
                                      color: Styles
                                          .inputFieldTextColor, // Color for the icon
                                      size: 16,
                                    ),
                                  ],
                                ),
                              )))),
                ],
              ),
              const SizedBox(height: 26),
              // ORDER SUMMARY SECTION BELOW
              const Text(
                'Order Summary',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Styles.inputFieldBgColor,
                  borderRadius: BorderRadius.circular(
                      4.0), // Adjust the radius for roundness
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Styles.inputFieldBgColor,
                  borderRadius: BorderRadius.circular(
                      4.0), // Adjust the radius for roundness
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Styles.inputFieldBgColor,
                  borderRadius: BorderRadius.circular(
                      4.0), // Adjust the radius for roundness
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Styles.inputFieldBgColor,
                  borderRadius: BorderRadius.circular(
                      4.0), // Adjust the radius for roundness
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
