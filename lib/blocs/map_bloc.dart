import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:tablething/services/api_client_selector.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:flutter/services.dart';

class MapBlocEvent {}

/// Event for when user moves the map to a new area
class GeoAreaMapBlocEvent extends MapBlocEvent {
  // The bounds which limit the number of establishments to fetch
  LatLng northEastBound;
  LatLng southWestBound;

  GeoAreaMapBlocEvent(this.northEastBound, this.southWestBound);
}

/// Event for when the user moves in physical space
class UserMovedMapBlocEvent extends MapBlocEvent {}

/// State containing a list of establishments to return
class MapBlocState {
  List<Establishment> establishments;

  MapBlocState(this.establishments);
}

/// Bloc for the map screen
class MapBloc extends Bloc<MapBlocEvent, MapBlocState> {
  ApiClient apiClient = ApiClient();

  Location _locationService = Location();
  bool _permission = false;
  String error;
  StreamSubscription<LocationData> _locationSubscription;

  MapBloc() {
    _initLocationService((LocationData result) {
      add(
        UserMovedMapBlocEvent(),
      );
    });
  }

  @override
  // Init with empty list
  MapBlocState get initialState => MapBlocState(List<Establishment>());

  @override
  Stream<MapBlocState> mapEventToState(MapBlocEvent event) async* {
    // TODO different methods for different states
    // Get establishments inside bounds from database and return state
    List<Establishment> establishments = await apiClient.getEstablishments();
    yield MapBlocState(establishments);
  }

  /// Start gps
  void _initLocationService(Function onLocationChanged) async {
    await _locationService.changeSettings(accuracy: LocationAccuracy.HIGH, interval: 1000);

    LocationData location;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print("Permission: $_permission");
        if (_permission) {
          location = await _locationService.getLocation();
          onLocationChanged(location);
          _locationSubscription = _locationService.onLocationChanged().listen((LocationData result) {
            onLocationChanged(result);
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          // Retry init
          _initLocationService(onLocationChanged);
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      location = null;
    }
  }
}
