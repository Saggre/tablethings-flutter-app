import 'dart:async';
import 'dart:convert' show json;

import 'package:firestore_helpers/firestore_helpers.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'location.dart';
import 'establishment.dart';

/// Gets data from firebase
class ApiClient {
  final _apiKey = '7f98466d9728f4117e35b8eca9fa8705';
  final _host = 'developers.zomato.com';
  final _contextRoot = 'api/v2.1';

  final _databaseReference = Firestore.instance;

  Stream<QuerySnapshot> getEstablishments({List<QueryConstraint> constraints}) {
    // TODO geoquery
    return _databaseReference.collection("establishments").snapshots();
  }

  /// Returns a future list of establishment locations
  Future<List<Location>> fetchLocations(String query) async {
    final Map results = await request(
        path: 'locations', parameters: {'query': query, 'count': '10'});

    final suggestions = results['location_suggestions'];
    return suggestions
        .map<Location>((json) => Location.fromJson(json))
        .toList(growable: false);
  }

  /// Makes a call to the API
  Future<Map> request(
      {@required String path, Map<String, String> parameters}) async {
    final uri = Uri.https(_host, '$_contextRoot/$path', parameters);
    final results = await http.get(uri, headers: _headers);
    final jsonObject = json.decode(results.body);
    return jsonObject;
  }

  /*
  * Future<Map> request(
      {@required String path, Map<String, String> parameters}) async {
    final uri = Uri.https(_host, '$_contextRoot/$path', parameters);
    final results = await http.get(uri, headers: _headers);
    final jsonObject = json.decode(results.body);
    return jsonObject;
  }
  * */

  /// Call headers
  Map<String, String> get _headers =>
      {'Accept': 'application/json', 'user-key': _apiKey};
}
