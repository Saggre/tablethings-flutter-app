import 'package:json_annotation/json_annotation.dart';

part 'place.g.dart';

/// Place represents a pair of gps coordinates
@JsonSerializable(nullable: false)
class Place {
  final double latitude;
  final double longitude;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceToJson(this);
}
