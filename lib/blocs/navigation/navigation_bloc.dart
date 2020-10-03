import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sprintf/sprintf.dart';
import 'package:tablethings/models/tablethings/restaurant/restaurant.dart';
import 'package:tablethings/models/tablethings/user.dart';
import 'package:tablethings/services/tablethings.dart';

import 'navigation_bloc_events.dart';
import 'navigation_bloc_states.dart';

class NavigationBloc extends Bloc<NavigationBlocEvent, NavigationBlocState> {
  User _currentUser;
  String _token;

  NavigationBloc() : super(QRScanView()) {
    //add(AuthenticateGuest());
  }

  @override
  Stream<NavigationBlocState> mapEventToState(NavigationBlocEvent event) async* {
    if (event is ViewQRScan) {
      yield QRScanView();
    } else if (event is ViewRestaurant) {
      Restaurant restaurant = await Tablethings.getRestaurant(event.restaurantId);

      yield RestaurantView(restaurant);
    }
    /*else if (event is ViewProfile) {
      yield ProfileView();
    }*/
  }
}
