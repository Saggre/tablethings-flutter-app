import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable(nullable: false)
class Customer {
  final String id;

  Customer(this.id);

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
