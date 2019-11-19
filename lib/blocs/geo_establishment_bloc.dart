import 'dart:async';
import 'establishment_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:latlong/latlong.dart';
import 'package:tablething/services/api_client_selector.dart';
import 'package:tablething/models/establishment/establishment.dart';

class GeoEstablishmentBlocEvent extends EstablishmentBlocEvent {
  // The bounds which limit the number of establishments to fetch
  LatLng northEastBound;
  LatLng southWestBound;

  GeoEstablishmentBlocEvent(this.northEastBound, this.southWestBound);
}

class GeoEstablishmentBlocState extends EstablishmentBlocState {
  List<Establishment> establishments;

  GeoEstablishmentBlocState(this.establishments);
}

/// Creates events from user movement in real world
/// Bloc<Event, State>
class GeoEstablishmentBloc extends Bloc<GeoEstablishmentBlocEvent, GeoEstablishmentBlocState> {
  ApiClient apiClient = ApiClient();

  UserLocationBloc() {
    // TODO debug
  }

  @override
  // Init with empty list
  GeoEstablishmentBlocState get initialState => GeoEstablishmentBlocState(List<Establishment>());

  @override
  Stream<GeoEstablishmentBlocState> mapEventToState(GeoEstablishmentBlocEvent event) async* {
    // Get establishments inside bounds from database and return state
    List<Establishment> establishments = await apiClient.getEstablishments();
    yield GeoEstablishmentBlocState(establishments);
  }
}
