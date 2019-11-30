import 'product.dart';

/// Represents an item in an order
/// One item can have many properties like extras and spices
class OrderItem<T extends Product> {
  final T product;
  int _quantity;

  OrderItem(this.product) {
    _quantity = 1;
  }

  int get quantity => _quantity;

  set quantity(int value) {
    if (value < 1) {
      _quantity = 1;
      return;
    }
    _quantity = value;
  }

// TODO add sides
// TODO add beverages
// TODO add spices
}
