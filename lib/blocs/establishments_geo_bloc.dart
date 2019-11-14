import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:latlong/latlong.dart';
import 'package:tablething/services/fake_api_client.dart';
import 'package:tablething/services/establishment.dart';

class EstablishmentsGeoBlocEvent {
  // The bounds which limit the number of establishments to fetch
  LatLng northEastBound;
  LatLng southWestBound;

  EstablishmentsGeoBlocEvent(this.northEastBound, this.southWestBound);
}

class EstablishmentsGeoBlocState {
  List<Establishment> establishments;

  EstablishmentsGeoBlocState(this.establishments);
}

/// Creates events from user movement in real world
/// Bloc<Event, State>
class EstablishmentsGeoBloc extends Bloc<EstablishmentsGeoBlocEvent, EstablishmentsGeoBlocState> {
  ApiClient apiClient = ApiClient();

  UserLocationBloc() {
    // TODO debug
  }

  @override
  // Init with empty list
  EstablishmentsGeoBlocState get initialState => EstablishmentsGeoBlocState(List<Establishment>());

  @override
  Stream<EstablishmentsGeoBlocState> mapEventToState(EstablishmentsGeoBlocEvent event) async* {
    // Get establishments inside bounds from database and return state
    List<Establishment> establishments = await apiClient.getEstablishments();
    yield EstablishmentsGeoBlocState(establishments);
  }
}
