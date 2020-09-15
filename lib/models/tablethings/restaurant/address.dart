import 'package:json_annotation/json_annotation.dart';
import 'place.dart';

part 'address.g.dart';

/// Establishment represents a business selling food items or drinks
@JsonSerializable(nullable: false)
class Address {
  final String address1;
  final String address2;
  final String city;
  final String state;
  final String postcode;
  final String country;
  final Place place;

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
