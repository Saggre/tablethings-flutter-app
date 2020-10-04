import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tablethings/models/tablethings/restaurant/menu/menu.dart';
import 'package:tablethings/models/tablethings/restaurant/restaurant.dart';
import 'package:tablethings/models/tablethings/user.dart';
import 'package:tablethings/services/tablethings.dart';

void main() {
  var _id = '110ec58a-a0f2-4ac4-8393-c866d813b8d1';
  String _token;
  Restaurant _restaurant;
  Menu _menu;

  test('Can authenticate as guest?', () async {
    var result = await Tablethings.authGuest();
    _token = result['token'];

    expect(_token.length > 5, true);

    Tablethings.setToken(_token);
  });

  test('Can get restaurant by id?', () async {
    _restaurant = await Tablethings.getRestaurant(_id);

    expect(_restaurant.id, _id);
  });

  test('Can get menu by id?', () async {
    _menu = await Tablethings.getMenu(_restaurant.activeMenuId);

    expect(_menu.id, _restaurant.activeMenuId);
  });

  test('Can get all by id?', () async {
    var all = await Tablethings.getAll(_id);

    expect(all['restaurant'].id, _id);
  });
}
