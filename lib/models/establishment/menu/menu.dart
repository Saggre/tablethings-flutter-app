import 'package:json_annotation/json_annotation.dart';
import 'package:tablething/models/establishment/order/product.dart';
import 'package:tablething/util/string_tools.dart';

part 'menu.g.dart';

/// Represents a collection of available products
@JsonSerializable(nullable: false)
class Menu {
  final List<MenuCategory> categories;

  Menu({this.categories});

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);
}

@JsonSerializable(nullable: false)
class MenuCategory {
  final String name;
  final String description;
  final List<MenuItem> items;

  MenuCategory({this.name, this.description, this.items});

  factory MenuCategory.fromJson(Map<String, dynamic> json) => _$MenuCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$MenuCategoryToJson(this);

  String get formattedName {
    return StringTools.capitalize(name);
  }

  String get formattedDescription {
    return StringTools.capitalize(description);
  }
}

@JsonSerializable(nullable: false)
class MenuItem implements Product {
  final String id;
  final String name;
  final String description;
  final int price;
  final String imageUrl;

  MenuItem(this.id, this.name, this.description, this.price, this.imageUrl);

  factory MenuItem.fromJson(Map<String, dynamic> json) => _$MenuItemFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemToJson(this);

  String get formattedName {
    return StringTools.capitalize(name);
  }

  String get formattedDescription {
    return StringTools.capitalize(description);
  }
}
