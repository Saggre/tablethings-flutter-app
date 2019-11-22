import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tablething/models/fetchable_package.dart';
import 'package:tablething/services/api_client_selector.dart';
import 'package:tablething/models/establishment/establishment.dart';
import 'establishment_bloc.dart';

class SingleEstablishmentBlocEvent extends EstablishmentBlocEvent {
  FetchablePackage<String, Establishment> establishmentPackage;

  SingleEstablishmentBlocEvent(this.establishmentPackage);
}

class SingleEstablishmentBlocState extends EstablishmentBlocState {
  Establishment establishment;

  SingleEstablishmentBlocState(this.establishment);
}

class SingleEstablishmentBloc extends Bloc<SingleEstablishmentBlocEvent, SingleEstablishmentBlocState> {
  ApiClient apiClient = ApiClient();

  @override
  // Init with null
  SingleEstablishmentBlocState get initialState => SingleEstablishmentBlocState(null);

  @override
  Stream<SingleEstablishmentBlocState> mapEventToState(SingleEstablishmentBlocEvent event) async* {
    Establishment establishment;

    // If already fetched from db
    if (event.establishmentPackage.fetchState == FetchState.fetched) {
      establishment = event.establishmentPackage.getData();
    } else {
      establishment = await apiClient.getEstablishment(event.establishmentPackage.getFetchId());
    }

    yield SingleEstablishmentBlocState(establishment);
  }
}
