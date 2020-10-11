import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:tablethings/models/tablethings/restaurant/menu/menu.dart';
import 'package:tablethings/models/tablethings/restaurant/restaurant.dart';
import 'package:tablethings/models/tablethings/user.dart';

/// Handles data used by the app
class Tablethings {
  static final String baseUrl = 'http://192.168.0.2:8080';
  static String _token = '';

  /// Sets the token used to authenticate requests
  static void setToken(String token) {
    _token = token;
  }

  /// Get errors from result
  static List<String> getErrors(dynamic result) {
    if (!result.containsKey('errors')) {
      return ['No response'];
    }

    if (result['errors'].length > 0) {
      return result['errors'];
    }

    return [];
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

      if (response.statusCode == 200) {
        var result = json.decode(response.body);

        var errors = getErrors(result);

        if (errors.length > 0) {
          errors.forEach((error) {
            log(error);
          });

          throw Exception(errors[0]);
        }

        return result;
      } else {
        throw Exception('Failed to make request. Code ' + response.statusCode.toString());
      }
    } catch (ex) {
      throw Exception(ex);
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
    } catch (ex) {
      throw Exception(ex);
    }
  }

  /// Gets a menu with menuId
  static Future<Menu> getMenu(String id) async {
    try {
      var result = await makeRequest('/restaurant/menu', {
        'id': id,
      });

      return Menu.fromJson(result['menu']);
    } catch (ex) {
      throw Exception(ex);
    }
  }

  /// Gets a restaurant with restaurantId
  static Future<Restaurant> getRestaurant(String id) async {
    try {
      var result = await makeRequest('/restaurant/info', {
        'id': id,
      });

      return Restaurant.fromJson(result['restaurant']);
    } catch (ex) {
      throw Exception(ex);
    }
  }

  /// Gets an user with id
  static Future<User> getUser(String id) async {}

  /// Authenticate with email
  static Future<Map<String, dynamic>> authEmail(String email, String password) async {

  }

  /// Create a user
  static Future<Map<String, dynamic>> createUser(String email, String password) async {

  }

  /// Gets a token for guest user
  static Future<Map<String, dynamic>> authGuest() async {
    try {
      var result = await makeRequest('/auth/guest', {});

      return {
        'token': result['token'],
        'user': User.fromJson(result['user']),
      };
    } catch (ex) {
      throw Exception(ex);
    }
  }
}
