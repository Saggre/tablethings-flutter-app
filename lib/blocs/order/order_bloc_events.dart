import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/models/establishment/menu/menu_item.dart';
import 'package:tablething/models/establishment/order/order.dart';
import 'package:tablething/models/establishment/order/order_item.dart';
import 'package:tablething/models/fetchable_package.dart';

class OrderBlocEvent extends BlocEvent {}

/// Event that gets the establishment's data
class GetEstablishmentEvent extends OrderBlocEvent {
  final FetchablePackage<String, Establishment> establishmentPackage;

  GetEstablishmentEvent(this.establishmentPackage) : super();
}

/// Event for creating a new blank order
class InitOrderEvent extends OrderBlocEvent {}

class CreateOrderItemEvent extends OrderBlocEvent {
  final MenuItem menuItem;

  CreateOrderItemEvent(this.menuItem) : super();
}

/// Event for adding an order item to the order
class AddOrderItemEvent extends OrderBlocEvent {
  final OrderItem orderItem;
  final OrderItemOptions orderItemOptions;

  AddOrderItemEvent(this.orderItem, this.orderItemOptions) : super();
}

/// To remove an order item from the order
class RemoveOrderItemEvent extends OrderBlocEvent {
  final OrderItem orderItem;

  RemoveOrderItemEvent(this.orderItem) : super();
}

/// To forget an order item before adding it to the order
/// To cancel editing an item in an order
class ForgetOrderItemEvent extends OrderBlocEvent {
  final OrderItem orderItem;

  ForgetOrderItemEvent(this.orderItem) : super();
}

/// Event for modifying an order item's options
class ModifyOrderItemOptionsEvent extends OrderBlocEvent {
  final OrderItemOptions newOptions;
  final OrderItem orderItem;

  ModifyOrderItemOptionsEvent(this.newOptions, this.orderItem) : super();
}

/// To return to menu view
class RequestMenuEvent extends OrderBlocEvent {
  RequestMenuEvent() : super();
}

class RequestShoppingBasketEvent extends OrderBlocEvent {
  RequestShoppingBasketEvent() : super();
}

/// To return to menu view
class RequestCheckoutEvent extends OrderBlocEvent {
  final Order order;

  RequestCheckoutEvent(this.order) : super();
}
