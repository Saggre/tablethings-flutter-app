import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:latlong/latlong.dart';
import 'package:tablething/models/establishment/cuisine_types.dart';
import 'package:tablething/models/establishment/establishment.dart';

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
      "http://www.campaigncentre.com.au/_client/_images/ORANA_MA0515/outlet/logo/dominos.jpg",
      "https://i.imgur.com/nd2Atcg.jpg",
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
    Establishment ret;

    _establishments.forEach((object) {
      print("Object: " + object.id + " | id: " + id);
      if (object.id == id) {
        print("Found");
        ret = object;
      }
    });

    return Future.value(ret).timeout(_requestDelay);
  }
}
