import 'package:tablething/models/establishment/menu/menu_category.dart';

/// Represents a collection of available products
class Menu {
  final List<MenuCategory> categories;

  Menu({this.categories});

  static Menu fromJson(json) {
    return Menu(
        categories: List.from(json["categories"]).map((category) {
      return MenuCategory.fromJson(category);
    }).toList());
  }
}
