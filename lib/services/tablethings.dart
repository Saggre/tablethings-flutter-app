import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tablething/models/tablethings/restaurant/restaurant.dart';
import 'package:tablething/models/tablethings/user.dart';

/// Handles data used by the app
class Tablethings {
  final String baseUrl = 'http://localhost:8080';

  /// Gets all establishments in db
  /// This function will be removed in the future? ;D
  Future<List<Restaurant>> getRestaurants() async {
    List<Restaurant> restaurants;

    try {
      http.Response response =
          await http.post(baseUrl + '/establishment/get_establishments', headers: {'Content-Type': 'application/x-www-form-urlencoded'}, body: {});
      print(response.body);

      if (response.statusCode == 200) {
        restaurants = (json.decode(response.body) as List<dynamic>).map((element) {
          return Restaurant.fromJson(element);
        }).toList();
      } else {
        throw Exception('Failed to get establishments');
      }
    } catch (err) {
      throw Exception(err.toString());
    }

    return restaurants;
  }

  /// Gets an establishment with id
  Future<Restaurant> getRestaurant(String id) async {
    try {
      http.Response response = await http.post(baseUrl + '/establishment/get_establishment', headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }, body: {
        'id': id,
      });

      if (response.statusCode == 200) {
        return Restaurant.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get restaurant');
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  /// Gets an user with id
  Future<User> getUser(String id) async {
    try {
      http.Response response = await http.post(baseUrl + '/user/get_user', headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }, body: {
        'id': id,
      });

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get user');
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
