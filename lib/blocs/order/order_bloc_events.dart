import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/models/establishment/menu/menu_item.dart';
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

/// Event for adding a menu item (a product) to the order
class AddOrderItemEvent extends OrderBlocEvent {
  final MenuItem menuItem;

  AddOrderItemEvent(this.menuItem) : super();
}

/// To remove an order item from the order
class RemoveOrderItemEvent extends OrderBlocEvent {
  final String orderItemId;

  RemoveOrderItemEvent(this.orderItemId) : super();
}

/// Event for modifying an order item's options
class ModifyOrderItemOptionsEvent extends OrderBlocEvent {
  final OrderItemOptions newOptions;
  final OrderItem orderItem;

  ModifyOrderItemOptionsEvent(this.newOptions, this.orderItem) : super();
}
