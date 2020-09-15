import 'package:json_annotation/json_annotation.dart';
import 'card.dart';

part 'payment_method.g.dart';

/// Stripe Payment method object
@JsonSerializable(nullable: false)
class PaymentMethod {
  final String id;
  final String type;
  final Card card;

  PaymentMethod({this.id, this.type, this.card});

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => _$PaymentMethodFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
}
