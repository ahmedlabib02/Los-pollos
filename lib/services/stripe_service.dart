import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment(double amountInEGP) async {
    try {
      // Create the Payment Intent
      String? paymentIntentClientSecret =
          await createPaymentIntent(amountInEGP, 'egp');

      if (paymentIntentClientSecret == null) {
        throw Exception('Failed to create payment intent.');
      }

      // Configure the Payment Sheet with minimal billing details collection
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: 'Los Pollos Hermanos',
          billingDetailsCollectionConfiguration:
              const BillingDetailsCollectionConfiguration(
            name: CollectionMode.never,
            email: CollectionMode.automatic,
            phone: CollectionMode.never,
            address: AddressCollectionMode.never,
          ),
        ),
      );

      await _processPayment();
    } catch (e) {
      throw Exception('Payment failed: $e');
    }
  }

  Future<String?> createPaymentIntent(
      double amountInEGP, String currency) async {
    try {
      const url = 'https://api.stripe.com/v1/payment_intents';
      final amountInSmallestUnit = (amountInEGP * 100).toInt().toString();

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': amountInSmallestUnit,
          'currency': currency,
          'payment_method_types[]': 'card',
        },
      );

      if (response.statusCode == 200) {
        final paymentIntent = jsonDecode(response.body);
        return paymentIntent['client_secret'];
      } else {
        throw Exception('Failed to create Payment Intent: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating Payment Intent: $e');
    }
  }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      throw Exception('Error processing payment: $e');
    }
  }
}
