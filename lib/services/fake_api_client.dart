import 'dart:async';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/services/tablething/menu/menu.dart';

import 'json_loader.dart';

/// Emulates real api client for testing
class ApiClient {
  Duration _requestDelay = Duration(seconds: 1);
  List<String> _fakeJsons = [
    'establishment_willihanhi.json',
  ];

  Future<Establishment> _getEstablishmentFromFile(String fileName) async {
    Establishment establishment;

    try {
      var result = await JsonLoader().parseJsonFromAssets('assets/debug/' + fileName);
      establishment = Establishment.fromJson(result);
    } catch (err) {
      print("Error parsing establishment json");
    }

    return establishment;
  }

  Future<Menu> _getMenuFromFile(String fileName) async {
    Menu menu;

    try {
      var result = await JsonLoader().parseJsonFromAssets('assets/debug/' + fileName);
      menu = Menu.fromJson(result);
    } catch (err) {
      print("Error parsing establishment menu json");
    }

    return menu;
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

  Future<Menu> getMenu() async {
    Menu menu = await _getMenuFromFile('menu.json');
    return Future.value(menu).timeout(_requestDelay);
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
