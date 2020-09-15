import 'package:json_annotation/json_annotation.dart';
import 'package:tablething/util/string_tools.dart';

part 'menu_item.g.dart';


/// A single menu item
@JsonSerializable(nullable: false)
class MenuItem {
  final String id;
  @JsonKey(nullable: true)
  final String name;
  @JsonKey(nullable: true)
  final String description;
  @JsonKey(nullable: true)
  final int price;
  @JsonKey(nullable: true)
  final List<String> images;

  MenuItem(this.id, this.name, this.description, this.price, this.images);

  factory MenuItem.fromJson(Map<String, dynamic> json) => _$MenuItemFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemToJson(this);

  String get getName {
    return StringTools.capitalize(name);
  }

  String get getDescription {
    return StringTools.capitalize(description);
  }
}
