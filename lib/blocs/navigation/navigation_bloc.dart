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
    // Debug
    add(ViewRestaurant('110ec58a-a0f2-4ac4-8393-c866d813b8d1'));
  }

  @override
  Stream<NavigationBlocState> mapEventToState(NavigationBlocEvent event) async* {
    if (event is ViewQRScan) {
      yield QRScanView();
    } else if (event is ViewRestaurant) {
      var combo = await Tablethings.getAll(event.restaurantId);

      yield RestaurantView(combo['restaurant'], combo['menu']);
    }
    /*else if (event is ViewProfile) {
      yield ProfileView();
    }*/
  }
}
