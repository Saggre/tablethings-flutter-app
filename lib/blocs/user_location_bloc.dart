import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

/// startGPS starts tracking
enum UserLocationEvent { startGPS, moved }

/// Creates events from user movement in real world
/// Bloc<Event, State>
class UserLocationBloc extends Bloc<UserLocationEvent, LatLng> {
  var _location = Location();
  StreamSubscription _subscription;

  UserLocationBloc() {
    // TODO debug
  }

  @override
  LatLng get initialState => LatLng(0, 0);

  @override
  Stream<LatLng> mapEventToState(UserLocationEvent event) async* {
    if (event == UserLocationEvent.startGPS) {
      // Cancel old subscription
      _subscription?.cancel();
      _subscription = _location.onLocationChanged().listen((LocationData event) {
        // Call moved event whenever location changes
        add(UserLocationEvent.moved);
      });

      // Send move event immediately to refresh coordinates
      add(UserLocationEvent.moved);
    }

    if (event == UserLocationEvent.moved) {
      // Get current location on moved event
      LocationData locationData = await _location.getLocation();
      yield LatLng(locationData.latitude, locationData.longitude);
    }
  }
}
