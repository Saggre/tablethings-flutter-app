import 'package:tablething/models/establishment/order/product.dart';
import 'package:tablething/util/string_tools.dart';

/// Represents a single orderable item under a menu category
class MenuItem implements Product {
  final String _id;
  final String _name;
  final String _description;
  final int _price;
  final String _imageUrl;

  MenuItem({id, name, description, price, imageUrl})
      : _id = id,
        _name = name,
        _description = description,
        _price = price,
        _imageUrl = imageUrl;

  String get formattedName {
    return StringTools.capitalize(name);
  }

  String get formattedDescription {
    return StringTools.capitalize(_description);
  }

  String get id => _id;

  String get name => _name;

  String get description => _description;

  int get price => _price;

  String get imageUrl => _imageUrl;

  /// Format:
  /// "price": "19.99", String
  /// "name": "Fried Turtle",
  /// "description": "May contain nuts"
  static MenuItem fromJson(json) {
    return MenuItem(
      id: json["id"] as String,
      name: json["name"] as String,
      description: json["description"] as String,
      price: json["price"] as int,
      imageUrl: json["imageUrl"] as String,
    );
  }
}
