import 'package:json_annotation/json_annotation.dart';
import 'package:tablething/services/stripe/card.dart';
import 'package:tablething/services/stripe/customer.dart';
import 'package:tablething/services/stripe/payment_method.dart';

part 'user.g.dart';

@JsonSerializable(nullable: false)
class User {
  final String id;
  final String displayName;
  final String email;
  final Customer stripeCustomer;

  @JsonKey(ignore: true)
  Future<List<PaymentMethod>> paymentMethods;

  User({this.id, this.displayName, this.email, this.stripeCustomer});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
