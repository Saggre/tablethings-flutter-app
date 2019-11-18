import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:latlong/latlong.dart';
import 'package:tablething/models/cuisine_types.dart';

import 'establishment.dart';

/// Emulates real api client for testing
class ApiClient {
  Duration _requestDelay = Duration(seconds: 1);

  List<Establishment> _establishments = List();

  ApiClient() {
    _establishments.add(Establishment(
      "123e4567-e89b-12d3-a456-426655440000",
      "Laajaniityntie 5",
      "",
      "01620",
      "Vantaa",
      "",
      "FIN",
      LatLng(60.277969, 24.8525615),
      "Lilja Grillikioski",
      "Kiva kebupaikka sillan alla.",
      "",
      Currency.eur,
      PriceRange.cheap,
      [CuisineType.pizza],
      "https://www.mcdonalds.com/content/dam/usa/logo/m_logo.png",
      "https://i.imgur.com/4eIg9MY.png",
    ));
  }

  /// Gets a JSON file's content and returns them as String
  Future<String> loadJSON(String path) {
    return rootBundle.loadString(path);
  }

  /// Get a list of establishments
  Future<List<Establishment>> getEstablishments() async {
    return Future.value(_establishments).timeout(_requestDelay);
  }

  /// Get a single establishment with id
  Future<Establishment> getEstablishment(String id) async {
    _establishments.forEach((object) {
      if (object.id == id) {
        return Future.value(object).timeout(_requestDelay);
      }
    });

    return Future.error(null).timeout(_requestDelay);
  }
}
