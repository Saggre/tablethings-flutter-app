import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'package:flutter/services.dart';
import 'file:///C:/Users/sakri/Desktop/Repos/Tablething/lib/services/tablething.dart' as Api;
import 'bloc.dart';

class MapBlocEvent extends BlocEvent {}

class GetEstablishmentsEvent extends MapBlocEvent {}

/// Event for when the user moves in physical space
class UserMovedEvent extends MapBlocEvent {
  LatLng userLocation;

  UserMovedEvent(this.userLocation);
}

class MapBlocState extends BlocState {}

class MapLoadingState extends MapBlocState {}

class MapLoadedState extends MapBlocState {
  final List<Establishment> establishments;
  final LatLng _userLocation;

  double get userLatitude => _userLocation.latitude;

  double get userLongitude => _userLocation.longitude;

  MapLoadedState(this.establishments, this._userLocation);
}

class MapErrorState extends MapBlocState {}

/// Bloc for the map screen
class MapBloc extends Bloc<MapBlocEvent, MapBlocState> {
  final Api.Tablething _api = Api.Tablething();
  List<Establishment> _currentEstablishmentsList;
  LatLng _currentUserLocation;
  String _currentError = '';
  final Location _locationService = Location();
  bool _permission = false;
  double _minUpdateDist = 100.0; // Moves to user if GPS update is at least minUpdateDist meters away

  MapBloc() : super(MapLoadingState()) {
    // TODO move when establishments are get in a different way in the future
    add(GetEstablishmentsEvent());

    _initLocationService((LocationData result) {
      add(
        UserMovedEvent(LatLng(result.latitude, result.longitude)),
      );
    });
  }

  @override
  Stream<MapBlocState> mapEventToState(MapBlocEvent event) async* {
    bool sendState = false;

    if (event is GetEstablishmentsEvent) {
      print("Getting establishments");
      try {
        _currentEstablishmentsList = await _api.getEstablishments();
        sendState = true;
      } catch (err) {
        print(err.toString());
      }
    } else if (event is UserMovedEvent) {
      print("User moved");

      if (_currentUserLocation != null) {
        double movedDistance = Distance().distance(_currentUserLocation, event.userLocation).toDouble();
        if (movedDistance > _minUpdateDist) {
          sendState = true;
        }
      } else {
        sendState = true;
      }

      _currentUserLocation = event.userLocation;
    }

    if (_currentError.length > 0) {
      yield BlocState.withError(_currentError) as MapErrorState;
      return;
    }

    if (_currentEstablishmentsList != null && _currentUserLocation != null) {
      if (sendState) {
        yield MapLoadedState(_currentEstablishmentsList, _currentUserLocation);
      }
    } else {
      yield MapLoadingState();
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
          _locationService.onLocationChanged().listen((LocationData result) {
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
        _currentError = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        _currentError = e.message;
      }
      location = null;
    }
  }
}
