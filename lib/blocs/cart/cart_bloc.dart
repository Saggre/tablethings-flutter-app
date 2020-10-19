import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tablethings/models/tablethings/restaurant/menu/menu_item.dart';

import 'cart_bloc_events.dart';
import 'cart_bloc_states.dart';

class CartBloc extends Bloc<CartBlocEvent, CartBlocState> {
  Map<MenuItem, int> _items;

  CartBloc() : super(CartItems(new Map())) {
    _items = new Map();
  }

  @override
  Stream<CartBlocState> mapEventToState(CartBlocEvent event) async* {
    if (event is AddItem) {
      _addItem(event.item);
    } else if (event is AddItem) {
      _removeItem(event.item);
    }

    yield CartItems(_items);
  }

  /// Add item to cart
  void _addItem(MenuItem item) {
    _items.update(item, (int count) {
      return count + 1;
    }, ifAbsent: () => 1);
  }

  /// Remove item from cart
  void _removeItem(MenuItem item) {
    _items.update(item, (int count) {
      return count - 1;
    });

    _items.removeWhere((key, count) {
      return (key == item && count <= 0);
    });
  }
}
