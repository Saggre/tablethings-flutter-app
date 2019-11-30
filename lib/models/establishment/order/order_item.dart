import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'product.dart';

class OrderItemOptions {
  int _quantity;

  // TODO add sides
  // TODO add beverages
  // TODO add spices

  OrderItemOptions({quantity}) {
    if (quantity == null || quantity < 1) {
      _quantity = 1;
      return;
    }
    _quantity = quantity;
  }

  int get quantity => _quantity;
}

/// Represents an item in an order
/// One item can have many properties like extras and spices
class OrderItem<T extends Product> {
  final String id;
  final T product;
  OrderItemOptions options;

  OrderItem({@required this.product, @required this.options}) : this.id = Uuid().v4();

  @override
  bool operator ==(Object other) => identical(this, other) || other is OrderItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
