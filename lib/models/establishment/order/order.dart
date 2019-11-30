import 'package:tablething/models/establishment/order/product.dart';

import 'order_item.dart';

/// Represents an order with products from an establishment
class Order<T extends Product> {
  List<OrderItem<T>> _items;

  Order() {
    this._items = List();
  }

  void addItem(OrderItem<T> item) {
    _items.add(item);
  }

  List<OrderItem<T>> get items => _items;
}
