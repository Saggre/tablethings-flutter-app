// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Place _$PlaceFromJson(Map<String, dynamic> json) {
  return Place(
    id: json['id'] as String,
    rating: (json['overall_star_rating'] as num).toDouble(),
    ratingCount: json['rating_count'] as int,
  );
}

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
      'id': instance.id,
      'overall_star_rating': instance.rating,
      'rating_count': instance.ratingCount,
    };
