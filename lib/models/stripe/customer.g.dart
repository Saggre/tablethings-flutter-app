// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceSettings _$InvoiceSettingsFromJson(Map<String, dynamic> json) {
  return InvoiceSettings(
    defaultPaymentMethodId: json['default_payment_method'] as String,
  );
}

Map<String, dynamic> _$InvoiceSettingsToJson(InvoiceSettings instance) =>
    <String, dynamic>{
      'default_payment_method': instance.defaultPaymentMethodId,
    };

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return Customer(
    id: json['id'] as String,
    invoiceSettings: InvoiceSettings.fromJson(
        json['invoice_settings'] as Map<String, dynamic>),
    balance: json['balance'] as int,
    invoicePrefix: json['invoice_prefix'] as String,
    taxExempt:
        _$enumDecodeNullable(_$TaxExemptStatusEnumMap, json['tax_exempt']),
  );
}

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'invoice_settings': instance.invoiceSettings,
      'balance': instance.balance,
      'invoice_prefix': instance.invoicePrefix,
      'tax_exempt': _$TaxExemptStatusEnumMap[instance.taxExempt],
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

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$TaxExemptStatusEnumMap = {
  TaxExemptStatus.none: 'none',
  TaxExemptStatus.exempt: 'exempt',
  TaxExemptStatus.reverse: 'reverse',
};
