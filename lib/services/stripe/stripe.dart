import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tablething/services/stripe/payment_method.dart';

/// Custom Stripe API
class Stripe {
  final String apiUrl = 'https://europe-west2-ruokamenu.cloudfunctions.net/api/v1/';

  /// Adds a payment method for a Stripe customer id
  /// Returns true on success
  Future<bool> addPaymentMethod(String customerId, String number, int expMonth, int expYear, String cvv) async {
    try {
      http.Response response = await http.post(apiUrl + 'payment/add_payment_method', headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }, body: {
        'customer_id': customerId,
        'number': number,
        'exp_month': expMonth,
        'exp_year': expYear,
        'cvv': cvv,
      });
    } catch (err) {
      throw Exception('Failed to add payment method. ' + err.toString());
    }
//TODO all
    return true;
  }

  /// Gets payment methods attached to a stripe customer id
  /// Returns a list of payment method objects
  Future<List<PaymentMethod>> getPaymentMethods(String customerId, String type) async {
    List<PaymentMethod> paymentMethods;

    try {
      http.Response response = await http.post(apiUrl + 'payment/get_payment_methods', headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }, body: {
        'customer_id': customerId,
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
      print(err.toString());
      throw Exception(err.toString());
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
