import 'package:flutter_test/flutter_test.dart';
import 'package:tablething/services/json_loader.dart';
import 'package:tablething/services/places_api/place.dart';

void main() {
  test('Place should be retrieved', () async {
    var result = await JsonLoader().parseJsonFromFile('assets/places_api_result.json', test: true);
    Place place = Place.fromJson(result["result"]);
    expect(place.name, "Lilja Grillikioski");
    expect(place.openingHours.length > 0, true);

  });
}
