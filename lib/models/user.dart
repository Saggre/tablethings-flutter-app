import 'package:json_annotation/json_annotation.dart';
import 'package:tablething/services/stripe/customer.dart';

part 'user.g.dart';

@JsonSerializable(nullable: false)
class User {
  final String id;
  final String displayName;
  final String email;
  @JsonKey(nullable: true)
  final String stripeCustomerId;

  @JsonKey(ignore: true)
  Customer _stripeCustomer;

  User({this.id, this.displayName, this.email, this.stripeCustomerId});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
