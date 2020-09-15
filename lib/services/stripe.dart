import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tablething/models/stripe/payment_method.dart';

/// Custom Stripe API
class Stripe {
  final String baseUrl = 'https://europe-west2-ruokamenu.cloudfunctions.net/api/v1';

  /// Adds a payment method for a Stripe customer id
  Future<PaymentMethod> addPaymentMethod(String customerId, String number, int expMonth, int expYear, String cvv) async {
    try {
      http.Response response = await http.post(baseUrl + '/payment/add_payment_method', headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }, body: {
        'customer_id': customerId,
        'number': number,
        'exp_month': expMonth.toString(),
        'exp_year': expYear.toString(),
        'cvv': cvv,
      });

      if (response.statusCode == 200) {
        return PaymentMethod.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add payment method');
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  /// Gets payment methods attached to a stripe customer id
  /// Returns a list of payment method objects
  Future<List<PaymentMethod>> getPaymentMethods(String customerId, String type) async {
    try {
      http.Response response = await http.post(baseUrl + '/payment/get_payment_methods', headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }, body: {
        'customer_id': customerId,
        'type': type,
      });

      if (response.statusCode == 200) {
        return (json.decode(response.body)["data"] as List).map((paymentMethod) {
          return PaymentMethod.fromJson(paymentMethod);
        }).toList();
      } else {
        throw Exception('Failed to get payment methods');
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  /// Gets a single payment method by id
  Future<PaymentMethod> getPaymentMethod(String paymentMethodId) async {
    PaymentMethod paymentMethod;

    try {
      http.Response response = await http.post(baseUrl + '/payment/get_payment_method', headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }, body: {
        'payment_method_id': paymentMethodId,
      });

      if (response.statusCode == 200) {
        return PaymentMethod.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get payment method');
      }
    } catch (err) {
      throw Exception('Failed to get payment method. ' + err.toString());
    }
  }
}
