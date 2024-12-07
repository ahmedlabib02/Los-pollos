import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/shared/CustomChip.dart';
import 'package:los_pollos_hermanos/shared/Styles.dart';
import 'package:los_pollos_hermanos/shared/TableRing.dart';

class TableScreen extends StatelessWidget {
  // Text controllers
  double pad = 24.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight +
            20), // Increase height to make the AppBar start lower
        child: Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: pad,
              right: pad), // Add top padding to push the AppBar lower
          child: AppBar(
            title: const Center(
              child: Text(
                'Table 4',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 26.0,
                ),
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10.0),
              child: Container(
                color: Styles.inputFieldBorderColor,
                height: 1.0,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: pad, right: pad, top: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              TableRing(
                  progressValue: 0.70, initials: ['A', 'B', 'C', 'D', 'E']),
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
