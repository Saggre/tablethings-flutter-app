import 'package:json_annotation/json_annotation.dart';

/// Represents an order
@JsonSerializable(nullable: false)
class Order {
  String id;
  String userId;
  List<String> itemIds;
}
