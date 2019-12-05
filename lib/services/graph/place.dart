import 'package:json_annotation/json_annotation.dart';

part 'place.g.dart';

@JsonSerializable(nullable: false)
class Place {
  final String id;
  @JsonKey(name: 'overall_star_rating')
  final double rating;
  @JsonKey(name: 'rating_count')
  final int ratingCount;

  Place({this.id, this.rating, this.ratingCount});

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceToJson(this);
}
