import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
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
      return ['Kutsua ei voitu suorittaa'];
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
          // TODO handle errors
        }

        return result;
      } else {
        throw Exception('Failed to make request');
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  /// Gets a restaurant with id
  static Future<Restaurant> getRestaurant(String id) async {
    var result = await makeRequest('/restaurant/info', {
      id: id,
    });

    return Restaurant.fromJson(result['restaurant']);
  }

  /// Gets an user with id
  static Future<Map<String, dynamic>> getUser(String id) async {}

  /// Gets a token for guest user
  static Future<Map<String, dynamic>> authGuest() async {
    var result = await makeRequest('/auth/guest', {});

    return {
      'token': result['token'],
      'user': User.fromJson(result['user']),
    };
  }
}
