import 'package:flutter/material.dart';
import 'package:los_pollos_hermanos/services/stripe_service.dart';

// ignore: must_be_immutable
class PaymentButton extends StatefulWidget {
  final double amount;
  final bool isPaid;
  bool isPaymentInProgress = false;
  final Function(String) onPaymentSuccess;
  PaymentButton({
    super.key,
    required this.amount,
    required this.isPaid,
    required this.onPaymentSuccess,
  });

  @override
  _PaymentButtonState createState() => _PaymentButtonState();
}

class _PaymentButtonState extends State<PaymentButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: widget.isPaid || widget.isPaymentInProgress
            ? null
            : () async {
                widget.isPaymentInProgress = true;
                setState(() {
                  widget.isPaymentInProgress = true;
                });
                try {
                  await StripeService.instance
                      .makePayment(widget.amount); // Amount can be dynamic

                  widget.onPaymentSuccess('1');
                } catch (error) {
                  // In case of failure, notify the user through other means
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Payment failed. Please try again.')),
                  );
                } finally {
                  setState(() {
                    widget.isPaymentInProgress = false;
                  });
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow[700],
          minimumSize: const Size(double.infinity, 50.0),
          maximumSize: const Size(double.infinity, 50.0),
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: widget.isPaymentInProgress
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              )
            : Text(
                widget.isPaid ? 'Paid' : 'Pay With Credit Card',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
      ),
    );
  }
}
