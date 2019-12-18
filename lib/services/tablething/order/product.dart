import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

/// Class for a product that is orderable through an Order object
@JsonSerializable(nullable: false)
class Product {
  final String id;
  final String name;
  final int price;
  final String description;
  final String imageUrl;

  Product({this.id, this.name, this.price, this.description, this.imageUrl});

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
