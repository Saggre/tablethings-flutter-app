import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/services/tablething/user.dart';

/// Gets data from firebase
class Tablething {
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
    try {
      var doc = await _db.collection('users').document(userId).get();
      var data = doc.data;
      data.addEntries([MapEntry("id", doc.documentID)]);
      return User.fromJson(data);
    } catch (err) {
      print(err.toString());
      throw Exception('Failed to get user');
    }
  }
}
