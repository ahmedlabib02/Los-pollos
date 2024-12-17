import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/shared/Styles.dart';
import 'package:los_pollos_hermanos/widgets/payment_button.dart';
import 'package:los_pollos_hermanos/widgets/bill_card_widget.dart';

class BillSummaryScreen extends StatefulWidget {
  const BillSummaryScreen({super.key});

  @override
  _BillSummaryScreenState createState() => _BillSummaryScreenState();
}

class _BillSummaryScreenState extends State<BillSummaryScreen> {
  final double taxRate = 0.14;
  bool isPaymentInProgress = false;
  List<Map<String, dynamic>> bills = [
    {
      'id': '1',
      'name': 'Emily',
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/los-pollos-a9354.firebasestorage.app/o/profile_images%2Fdec02e79-50f7-4050-a563-5666c1017ce8.jpg?alt=media&token=c222f82e-1379-4689-9f28-84c531ac954a",
      'amount': 420.0,
      'orderItems': [
        {'itemCount': 1, 'itemName': 'Caesar Salad'},
        {'itemCount': 1, 'itemName': 'Chicken Alfredo Pasta'},
        {'itemCount': 1, 'itemName': 'Buffalo Wings'},
        {'itemCount': 1, 'itemName': 'Nando’s Truffle Fries'},
      ],
      'isCurrentUser': true, // Flag to highlight the current user's bill
      'isPaid': false, // Example of an unpaid bill, set this as true if paid
    },
    {
      'id': '2',
      'name': 'Jackson',
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/los-pollos-a9354.firebasestorage.app/o/profile_images%2F9eada6aa-7af5-4329-9da5-b5b99944c32b.jpg?alt=media&token=127596d0-cef3-4a5b-a659-928d0a551e29",

      'amount': 500.0,
      'orderItems': [
        {'itemCount': 1, 'itemName': 'Buffalo Wings'}
      ],
      'isPaid': true, // Example of a paid bill
    },
    {
      'id': '3',
      'name': 'David',
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/los-pollos-a9354.firebasestorage.app/o/profile_images%2F9eada6aa-7af5-4329-9da5-b5b99944c32b.jpg?alt=media&token=127596d0-cef3-4a5b-a659-928d0a551e29",
      'amount': 610.0,
      'orderItems': [
        {'itemCount': 1, 'itemName': 'Creamy Shrimp Pasta'}
      ],
      'isPaid': false,
    },
    {
      'id': '4',
      'name': 'Leslie',
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/los-pollos-a9354.firebasestorage.app/o/profile_images%2F9eada6aa-7af5-4329-9da5-b5b99944c32b.jpg?alt=media&token=127596d0-cef3-4a5b-a659-928d0a551e29",
      'amount': 250.0,
      'orderItems': [
        {'itemCount': 1, 'itemName': 'Nando’s Truffle Fries'}
      ],
      'isPaid': false,
    },
    {
      'id': '5',
      'name': 'John',
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/los-pollos-a9354.firebasestorage.app/o/profile_images%2F9eada6aa-7af5-4329-9da5-b5b99944c32b.jpg?alt=media&token=127596d0-cef3-4a5b-a659-928d0a551e29",
      'amount': 300.0,
      'orderItems': [
        {'itemCount': 1, 'itemName': 'Caesar Salad'},
        {'itemCount': 1, 'itemName': 'Buffalo Wings'},
        {'itemCount': 1, 'itemName': 'Nando’s Truffle Fries'},
        {'itemCount': 1, 'itemName': 'Chicken Alfredo Pasta'},
      ],
      'isPaid': false,
    },
    {
      'id': '6',
      'name': 'Sarah',
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/los-pollos-a9354.firebasestorage.app/o/profile_images%2F9eada6aa-7af5-4329-9da5-b5b99944c32b.jpg?alt=media&token=127596d0-cef3-4a5b-a659-928d0a551e29",
      'amount': 400.0,
      'orderItems': [
        {'itemCount': 1, 'itemName': 'Chicken Alfredo Pasta'}
      ],
      'isPaid': false,
    },
  ];

  Future<List<Map<String, dynamic>>> fetchBills() async {
    await Future.delayed(
        const Duration(seconds: 2)); // Simulate a network request
    return bills;
  }

  Future<void> updateBillStatusInDatabase(String billId) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate DB update
    setState(() {
      bills = bills.map((bill) {
        if (bill['id'] == billId) {
          bill['isPaid'] = true; // Mark the bill as paid
        }
        return bill;
      }).toList();
    });
  }

  void _handleSuccesfulPayment(String billId) async {
    setState(() {
      isPaymentInProgress =
          true; // Show loading while payment is being processed
    });
    await updateBillStatusInDatabase(billId); // Update bill in DB
    setState(() {
      fetchBills(); // Trigger a reload of the bills list after payment
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bill Summary',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26.0,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back icon
          tooltip: 'Back',
          onPressed: () {
            Navigator.pop(context); // Navigate back to the Account Screen
          },
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
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchBills(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading bills'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bills available'));
          } else {
            List<Map<String, dynamic>> bills = snapshot.data!;
            double subtotal = bills[0]['amount'];
            double tax = subtotal * taxRate;
            double total = subtotal + tax;
            bool isPaid = bills[0]['isPaid'];

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: bills.length,
                    itemBuilder: (context, index) {
                      return BillCardWidget(bill: bills[index]);
                    },
                  ),
                ),
                // Summary Details
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${bills[0]['name']}'s Summary",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                              color: Colors.black,
                            ),
                          ),
                          if (isPaid)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green[500],
                              ),
                              child: const Text(
                                'Paid',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Subtotal",
                              style: TextStyle(fontSize: 16)),
                          Text("${subtotal.toStringAsFixed(2)} EGP"),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Tax", style: TextStyle(fontSize: 16)),
                          Text("${tax.toStringAsFixed(2)} EGP"),
                        ],
                      ),
                      const Divider(thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          Text("${total.toStringAsFixed(2)} EGP",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                PaymentButton(
                  amount: total,
                  isPaid: isPaid,
                  billId: "1",
                  onPaymentSuccess: (billId) {
                    _handleSuccesfulPayment(billId);
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
