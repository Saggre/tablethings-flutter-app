import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/models/establishment/menu/menu_item.dart';
import 'package:tablething/models/establishment/order/order_item.dart';
import 'package:tablething/models/fetchable_package.dart';
import 'package:tablething/models/establishment/order/order.dart';
import 'package:tablething/services/api_client_selector.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'order_bloc_states.dart';
import 'order_bloc_events.dart';

/// Order bloc
class OrderBloc extends Bloc<OrderBlocEvent, OrderBlocState> {
  // For getting data from db
  ApiClient _apiClient = ApiClient();
  Establishment _establishment;
  Order<MenuItem> _order;

  @override
  // Init with null
  EstablishmentState get initialState => EstablishmentState(null);

  @override
  Stream<OrderBlocState> mapEventToState(OrderBlocEvent event) async* {
    if (event is GetEstablishmentEvent) {
      yield await _getEstablishment(event);

      // Init new order when got establishment
      add(
        InitOrderEvent(),
      );
    } else if (event is InitOrderEvent) {
      yield await _initOrder(event);
    } else if (event is AddOrderItemEvent) {
      yield await _addItemToOrder(event);
    } else if (event is ModifyOrderItemOptionsEvent) {
      yield await _modifyOrderItemOptions(event);
    }
  }

  /// Gets an establishment
  Future<OrderBlocState> _getEstablishment(GetEstablishmentEvent event) async {
    try {
      // If already fetched from db
      if (event.establishmentPackage.fetchState == FetchState.fetched) {
        _establishment = event.establishmentPackage.getData();
      } else {
        _establishment = await _apiClient.getEstablishment(event.establishmentPackage.getFetchId());
      }

      return EstablishmentState(_establishment);
    } catch (err) {
      print("Error: " + err.toString());
      return () {
        var state = EstablishmentState(null);
        state.error = true;
        return state;
      }();
    }
  }

  /// Initiates a new order
  Future<OrderBlocState> _initOrder(InitOrderEvent event) async {
    _order = Order<MenuItem>();
    if (_establishment != null) {
      return EstablishmentState(_establishment);
    } else {
      return () {
        var state = EstablishmentState(null);
        state.error = true;
        return state;
      }();
    }
  }

  /// Transforms a menu item into an order item that is able to have properties
  Future<OrderBlocState> _addItemToOrder(AddOrderItemEvent event) async {
    // TODO test this
    if (_order == null || _establishment == null) {
      return BlocState.withError(t('Order is not initiated')) as OrderItemState;
    }

    OrderItem<MenuItem> orderItem = OrderItem(product: event.menuItem, options: OrderItemOptions(quantity: 1));
    _order.addItem(orderItem);

    return OrderItemState(
      _establishment,
      orderItem,
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

    return ShoppingBasketState(_establishment, _order);
  }
}
