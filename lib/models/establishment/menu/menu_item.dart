import 'package:tablething/util/string_tools.dart';

/// Represents a single orderable item under a menu category
class MenuItem {
  final String name;
  final String description;
  final String price;
  final String imageUrl;

  MenuItem({this.name, this.description, this.price, this.imageUrl});

  String get formattedName {
    return StringTools.capitalize(name);
  }

  String get formattedDescription {
    return StringTools.capitalize(description);
  }

  /// Format:
  /// "price": "19.99", String
  /// "name": "Fried Turtle",
  /// "description": "May contain nuts"
  static MenuItem fromJson(json) {
    return MenuItem(
      name: json["name"] as String,
      description: json["description"] as String,
      price: json["price"] as String, // TODO monetary format
      imageUrl: json["imageUrl"] as String,
    );
  }
}
