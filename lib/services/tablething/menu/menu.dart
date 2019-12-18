import 'package:json_annotation/json_annotation.dart';
import 'package:tablething/services/tablething/order/product.dart';
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

/// Generic menu item type is so that we can build a menu containing only item ids, and fetch the items later
@JsonSerializable(nullable: false)
class MenuCategory {
  final String name;
  @JsonKey(nullable: true)
  final String description;
  @JsonKey(name: 'products')
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

/// A single menu item
@JsonSerializable(nullable: false)
class MenuItem implements Product {
  final String id;
  @JsonKey(nullable: true)
  final String name;
  @JsonKey(nullable: true)
  final String description;
  @JsonKey(nullable: true)
  final int price;
  @JsonKey(nullable: true)
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
