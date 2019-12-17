import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/services/stripe/payment_method.dart';
import 'package:tablething/services/tablething/menu/menu.dart';
import 'package:tablething/services/tablething/order/order.dart';
import 'package:tablething/services/tablething/order/order_item.dart';

/// Generic state for this bloc's states
class OrderBlocState extends BlocState {
  // Send establishment in every event
  final Establishment establishment;

  OrderBlocState(this.establishment);
}

/// Still loading the establishment's data
class LoadingState extends OrderBlocState {
  LoadingState(establishment) : super(establishment);
}

/// When the menu is shown
class EstablishmentState extends OrderBlocState {
  final Menu menu;

  EstablishmentState(establishment, this.menu) : super(establishment);
}

/// When an order item is shown
class OrderItemState extends OrderBlocState {
  final OrderItem<MenuItem> orderItem;

  OrderItemState(establishment, this.orderItem) : super(establishment);
}

/// Shopping basket with all order items shown
class ShoppingBasketState extends OrderBlocState {
  final Order<MenuItem> order;

  ShoppingBasketState(establishment, this.order) : super(establishment);
}

/// Checkout stage where the user can choose payment method etc.
class CheckoutState extends OrderBlocState {
  final Order<MenuItem> order;
  //final PaymentMethod paymentMethod;

  CheckoutState(establishment, this.order) : super(establishment);
}

/// Receipt of the payment (or an error in case of unsuccessful payment)
class ReceiptState extends OrderBlocState {
  final Order<MenuItem> order;

  ReceiptState(establishment, this.order) : super(establishment);
}

/*class NeedsLoginState extends ShoppingBasketState {
  NeedsLoginState(establishment, Order<MenuItem> order) : super(establishment, order);
}*/
