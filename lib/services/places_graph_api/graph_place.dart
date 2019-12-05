import 'package:json_annotation/json_annotation.dart';

part 'graph_place.g.dart';

@JsonSerializable(nullable: false)
class GraphPlace {
  final String id;
  @JsonKey(name: 'overall_star_rating')
  final double rating;
  @JsonKey(name: 'rating_count')
  final int ratingCount;

  GraphPlace({this.id, this.rating, this.ratingCount});

  factory GraphPlace.fromJson(Map<String, dynamic> json) => _$GraphPlaceFromJson(json);

  Map<String, dynamic> toJson() => _$GraphPlaceToJson(this);
}
