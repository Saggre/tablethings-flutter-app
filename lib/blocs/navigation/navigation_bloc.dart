import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigation_bloc_events.dart';
import 'navigation_bloc_states.dart';

class NavigationBloc extends Bloc<NavigationBlocEvent, NavigationBlocState> {
  NavigationBloc() : super(QRScanView());

  @override
  Stream<NavigationBlocState> mapEventToState(NavigationBlocEvent event) async* {
    if (event is ViewQRScan) {
      yield QRScanView();
    } else if (event is ViewRestaurant) {
      yield RestaurantView();
    } else if (event is ViewCart) {
      yield CartView();
    } else if (event is ViewProfile) {
      yield ProfileView();
    } else if (event is ViewCheckout) {
      yield CheckoutView();
    } else if (event is ViewAuth) {
      if (event is ViewLoginAuth) {
        yield LoginAuthView(event.requiredAuthLevel, event.nextScreen);
      } else if (event is ViewRegisterAuth) {
        yield RegisterAuthView(event.requiredAuthLevel, event.nextScreen);
      }
    } else if (event is ViewPaymentMethods) {
      if (event is ViewBrowsePaymentMethods) {
        yield BrowsePaymentMethodsView();
      } else if (event is ViewAddPaymentMethod) {
        yield AddPaymentMethodView();
      }
    }
  }
}
