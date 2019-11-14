import 'dart:async';
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;
import 'package:latlong/latlong.dart';
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
      Currency.eur,
      EstablishmentType.fastFood,
      PriceRange.cheap,
      [CuisineType.pizza],
      "",
      "",
    ));

    return Future.value(establishments).timeout(_requestDelay);
  }
}
