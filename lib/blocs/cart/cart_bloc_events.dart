import 'package:tablethings/models/tablethings/restaurant/menu/menu_item.dart';

abstract class CartBlocEvent {}

/// Add item to cart
class AddItem extends CartBlocEvent {
  final MenuItem item;

  AddItem(this.item);
}

/// Remove item from cart
class RemoveItem extends CartBlocEvent {
  final MenuItem item;

  RemoveItem(this.item);
}

/// Pay for cart
class PayCart extends CartBlocEvent {}
