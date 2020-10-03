import 'package:flutter_test/flutter_test.dart';
import 'package:tablethings/models/tablethings/user.dart';
import 'package:tablethings/services/tablethings.dart';

void main() {
  String _token;

  test('Can authenticate as guest?', () async {
    var result = await Tablethings.authGuest();
    _token = result['token'];

    expect(_token.length > 5, true);

    Tablethings.setToken(_token);
  });

  test('Can get restaurant by id?', () async {
    var id = '110ec58a-a0f2-4ac4-8393-c866d813b8d1';
    var restaurant = await Tablethings.getRestaurant(id);

    expect(restaurant.id, id);
  });
}
