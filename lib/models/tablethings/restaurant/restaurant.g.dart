// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) {
  return Restaurant(
    json['id'] as String,
    Address.fromJson(json['address'] as Map<String, dynamic>),
    json['name'] as String,
    json['description'] as String,
    json['priceRange'] as int,
    json['thumbnail'] as String,
    (json['images'] as List).map((e) => e as String).toList(),
    json['graphId'] as String,
    (json['cuisineTypes'] as List)?.map((e) => e as int)?.toList(),
    json['activeMenuId'] as String,
    (json['menuIds'] as List).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'name': instance.name,
      'description': instance.description,
      'priceRange': instance.priceRange,
      'thumbnail': instance.thumbnail,
      'images': instance.images,
      'graphId': instance.graphId,
      'cuisineTypes': instance.cuisineTypes,
      'activeMenuId': instance.activeMenuId,
      'menuIds': instance.menuIds,
    };
