// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Card _$CardFromJson(Map<String, dynamic> json) {
  return Card(
    brand: json['brand'] as String,
    country: json['country'] as String,
    expMonth: json['exp_month'] as int,
    expYear: json['exp_year'] as int,
    fingerprint: json['fingerprint'] as String,
    funding: json['funding'] as String,
    last4: json['last4'] as String,
    threeDSecureUsage: ThreeDSecureUsage.fromJson(
        json['three_d_secure_usage'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CardToJson(Card instance) => <String, dynamic>{
      'brand': instance.brand,
      'country': instance.country,
      'exp_month': instance.expMonth,
      'exp_year': instance.expYear,
      'fingerprint': instance.fingerprint,
      'funding': instance.funding,
      'last4': instance.last4,
      'three_d_secure_usage': instance.threeDSecureUsage,
    };

ThreeDSecureUsage _$ThreeDSecureUsageFromJson(Map<String, dynamic> json) {
  return ThreeDSecureUsage(
    json['supported'] as bool,
  );
}

Map<String, dynamic> _$ThreeDSecureUsageToJson(ThreeDSecureUsage instance) =>
    <String, dynamic>{
      'supported': instance.supported,
    };
