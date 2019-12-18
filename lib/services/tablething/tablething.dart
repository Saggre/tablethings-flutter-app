import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/services/tablething/user.dart';
import 'menu/menu.dart';
import 'order/product.dart';

/// Gets data from firebase
class Tablething {
  final String apiUrl = 'https://europe-west2-ruokamenu.cloudfunctions.net/api/v1/';

  /// Gets all establishments in db
  /// This function will be removed in the future
  Future<List<Establishment>> getEstablishments() async {
    List<Establishment> establishments;

    try {
      http.Response response = await http.post(apiUrl + 'establishment/get_establishments', headers: {'Content-Type': 'application/x-www-form-urlencoded'}, body: {});
      print(response.body);

      if (response.statusCode == 200) {
        establishments = (json.decode(response.body) as List<dynamic>).map((element) {
          return Establishment.fromJson(element);
        }).toList();
      } else {
        throw Exception('Failed to get establishments');
      }
    } catch (err) {
      throw Exception(err.toString());
    }

    return establishments;
  }

  /// Get an establishment and its menu by id
  Future<Establishment> getEstablishment(String establishmentId) async {
    Establishment establishment;

    try {
      http.Response response = await http.post(apiUrl + 'establishment/get_establishment', headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }, body: {
        'establishment_id': establishmentId,
      });

      if (response.statusCode == 200) {
        establishment = Establishment.fromJson(json.decode(response.body));
        print(response.body);
      } else {
        throw Exception('Failed to get establishment');
      }
    } catch (err) {
      throw Exception(err.toString());
    }

    return establishment;
  }

  /// Gets user by id
  Future<User> getUser(String userId) async {
    User user;

    try {
      http.Response response = await http.post(apiUrl + 'user/get_user', headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }, body: {
        'user_id': userId,
      });

      if (response.statusCode == 200) {
        user = User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get user');
      }
    } catch (err) {
      throw Exception(err.toString());
    }

    return user;
  }
}
