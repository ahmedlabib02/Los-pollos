import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/services/client_services.dart';
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

  Future<List<Map<String, dynamic>>> fetchBills() async {
    return await ClientService()
        .getBillSummary(FirebaseAuth.instance.currentUser!.uid);
  }

  Future<void> updateBillStatusInDatabase(String billId) async {
    await ClientService().updateBillStatus(billId);
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
        title: const Text(
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
                  billId: bills[0]['id'],
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
