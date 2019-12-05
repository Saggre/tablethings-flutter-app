// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'graph_place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraphPlace _$GraphPlaceFromJson(Map<String, dynamic> json) {
  return GraphPlace(
    id: json['id'] as String,
    rating: (json['overall_star_rating'] as num).toDouble(),
    ratingCount: json['rating_count'] as int,
  );
}

Map<String, dynamic> _$GraphPlaceToJson(GraphPlace instance) =>
    <String, dynamic>{
      'id': instance.id,
      'overall_star_rating': instance.rating,
      'rating_count': instance.ratingCount,
    };
