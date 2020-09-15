import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(nullable: false)
class User {
  final String id;
  final String username;
  final String email;
  final String stripeCustomerId;

  User(this.id, this.username, this.email, this.stripeCustomerId);

  /*@JsonKey(ignore: true)
  Future<List<PaymentMethod>> paymentMethods;
*/

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
