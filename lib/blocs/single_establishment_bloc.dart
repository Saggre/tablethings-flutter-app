import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tablething/services/api_client_selector.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'establishment_bloc.dart';

class SingleEstablishmentBlocEvent extends EstablishmentBlocEvent {
  String establishmentId;

  SingleEstablishmentBlocEvent(this.establishmentId);
}

class SingleEstablishmentBlocState extends EstablishmentBlocState {
  Establishment establishment;

  SingleEstablishmentBlocState(this.establishment);
}

class SingleEstablishmentBloc extends Bloc<SingleEstablishmentBlocEvent, SingleEstablishmentBlocState> {
  ApiClient apiClient = ApiClient();

  UserLocationBloc() {
    // TODO debug
  }

  @override
  // Init with null
  SingleEstablishmentBlocState get initialState => SingleEstablishmentBlocState(null);

  @override
  Stream<SingleEstablishmentBlocState> mapEventToState(SingleEstablishmentBlocEvent event) async* {
    Establishment establishment = await apiClient.getEstablishment(event.establishmentId);
    yield SingleEstablishmentBlocState(establishment);
  }
}
