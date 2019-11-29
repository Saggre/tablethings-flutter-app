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

class EstablishmentEvent extends BlocEvent {}

class EstablishmentState extends BlocState {
  // Send establishment in every event
  final Establishment establishment;

  EstablishmentState(this.establishment);
}

/// Establishment bloc event
class GetEstablishmentEvent extends EstablishmentEvent {
  final FetchablePackage<String, Establishment> establishmentPackage;

  GetEstablishmentEvent(this.establishmentPackage);
}

/// Establishment bloc event
class GetEstablishmentState extends EstablishmentState {
  GetEstablishmentState(establishment) : super(establishment);
}

class EstablishmentWithOrderEvent extends EstablishmentEvent {}

class EstablishmentWithOrderState extends EstablishmentState {
  final Order order;

  EstablishmentWithOrderState(this.order, establishment) : super(establishment);
}

/// Event for creating a new blank order
class InitOrderEvent extends EstablishmentWithOrderEvent {}

/// State from creating a new blank order
class InitOrderState extends EstablishmentWithOrderState {
  InitOrderState({order, establishment}) : super(order, establishment);
}

/// Event for adding a menu item (a product) to the order
class AddItemToOrderEvent extends EstablishmentWithOrderEvent {
  final MenuItem menuItem;

  AddItemToOrderEvent(this.menuItem);
}

/// State from adding a menu item to the order
class AddItemToOrderState extends EstablishmentWithOrderState {
  final OrderItem addedOrderItem;

  AddItemToOrderState({this.addedOrderItem, order, establishment}) : super(order, establishment);
}

/// Order bloc
class OrderBloc extends Bloc<EstablishmentEvent, EstablishmentState> {
  // For getting data from db
  ApiClient _apiClient = ApiClient();
  Establishment _establishment;
  Order _order;

  @override
  // Init with null
  EstablishmentState get initialState => EstablishmentState(null);

  @override
  Stream<EstablishmentState> mapEventToState(EstablishmentEvent event) async* {
    if (event is GetEstablishmentEvent) {
      yield await _getEstablishmentState(event);
    } else if (event is InitOrderEvent) {
      yield await _initOrderState(event);
    } else if (event is AddItemToOrderEvent) {
      yield await _addItemToOrderState(event);
    }
  }

  /// Gets an establishment
  Future<GetEstablishmentState> _getEstablishmentState(GetEstablishmentEvent event) async {
    try {
      // If already fetched from db
      if (event.establishmentPackage.fetchState == FetchState.fetched) {
        _establishment = event.establishmentPackage.getData();
      } else {
        _establishment = await _apiClient.getEstablishment(event.establishmentPackage.getFetchId());
      }

      return GetEstablishmentState(_establishment);
    } catch (err) {
      print("Error: " + err.toString());
      return () {
        var state = GetEstablishmentState(null);
        state.error = true;
        return state;
      }();
    }
  }

  /// Initiates a new order
  Future<InitOrderState> _initOrderState(InitOrderEvent event) async {
    _order = Order();
    if (_establishment != null) {
      return InitOrderState(
        order: _order,
        establishment: _establishment,
      );
    } else {
      return () {
        var state = InitOrderState(
          order: _order,
          establishment: null,
        );
        state.error = true;
        return state;
      }();
    }
  }

  /// Transforms a menu item into an order item that is able to have properties
  Future<AddItemToOrderState> _addItemToOrderState(AddItemToOrderEvent event) async {
    // TODO test this
    if (_order == null || _establishment == null) {
      return BlocState.withError(t('Order is not initiated')) as AddItemToOrderState;
    }

    OrderItem orderItem = OrderItem(event.menuItem);

    return AddItemToOrderState(
      addedOrderItem: orderItem,
      order: _order,
      establishment: _establishment,
    );
  }
}
