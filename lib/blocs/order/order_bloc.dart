import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/services/tablething/menu/menu.dart';
import 'package:tablething/services/tablething/order/order.dart';
import 'package:tablething/services/tablething/order/order_item.dart';
import 'order_bloc_states.dart';
import 'order_bloc_events.dart';
export 'order_bloc_states.dart';
export 'order_bloc_events.dart';
import 'package:tablething/services/tablething/tablething.dart' as Api;

/// Order bloc
class OrderBloc extends Bloc<OrderBlocEvent, OrderBlocState> {
  // For getting data from db
  Establishment _establishment;
  String _tableId;
  Order<MenuItem> _order;
  final Api.Tablething _api = Api.Tablething();

  @override
  // Init with null
  OrderBlocState get initialState => LoadingState(null);

  @override
  Stream<OrderBlocState> mapEventToState(OrderBlocEvent event) async* {
    // TODO deferred stream
    // TODO loading state
    // TODO save postman tests
    if (event is GetEstablishmentEvent) {
      yield await _getEstablishment(event);

      // Init new order when got establishment
      add(
        InitOrderEvent(),
      );
    } else if (event is InitOrderEvent) {
      yield await _initOrder(event);
    } else if (event is CreateOrderItemEvent) {
      yield await _createOrderItem(event);
    } else if (event is AddOrderItemEvent) {
      yield await _addOrderItem(event);
    } else if (event is ModifyOrderItemOptionsEvent) {
      yield await _modifyOrderItemOptions(event);
    } else if (event is ForgetOrderItemEvent) {
      yield await _forgetOrderItem(event);
    } else if (event is RequestMenuEvent) {
      yield await _goToMenu(event);
    } else if (event is RequestCheckoutEvent) {
      yield await _goToCheckout(event);
    } else if (event is RemoveOrderItemEvent) {
      yield await _removeOrderItem(event);
    } else if (event is RequestShoppingBasketEvent) {
      yield await _goToShoppingBasket(event);
    }
  }

  /// Gets an establishment and menu
  Future<OrderBlocState> _getEstablishment(GetEstablishmentEvent event) async {
    try {
      _establishment = await _api.getEstablishment(event.establishmentId);
      _tableId = event.tableId;

      return EstablishmentState(_establishment);
    } catch (err) {
      print("Error: " + err.toString());
      return BlocState.withError(t('An error occurred')) as EstablishmentState;
    }
  }

  /// Initiates a new order
  Future<OrderBlocState> _initOrder(InitOrderEvent event) async {
    _order = Order<MenuItem>();
    if (_establishment != null) {
      return EstablishmentState(_establishment);
    } else {
      return BlocState.withError(t('An error occurred')) as EstablishmentState;
    }
  }

  /// Transforms a menu item into an order item that is able to have properties
  Future<OrderBlocState> _createOrderItem(CreateOrderItemEvent event) async {
    // TODO test this
    if (_order == null || _establishment == null) {
      return BlocState.withError(t('Order is not initiated')) as OrderItemState;
    }

    OrderItem<MenuItem> orderItem = OrderItem(product: event.menuItem, options: OrderItemOptions(quantity: 1));

    return OrderItemState(
      _establishment,
      orderItem,
    );
  }

  /// Add order item to order
  Future<OrderBlocState> _addOrderItem(AddOrderItemEvent event) async {
    event.orderItem.options = event.orderItemOptions;
    _order.addItem(event.orderItem);

    return ShoppingBasketState(
      _establishment,
      _order,
      _tableId,
    );
  }

  /// Remove an order item from the order
  Future<OrderBlocState> _removeOrderItem(RemoveOrderItemEvent event) async {
    if (event.orderItem == null || _order == null) {
      // TODO error
    }

    bool removed = _order.items.remove(event.orderItem);

    if (!removed) {
      print("Couldn't remove item from order");
    }

    // Go to menu in case of empty order after removal
    if (_order.items.length == 0) {
      return EstablishmentState(_establishment);
    }

    return ShoppingBasketState(
      _establishment,
      _order,
      _tableId,
    );
  }

  /// Set new options for an order item
  Future<OrderBlocState> _modifyOrderItemOptions(ModifyOrderItemOptionsEvent event) async {
    if (_order == null) {
      // TODO err
    }

    int replacedOptionsCount = 0;

    _order.items.where((OrderItem item) {
      return item == event.orderItem;
    }).forEach((OrderItem item) {
      item.options = event.newOptions;
      replacedOptionsCount++;
    });

    if (replacedOptionsCount != 1) {
      print("Error modifying order item options");
    }

    return ShoppingBasketState(_establishment, _order, _tableId);
  }

  /// Forgets the order item and returns to the last screen
  Future<OrderBlocState> _forgetOrderItem(ForgetOrderItemEvent event) async {
    if (_order.containsItem(event.orderItem)) {
      return ShoppingBasketState(_establishment, _order, _tableId);
    }

    return EstablishmentState(_establishment);
  }

  Future<OrderBlocState> _goToMenu(RequestMenuEvent event) async {
    if (_establishment == null) {
      // TODO error
    }

    return EstablishmentState(_establishment);
  }

  Future<OrderBlocState> _goToCheckout(RequestCheckoutEvent event) async {
    if (_order == null || _establishment == null) {
      // TODO error
    }

    return CheckoutState(_establishment, event.order, _tableId);
  }

  Future<OrderBlocState> _goToShoppingBasket(RequestShoppingBasketEvent event) async {
    if (_order == null || _establishment == null) {
      // TODO error
    }

    return ShoppingBasketState(_establishment, _order, _tableId);
  }
}
