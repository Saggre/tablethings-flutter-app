import 'package:json_annotation/json_annotation.dart';

part 'threed_secure_usage.g.dart';

@JsonSerializable(nullable: false)
class ThreeDSecureUsage {
  final bool supported;

  ThreeDSecureUsage(this.supported);

  factory ThreeDSecureUsage.fromJson(Map<String, dynamic> json) => _$ThreeDSecureUsageFromJson(json);

  Map<String, dynamic> toJson() => _$ThreeDSecureUsageToJson(this);
}
