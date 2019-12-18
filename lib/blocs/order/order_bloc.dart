import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:tablething/services/stripe/payment_method.dart';
import 'package:tablething/services/tablething/menu/menu.dart';
import 'package:tablething/services/tablething/order/order.dart';
import 'package:tablething/services/tablething/order/order_item.dart';
import 'order_bloc_states.dart';
import 'order_bloc_events.dart';
export 'order_bloc_states.dart';
export 'order_bloc_events.dart';
import 'package:tablething/services/tablething/tablething.dart' as Api;

/// Order bloc
class OrderBloc extends Bloc<OrderBlocEvent, BlocState> {
  // For getting data from db
  Establishment _establishment;
  String _tableId;
  Order<MenuItem> _order;
  PaymentMethod _paymentMethod;

  final Api.Tablething _api = Api.Tablething();

  @override
  // Init with null
  BlocState get initialState => LoadingState();

  @override
  Stream<BlocState> mapEventToState(OrderBlocEvent event) async* {
    if (event is GetEstablishmentEvent) {
      yield LoadingState();

      yield* _getEstablishment(event);

      // Init new order when got establishment
      add(
        InitOrderEvent(),
      );
    } else if (event is InitOrderEvent) {
      yield* _initOrder(event);
    } else if (event is CreateOrderItemEvent) {
      yield* _createOrderItem(event);
    } else if (event is AddOrderItemEvent) {
      yield* _addOrderItem(event);
    } else if (event is ModifyOrderItemOptionsEvent) {
      yield* _modifyOrderItemOptions(event);
    } else if (event is ForgetOrderItemEvent) {
      yield* _forgetOrderItem(event);
    } else if (event is RequestMenuEvent) {
      yield* _goToMenu(event);
    } else if (event is RequestCheckoutEvent) {
      yield* _goToCheckout(event);
    } else if (event is RemoveOrderItemEvent) {
      yield* _removeOrderItem(event);
    } else if (event is RequestShoppingBasketEvent) {
      yield* _goToShoppingBasket(event);
    } else if (event is ChangePaymentMethod) {
      _paymentMethod = event.paymentMethod;
      yield CheckoutState(_establishment, _order, _tableId);
    }
  }

  /// Gets an establishment and menu
  Stream<OrderBlocState> _getEstablishment(GetEstablishmentEvent event) async* {
    try {
      _establishment = await _api.getEstablishment(event.establishmentId);
      _tableId = event.tableId;

      yield EstablishmentState(_establishment);
    } catch (err) {
      print("Error: " + err.toString());
      yield BlocState.withError(t('An error occurred')) as EstablishmentState;
    }
  }

  /// Initiates a new order
  Stream<OrderBlocState> _initOrder(InitOrderEvent event) async* {
    _order = Order<MenuItem>();
    if (_establishment != null) {
      yield EstablishmentState(_establishment);
    } else {
      yield BlocState.withError(t('An error occurred')) as EstablishmentState;
    }
  }

  /// Transforms a menu item into an order item that is able to have properties
  Stream<OrderBlocState> _createOrderItem(CreateOrderItemEvent event) async* {
    // TODO test this
    if (_order == null || _establishment == null) {
      yield BlocState.withError(t('Order is not initiated')) as OrderItemState;
    }

    OrderItem<MenuItem> orderItem = OrderItem(product: event.menuItem, options: OrderItemOptions(quantity: 1));

    yield OrderItemState(
      _establishment,
      orderItem,
    );
  }

  /// Add order item to order
  Stream<OrderBlocState> _addOrderItem(AddOrderItemEvent event) async* {
    event.orderItem.options = event.orderItemOptions;
    _order.addItem(event.orderItem);

    yield ShoppingBasketState(
      _establishment,
      _order,
      _tableId,
    );
  }

  /// Remove an order item from the order
  Stream<OrderBlocState> _removeOrderItem(RemoveOrderItemEvent event) async* {
    if (event.orderItem == null || _order == null) {
      // TODO error
    }

    bool removed = _order.items.remove(event.orderItem);

    if (!removed) {
      print("Couldn't remove item from order");
    }

    // Go to menu in case of empty order after removal
    if (_order.items.length == 0) {
      yield EstablishmentState(_establishment);
    }

    yield ShoppingBasketState(
      _establishment,
      _order,
      _tableId,
    );
  }

  /// Set new options for an order item
  Stream<OrderBlocState> _modifyOrderItemOptions(ModifyOrderItemOptionsEvent event) async* {
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

    yield ShoppingBasketState(_establishment, _order, _tableId);
  }

  /// Forgets the order item and returns to the last screen
  Stream<OrderBlocState> _forgetOrderItem(ForgetOrderItemEvent event) async* {
    if (_order.containsItem(event.orderItem)) {
      yield ShoppingBasketState(_establishment, _order, _tableId);
    }

    yield EstablishmentState(_establishment);
  }

  Stream<OrderBlocState> _goToMenu(RequestMenuEvent event) async* {
    if (_establishment == null) {
      // TODO error
    }

    yield EstablishmentState(_establishment);
  }

  Stream<OrderBlocState> _goToCheckout(RequestCheckoutEvent event) async* {
    if (_order == null || _establishment == null) {
      // TODO error
    }

    yield CheckoutState(_establishment, event.order, _tableId);
  }

  Stream<OrderBlocState> _goToShoppingBasket(RequestShoppingBasketEvent event) async* {
    if (_order == null || _establishment == null) {
      // TODO error
    }

    yield ShoppingBasketState(_establishment, _order, _tableId);
  }
}
