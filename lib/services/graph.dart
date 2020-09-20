import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:tablethings/models/graph/place.dart';

/// For fetching place information from facebook graph place API
class Graph {
  final String accessToken;

////https://graph.facebook.com/search?type=place&center=60.2769888,24.848931&access_token=2227470867
  Graph({@required this.accessToken});

  Future<Place> getPlaceWithId(String placeId) async {
    print("Get graph place: " + placeId);
    final response = await http.get('https://graph.facebook.com/v5.0/$placeId?fields=overall_star_rating,rating_count&access_token=$accessToken');

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      if (json.containsKey('Error')) {
        throw Exception('Response raised an error');
      } else {
        return Place.fromJson(json);
      }
    } else {
      throw Exception('Failed to load post');
    }
  }
}
