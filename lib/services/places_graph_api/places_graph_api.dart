import 'dart:convert';

import 'package:tablething/services/places_graph_api/graph_place.dart';
import 'package:http/http.dart' as http;

/// For fetching place information from facebook graph place API
class PlacesGraphApi {
  final String apiKey;

  PlacesGraphApi({this.apiKey});

  Future<GraphPlace> getPlaceWithId(String placeId) async {
    final response = await http.get('https://graph.facebook.com/v5.0/$placeId?fields=overall_star_rating,rating_count&access_token=$apiKey');

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);

      if (json.containsKey("error")) {
        throw Exception('Response raised an error');
      } else {
        return GraphPlace.fromJson(json);
      }
    } else {
      throw Exception('Failed to load post');
    }
  }
}
