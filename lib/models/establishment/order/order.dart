import 'order_item.dart';

/// Represents an order with products from an establishment
class Order {
  List<OrderItem> _items;

  Order() {
    this._items = List();
  }
}
