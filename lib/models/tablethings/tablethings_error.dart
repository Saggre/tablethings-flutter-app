import 'package:json_annotation/json_annotation.dart';

part 'tablethings_error.g.dart';

@JsonSerializable(nullable: false)
class TablethingsError {
  @JsonKey(name: 'msg')
  String message;

  TablethingsError(this.message);

  factory TablethingsError.fromJson(Map<String, dynamic> json) => _$TablethingsErrorFromJson(json);

  Map<String, dynamic> toJson() => _$TablethingsErrorToJson(this);
}
