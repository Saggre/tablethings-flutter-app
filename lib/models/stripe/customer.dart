import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable(nullable: true)
class InvoiceSettings {
  @JsonKey(name: 'default_payment_method', nullable: true)
  final String defaultPaymentMethodId;

  InvoiceSettings({this.defaultPaymentMethodId});

  factory InvoiceSettings.fromJson(Map<String, dynamic> json) => _$InvoiceSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceSettingsToJson(this);
}

enum TaxExemptStatus { none, exempt, reverse }

/// Stripe Customer object
@JsonSerializable(nullable: false)
class Customer {
  final String id;

  @JsonKey(name: 'invoice_settings')
  final InvoiceSettings invoiceSettings;

  @JsonKey(nullable: true)
  final int balance;

  @JsonKey(name: 'invoice_prefix', nullable: true)
  final String invoicePrefix;

  @JsonKey(name: 'tax_exempt', nullable: true)
  final TaxExemptStatus taxExempt;

  Customer({this.id, this.invoiceSettings, this.balance, this.invoicePrefix, this.taxExempt});

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
