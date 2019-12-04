// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'establishment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Establishment _$EstablishmentFromJson(Map<String, dynamic> json) {
  return Establishment(
    id: json['id'] as String,
    streetAddress: json['streetAddress'] as String,
    streetAddress2: json['streetAddress2'] as String,
    zipCode: json['zipCode'] as String,
    city: json['city'] as String,
    state: json['state'] as String,
    country: json['country'] as String,
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    name: json['name'] as String,
    description: json['description'] as String,
    graphId: json['graphId'] as String,
    currencyValue: json['currency'] as int,
    priceRangeValue: json['priceRange'] as int,
    cuisineTypeValues:
        (json['cuisineTypes'] as List).map((e) => e as int).toList(),
    openingHours: (json['openingHours'] as List)
        .map((e) => OpeningHourPeriod.fromJson(e as Map<String, dynamic>))
        .toList(),
    thumbUrl: json['thumbUrl'] as String,
    imageUrl: json['imageUrl'] as String,
  );
}

Map<String, dynamic> _$EstablishmentToJson(Establishment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'streetAddress': instance.streetAddress,
      'streetAddress2': instance.streetAddress2,
      'zipCode': instance.zipCode,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'name': instance.name,
      'description': instance.description,
      'graphId': instance.graphId,
      'currency': instance.currencyValue,
      'priceRange': instance.priceRangeValue,
      'cuisineTypes': instance.cuisineTypeValues,
      'openingHours': instance.openingHours,
      'thumbUrl': instance.thumbUrl,
      'imageUrl': instance.imageUrl,
    };
