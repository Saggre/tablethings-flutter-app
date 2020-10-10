import 'package:tablethings/models/tablethings/restaurant/menu/menu_item.dart';

abstract class CartBlocState {}

/// Cart state with items and their quantities
class CartItems extends CartBlocState {
  final Map<MenuItem, int> items;

  CartItems(this.items);
}
