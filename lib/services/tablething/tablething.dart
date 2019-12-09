import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/services/tablething/user.dart';

/// Gets data from firebase
class Tablething {
  final String apiUrl = 'https://us-central1-ruokamenu.cloudfunctions.net/api/v1/';
  final Firestore _db = Firestore.instance;

  // TODO GeoQuery
  /// Gets all establishments in db
  /// This function will be removed in the future
  Future<List<Establishment>> getEstablishmentsInArea() async {
    // Finland bounds
    final LatLng northEastBound = LatLng(70.238084, 33.168793);
    final LatLng southWestBound = LatLng(59.760846, 19.271040);

    try {
      QuerySnapshot qShot = await _db.collection('establishments').getDocuments();

      return qShot.documents.map((doc) {
        return Establishment.fromJson(Map<String, dynamic>.from(doc.data));
      }).toList();
    } catch (err) {
      print(err.toString());
      throw Exception('Failed to get establishments');
    }
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
      throw Exception('Failed to get user. ' + err.toString());
    }

    return user;
  }
}
