import 'dart:async';
import 'dart:convert';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/models/establishment/menu/menu.dart';

import 'json_loader.dart';

/// Emulates real api client for testing
class ApiClient {
  Duration _requestDelay = Duration(seconds: 1);
  List<String> _fakeJsons = [
    'establishment_lilja.json',
    'establishment_willihanhi.json',
  ];

  ApiClient() {}

  Future<Establishment> _getEstablishmentFromFile(String fileName) async {
    var result;

    Establishment establishment;

    try {
      result = await JsonLoader().parseJsonFromAssets('assets/debug/' + fileName);
      establishment = Establishment.fromJson(result);
    } catch (err) {
      print("Error parsing establishment json");
    }

    try {
      result = await JsonLoader().parseJsonFromAssets('assets/debug/menu.json');
      Menu menu = Menu.fromJson(result);
      establishment.setMenu(menu);
    } catch (err) {
      print("Error parsing establishment menu json");
    }

    return establishment;
  }

  /// Get a list of establishments
  Future<List<Establishment>> getEstablishments() async {
    List<Establishment> establishments = List();

    for (int i = 0; i < _fakeJsons.length; i++) {
      var e = await _getEstablishmentFromFile(_fakeJsons[i]);
      establishments.add(e);
    }

    return Future.value(establishments).timeout(_requestDelay);
  }

  /// Get a single establishment with id
  Future<Establishment> getEstablishment(String id) async {
    List<Establishment> establishments = await getEstablishments();
    Establishment ret;

    establishments.forEach((object) {
      if (object.id == id) {
        ret = object;
      }
    });

    return Future.value(ret).timeout(_requestDelay);
  }
}
