import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tablething/blocs/bloc.dart';
export 'payment_method_bloc_events.dart';
export 'payment_method_bloc_states.dart';

class PaymentMethodBloc extends Bloc<BlocEvent, ProgressBlocState> {
  String _cardNumber;
  int _month;
  int _year;
  String _cvv;

  @override
  ProgressBlocState get initialState {
    return CardNumberState();
  }

  @override
  Stream<ProgressBlocState> mapEventToState(BlocEvent event) async* {
    if (event is InitCard) {
      // TODO delete
    } else if (event is AddCardNumber) {
      _cardNumber = event.cardNumber;
      yield SecurityInfoState();
    } else if (event is AddSecurityInfo) {
      _month = num.parse(event.month);
      _year = num.parse(event.year);
      _cvv = event.cvv;

      yield ApiConnectionState();

      // Send card to API
      // TODO

      () async {
        await Future.delayed(Duration(seconds: 2));
      }();

      yield CardAddedState();
    }
  }
}
