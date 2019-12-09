import 'package:json_annotation/json_annotation.dart';

part 'card.g.dart';

enum Brand {
  amex,
  diners,
  visa,
  discover,
  jcb,
  mastercard,
  unionpay,
  unknown,
}

@JsonSerializable(nullable: false)
class Card {
  final Brand brand;
  final String country;
  @JsonKey(name: 'exp_month')
  final int expMonth;
  @JsonKey(name: 'exp_year')
  final int expYear;
  final String fingerprint;
  final String funding;
  final String last4;
  @JsonKey(name: 'three_d_secure_usage')
  final ThreeDSecureUsage threeDSecureUsage;

  Card({this.brand, this.country, this.expMonth, this.expYear, this.fingerprint, this.funding, this.last4, this.threeDSecureUsage});

  factory Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);

  Map<String, dynamic> toJson() => _$CardToJson(this);
}

@JsonSerializable(nullable: false)
class ThreeDSecureUsage {
  final bool supported;

  ThreeDSecureUsage(this.supported);

  factory ThreeDSecureUsage.fromJson(Map<String, dynamic> json) => _$ThreeDSecureUsageFromJson(json);

  Map<String, dynamic> toJson() => _$ThreeDSecureUsageToJson(this);
}
