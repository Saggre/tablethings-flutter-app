import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tablething/services/stripe/payment_method.dart';

/// Custom Stripe API
class Stripe {
  final String apiUrl = 'https://us-central1-ruokamenu.cloudfunctions.net/api/v1/';

  /// Adds a payment method for a Stripe customer id
  /// Returns true on success
  Future<bool> addPaymentMethod(String customer, PaymentMethod paymentMethod) async {
    try {
      http.Response response = await http.post(apiUrl + 'payment/add_payment_method', headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }, body: {
        'customer': customer,
        'payment_method': paymentMethod.toJson(),
      });
    } catch (err) {
      throw Exception('Failed to add payment method. ' + err.toString());
    }

    return true;
  }

  /// Gets payment methods attached to a stripe customer id
  /// Returns a list of payment method objects
  Future<List<PaymentMethod>> getPaymentMethods(String customer, String type) async {
    List<PaymentMethod> paymentMethods;

    try {
      http.Response response = await http.post(apiUrl + 'payment/get_payment_methods', headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }, body: {
        'customer': customer,
        'type': type,
      });

      if (response.statusCode == 200) {
        paymentMethods = (json.decode(response.body)["data"] as List).map((paymentMethod) {
          return PaymentMethod.fromJson(paymentMethod);
        }).toList();
      } else {
        throw Exception('Failed to get payment methods');
      }
    } catch (err) {
      throw Exception('Failed to get payment methods. ' + err.toString());
    }

    return paymentMethods;
  }

  /// Gets a single payment method by id
  Future<PaymentMethod> getPaymentMethod(String paymentMethodId) async {
    PaymentMethod paymentMethod;

    try {
      http.Response response = await http.post(apiUrl + 'payment/get_payment_method', headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }, body: {
        'payment_method_id': paymentMethodId,
      });

      if (response.statusCode == 200) {
        paymentMethod = PaymentMethod.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get payment method');
      }
    } catch (err) {
      throw Exception('Failed to get payment method. ' + err.toString());
    }

    return paymentMethod;
  }
}
