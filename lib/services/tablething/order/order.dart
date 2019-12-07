import 'package:tablething/services/tablething/order/product.dart';

import 'order_item.dart';

/// Represents an order with products from an establishment
class Order<T extends Product> {
  List<OrderItem<T>> _items;

  Order() {
    _items = List();
  }

  void addItem(OrderItem<T> item) {
    _items.add(item);
  }

  List<OrderItem<T>> get items => _items;

  /// Calculates the total price of the order
  int get subtotal {
    int t = 0;
    _items.forEach((OrderItem orderItem) {
      t += orderItem.product.price;
    });
    return t;
  }

  bool containsItem(OrderItem<T> orderItem) {
    return _items.contains(orderItem);
  }
}
