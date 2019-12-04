// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Menu _$MenuFromJson(Map<String, dynamic> json) {
  return Menu(
    categories: (json['categories'] as List)
        .map((e) => MenuCategory.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$MenuToJson(Menu instance) => <String, dynamic>{
      'categories': instance.categories,
    };

MenuCategory _$MenuCategoryFromJson(Map<String, dynamic> json) {
  return MenuCategory(
    name: json['name'] as String,
    description: json['description'] as String,
    items: (json['items'] as List)
        .map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$MenuCategoryToJson(MenuCategory instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'items': instance.items,
    };

MenuItem _$MenuItemFromJson(Map<String, dynamic> json) {
  return MenuItem(
    json['id'] as String,
    json['name'] as String,
    json['description'] as String,
    json['price'] as int,
    json['imageUrl'] as String,
  );
}

Map<String, dynamic> _$MenuItemToJson(MenuItem instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'imageUrl': instance.imageUrl,
    };
