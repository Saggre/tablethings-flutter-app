import 'dart:async';
import 'package:tablething/models/establishment/establishment.dart';

import 'json_loader.dart';

/// Emulates real api client for testing
class ApiClient {
  Duration _requestDelay = Duration(seconds: 1);
  List<String> _fakeJsons = [
    'establishment.json',
  ];

  ApiClient() {}

  /// Get a list of establishments
  Future<List<Establishment>> getEstablishments() async {
    List<Establishment> establishments = List();

    _fakeJsons.forEach((jsonFile) async {
      var result = await JsonLoader().parseJsonFromAssets('assets/debug/' + jsonFile);
      establishments.add(Establishment.fromJson(result));
    });

    return Future.value(establishments).timeout(_requestDelay);
  }

  /// Get a single establishment with id
  Future<Establishment> getEstablishment(String id) async {
    Establishment ret;

    (await getEstablishments()).forEach((object) {
      print("Object: " + object.id + " | id: " + id);
      if (object.id == id) {
        print("Found");
        ret = object;
      }
    });

    return Future.value(ret).timeout(_requestDelay);
  }
}
