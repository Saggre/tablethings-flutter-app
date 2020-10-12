import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:stripedart/stripedart.dart';
import 'package:tablethings/models/tablethings/restaurant/menu/menu.dart';
import 'package:tablethings/models/tablethings/restaurant/restaurant.dart';
import 'package:tablethings/models/tablethings/tablethings_error.dart';
import 'package:tablethings/models/tablethings/user.dart';

import 'exceptions.dart';

/// Handles data used by the app
class Tablethings {
  static final String baseUrl = 'http://192.168.0.2:8080';
  static String _token = '';

  /// Sets the token used to authenticate requests
  static void setToken(String token) {
    _token = token;
  }

  /// Get errors from result
  static List<TablethingsError> getErrors(dynamic result) {
    if (!result.containsKey('errors')) {
      return [
        TablethingsError('No response'),
      ];
    }

    List<TablethingsError> errors = List<TablethingsError>.from(result['errors'].map((x) => TablethingsError.fromJson(x)));

    return errors;
  }

  /// Makes a http request and returns the result object
  static Future<Map<String, dynamic>> makeRequest(String endpoint, dynamic body) async {
    try {
      http.Response response = await http.post(
        baseUrl + endpoint,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer ' + _token,
          'User-Agent': 'Tablethings/1.0.0',
        },
        body: body,
      );

      var result = json.decode(response.body);
      var errors = getErrors(result);

      if (errors.length > 0) {
        throw TablethingsAPIException(response.statusCode, errors);
      }

      if (response.statusCode == 200) {
        return result;
      } else {
        throw TablethingsAPIException(response.statusCode, [
          TablethingsError('Request failed'),
        ]);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Gets restaurant and its active menu with restaurantIOd
  static Future<Map<String, dynamic>> getAll(String id) async {
    try {
      var result = await makeRequest('/restaurant/all', {
        'id': id,
      });

      return {
        'restaurant': Restaurant.fromJson(result['restaurant']),
        'menu': Menu.fromJson(result['menu']),
      };
    } catch (e) {
      rethrow;
    }
  }

  /// Gets a menu with menuId
  static Future<Menu> getMenu(String id) async {
    try {
      var result = await makeRequest('/restaurant/menu', {
        'id': id,
      });

      return Menu.fromJson(result['menu']);
    } catch (e) {
      rethrow;
    }
  }

  /// Gets a restaurant with restaurantId
  static Future<Restaurant> getRestaurant(String id) async {
    try {
      var result = await makeRequest('/restaurant/info', {
        'id': id,
      });

      return Restaurant.fromJson(result['restaurant']);
    } catch (e) {
      rethrow;
    }
  }

  /// Gets an user with id
  static Future<User> getUser(String id) async {}

  /// Authenticate with email
  static Future<Map<String, dynamic>> authEmail(String email, String password) async {
    try {
      var result = await makeRequest('/auth/login', {
        'email': email,
        'password': password,
      });

      return {
        'token': result['token'],
        'user': User.fromJson(result['user']),
      };
    } catch (e) {
      rethrow;
    }
  }

  /// Create a user
  static Future<Map<String, dynamic>> createUser(String email, String password) async {
    try {
      var result = await makeRequest('/auth/create', {
        'email': email,
        'password': password,
      });

      return {
        'token': result['token'],
        'user': User.fromJson(result['user']),
      };
    } catch (e) {
      rethrow;
    }
  }

  /// Gets a token for guest user
  static Future<Map<String, dynamic>> authGuest() async {
    try {
      var result = await makeRequest('/auth/guest', {});

      return {
        'token': result['token'],
        'user': User.fromJson(result['user']),
      };
    } catch (e) {
      rethrow;
    }
  }

  /// Get Stripe account details
  static Future<Account> getStripeAccount(String stripeAccountId) async {
    try {
      var result = await makeRequest('/payment/user', {
        'id': stripeAccountId,
      });

      return Account.fromJson(result['user']);
    } catch (e) {
      rethrow;
    }
  }
}
