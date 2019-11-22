import 'package:flutter_test/flutter_test.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/models/establishment/menu/menu.dart';
import 'package:tablething/services/json_loader.dart';

void main() {
  test('Establishment JSON should be parsed correctly', () async {
    var result = await JsonLoader().parseJsonFromFile('assets/establishment_lilja.json', test: true);
    Establishment establishment = Establishment.fromJson(result);

    result = await JsonLoader().parseJsonFromFile('assets/menu.json', test: true);
    Menu menu = Menu.fromJson(result);

    establishment.setMenu(menu);

    expect(establishment.name, "Lilja Grillikioski");
    expect(menu.categories[0].formattedName, "Seafood");
  });
}
