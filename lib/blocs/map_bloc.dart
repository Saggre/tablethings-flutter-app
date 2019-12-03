import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:tablething/services/api_client_selector.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:flutter/services.dart';
import 'bloc.dart';

class MapBlocEvent extends BlocEvent {}

/// Event for when user moves the map to a new area
class GeoAreaMapBlocEvent extends MapBlocEvent {
  // The bounds which limit the number of establishments to fetch
  LatLng northEastBound;
  LatLng southWestBound;

  GeoAreaMapBlocEvent(this.northEastBound, this.southWestBound);
}

/// Event for when the user moves in physical space
class UserMovedMapBlocEvent extends MapBlocEvent {
  LatLng userLocation;

  UserMovedMapBlocEvent(this.userLocation);
}

/// State containing a list of establishments to return
class MapBlocState extends BlocState {}

class UserMovedMapBlocState extends MapBlocState {
  LatLng userLocation;

  UserMovedMapBlocState(this.userLocation);
}

class GeoAreaMapBlocState extends MapBlocState {
  List<Establishment> establishments;

  GeoAreaMapBlocState(this.establishments);
}

/// Bloc for the map screen
class MapBloc extends Bloc<MapBlocEvent, MapBlocState> {
  ApiClient apiClient = ApiClient();

  Location _locationService = Location();
  bool _permission = false;
  String error;
  StreamSubscription<LocationData> _locationSubscription;

  MapBloc() {
    print("STARTING");
    _initLocationService((LocationData result) {
      print("GPS moved");
      add(
        UserMovedMapBlocEvent(LatLng(result.latitude, result.longitude)),
      );
    });
  }

  @override
  // Init with empty list
  MapBlocState get initialState => MapBlocState();

  @override
  Stream<MapBlocState> mapEventToState(MapBlocEvent event) async* {
    if (event is UserMovedMapBlocEvent) {
      yield UserMovedMapBlocState(event.userLocation);
    } else if (event is GeoAreaMapBlocEvent) {
      var establishments = await apiClient.getEstablishments();
      yield GeoAreaMapBlocState(establishments);
    } else {
      yield MapBlocState();
    }
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
