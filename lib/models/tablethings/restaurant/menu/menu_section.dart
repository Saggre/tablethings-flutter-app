import 'package:json_annotation/json_annotation.dart';
import 'package:tablething/util/string_tools.dart';

part 'menu_section.g.dart';


/// Generic menu item type is so that we can build a menu containing only item ids, and fetch the items later
@JsonSerializable(nullable: false)
class MenuSection {
  final String id;
  final String name;
  @JsonKey(nullable: true)
  final String description;
  @JsonKey(name: 'products')
  final List<MenuItem> items;

  MenuSection(this.id, this.name, this.description, this.items);

  factory MenuSection.fromJson(Map<String, dynamic> json) => _$MenuSectionFromJson(json);

  Map<String, dynamic> toJson() => _$MenuSectionToJson(this);

  String get getName {
    return StringTools.capitalize(name);
  }

  String get getDescription {
    return StringTools.capitalize(description);
  }
}
