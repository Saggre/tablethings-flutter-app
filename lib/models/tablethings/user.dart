import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(nullable: false)
class User {
  final String id;
  final String email;
  final String stripeCustomerId;

  User(this.id, this.email, this.stripeCustomerId);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// Whether this user is a guest account
  bool isGuest() {
    return id == 'guest';
  }
}
