// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Card _$CardFromJson(Map<String, dynamic> json) {
  return Card(
    brand: _$enumDecode(_$BrandEnumMap, json['brand']),
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
      'brand': _$BrandEnumMap[instance.brand],
      'country': instance.country,
      'exp_month': instance.expMonth,
      'exp_year': instance.expYear,
      'fingerprint': instance.fingerprint,
      'funding': instance.funding,
      'last4': instance.last4,
      'three_d_secure_usage': instance.threeDSecureUsage,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

const _$BrandEnumMap = {
  Brand.amex: 'amex',
  Brand.diners: 'diners',
  Brand.visa: 'visa',
  Brand.discover: 'discover',
  Brand.jcb: 'jcb',
  Brand.mastercard: 'mastercard',
  Brand.unionpay: 'unionpay',
  Brand.unknown: 'unknown',
};
