import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tablething/blocs/bloc.dart';
import 'payment_method_bloc_events.dart';
import 'payment_method_bloc_states.dart';
export 'payment_method_bloc_events.dart';
export 'payment_method_bloc_states.dart';

class PaymentMethodBloc extends Bloc<BlocEvent, BlocState> {
  @override
  // Init with empty list
  BlocState get initialState {
    return BlocState();
  }

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {}
}
