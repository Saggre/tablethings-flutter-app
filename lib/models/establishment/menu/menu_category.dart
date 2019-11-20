import 'package:tablething/util/string_tools.dart';
import 'menu_item.dart';

/// Represents a category under the main menu such as fish or pizza
class MenuCategory {
  final String name;
  final String description;
  final List<MenuItem> items;

  String get formattedName {
    return StringTools.capitalize(name);
  }

  String get formattedDescription {
    return StringTools.capitalize(description);
  }

  MenuCategory({this.name, this.description, this.items});

  /// Gets a list of menu items from json array
  static List<MenuItem> _getMenuItems(json) {
    return List.from(json).map((item) {
      return MenuItem.fromJson(item);
    }).toList();
  }

  /// Format:
  /// "name": "seafood",
  /// "items": [
  ///   {
  ///     "price": "19.99", String
  ///     "name": "Fried Turtle",
  ///     "description": "May contain nuts"
  ///   }
  /// ]
  static MenuCategory fromJson(json) {
    return MenuCategory(
      name: json["name"] as String,
      description: "",
      items: _getMenuItems(json["items"]),
    );
  }
}
