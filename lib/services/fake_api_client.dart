import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:latlong/latlong.dart';
import 'package:tablething/models/cuisine_types.dart';
import 'establishment.dart';

/// Emulates real api client for testing
class ApiClient {
  Duration _requestDelay = Duration(seconds: 1);

  /// Gets a JSON file's content and returns them as String
  Future<String> loadJSON(String path) {
    return rootBundle.loadString(path);
  }

  /// Gets a list of establishments
  Future<List<Establishment>> getEstablishments() async {
    List<Establishment> establishments = List();
    establishments.add(Establishment(
      "fakeId0",
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

    return Future.value(establishments).timeout(_requestDelay);
  }
}
