import 'package:json_annotation/json_annotation.dart';
import 'menu_section.dart';

part 'menu.g.dart';

/// A restaurant's menu
@JsonSerializable(nullable: false)
class Menu {
  final String id;
  final String name;
  final String description;
  final List<MenuSection> sections;

  Menu(this.id, this.name, this.description, this.sections);

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);
}
