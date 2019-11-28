import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tablething/models/fetchable_package.dart';
import 'package:tablething/services/api_client_selector.dart';
import 'package:tablething/models/establishment/establishment.dart';

class EstablishmentBlocEvent {}

class EstablishmentBlocState {}

class SingleEstablishmentBlocEvent extends EstablishmentBlocEvent {
  FetchablePackage<String, Establishment> establishmentPackage;

  SingleEstablishmentBlocEvent(this.establishmentPackage);
}

class SingleEstablishmentBlocState extends EstablishmentBlocState {
  Establishment establishment;

  SingleEstablishmentBlocState(this.establishment);
}

class EstablishmentBloc extends Bloc<EstablishmentBlocEvent, EstablishmentBlocState> {
  ApiClient apiClient = ApiClient();

  @override
  // Init with null
  SingleEstablishmentBlocState get initialState => SingleEstablishmentBlocState(null);

  @override
  Stream<EstablishmentBlocState> mapEventToState(EstablishmentBlocEvent event) async* {
    print("Establishment bloc");
    Establishment establishment;

    if (event is SingleEstablishmentBlocEvent) {
      // If already fetched from db
      if (event.establishmentPackage.fetchState == FetchState.fetched) {
        establishment = event.establishmentPackage.getData();
      } else {
        establishment = await apiClient.getEstablishment(event.establishmentPackage.getFetchId());
        print(establishment.name);
      }
    }

    yield SingleEstablishmentBlocState(establishment);
  }
}
