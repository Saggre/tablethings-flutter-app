import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tablething/services/stripe/payment_method.dart';

/// Custom Stripe API
class Stripe {
  final String apiUrl = 'https://us-central1-ruokamenu.cloudfunctions.net/api/v1/payment/';

  /// Adds a payment method for a Stripe customer id
  /// Returns true on success
  Future<bool> addPaymentMethod(String customer, PaymentMethod paymentMethod) async {
    try {
      http.Response response = await http.post(apiUrl + 'add_payment_method', headers: {
        'Content-Type': 'application/json'
      }, body: {
        "customer": customer,
        "payment_method": paymentMethod.toJson(),
      });
    } catch (err) {
      throw Exception('Failed to add payment method');
    }

    return true;
  }

  /// Gets payment methods attached to a stripe customer id
  /// Returns a list of payment method objects
  Future<List<PaymentMethod>> getPaymentMethods(String customer, String type) async {
    List<PaymentMethod> paymentMethods;

    try {
      http.Response response = await http.post(apiUrl + 'get_payment_methods', headers: {
        'Content-Type': 'application/json'
      }, body: {
        "customer": customer,
        "type": type,
      });

      if (response.statusCode == 200) {
        paymentMethods = (json.decode(response.body)["data"] as List).map((paymentMethod) {
          return PaymentMethod.fromJson(paymentMethod);
        }).toList();
      } else {
        throw Exception('Failed to get payment methods');
      }
    } catch (err) {
      throw Exception('Failed to get payment methods');
    }

    return paymentMethods;
  }
}
