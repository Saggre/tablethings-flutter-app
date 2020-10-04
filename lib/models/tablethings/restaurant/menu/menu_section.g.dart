// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuSection _$MenuSectionFromJson(Map<String, dynamic> json) {
  return MenuSection(
    json['id'] as String,
    json['name'] as String,
    json['description'] as String,
    (json['items'] as List)
        .map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$MenuSectionToJson(MenuSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'items': instance.items,
    };
