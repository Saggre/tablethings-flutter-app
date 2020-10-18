import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tablethings/models/tablethings/restaurant/menu/menu.dart';
import 'package:tablethings/models/tablethings/restaurant/restaurant.dart';
import 'package:tablethings/models/tablethings/user.dart';
import 'package:tablethings/services/tablethings.dart';
import 'dart:math';

/// Get a random string
String generateRandomString(int len) {
  var r = Random();
  const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}

void main() {
  var _id = '110ec58a-a0f2-4ac4-8393-c866d813b8d1';
  String _token;
  Restaurant _restaurant;
  Menu _menu;

  User _currentUser;

  // For user creation
  String email = generateRandomString(10) + '@gmail.com';
  String password = generateRandomString(12);

  test('Can authenticate as guest?', () async {
    var result = await Tablethings.authGuest();
    _token = result['token'];

    expect(_token.length > 5, true);

    Tablethings.setToken(_token);
  });

  test('Can create account?', () async {
    var result = await Tablethings.createUser(email, password);
    _token = result['token'];

    expect(_token.length > 5, true);

    Tablethings.setToken(_token);
  });

  test('Can login with email?', () async {
    var result = await Tablethings.authEmail(email, password);

    _token = result['token'];
    _currentUser = result['user'];

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

  test('Can get menu and restaurant by id?', () async {
    var all = await Tablethings.getAll(_id);

    expect(all['restaurant'].id, _id);
  });

  /*test('Can get Stripe account?', () async {
    _currentStripeCustomer = await Tablethings.getStripeCustomer(_currentUser.stripeCustomerId);
    print(_currentStripeCustomer.toJson().toString());
    expect(_currentStripeCustomer.id.length > 5, true);
  });*/
}
