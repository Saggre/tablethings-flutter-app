import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/services/stripe/payment_method.dart';
import 'package:tablething/services/stripe/stripe.dart';
export 'payment_method_bloc_events.dart';
export 'payment_method_bloc_states.dart';

class PaymentMethodBloc extends Bloc<BlocEvent, ProgressBlocState> {
  final AuthBloc _authBloc;
  final Stripe _stripe = Stripe();

  String _cardNumber;
  int _month;
  int _year;
  String _cvv;

  PaymentMethodBloc(this._authBloc);

  @override
  ProgressBlocState get initialState {
    return CardNumberState();
  }

  @override
  Stream<ProgressBlocState> mapEventToState(BlocEvent event) async* {
    if (event is InitCard) {
      _cardNumber = null;
      _month = null;
      _year = null;
      _cvv = null;
      yield CardNumberState();
    } else if (event is AddCardNumber) {
      _cardNumber = event.cardNumber;
      yield SecurityInfoState();
    } else if (event is AddSecurityInfo) {
      try {
        _month = int.parse(event.month.toString());
        _year = int.parse(event.year.toString());
        _cvv = event.cvv;

        yield ApiConnectionState();

        // Send card to API

        PaymentMethod paymentMethod = await _stripe.addPaymentMethod(_authBloc.currentUser.stripeCustomer.id, _cardNumber, _month, _year, _cvv);
        /*_authBloc.currentUser.paymentMethods.then((value) {
          value.add(paymentMethod);
        });*/
        _authBloc.refreshPaymentMethods();

        yield CardAddedState(paymentMethod);
      } catch (err) {
        print(err.toString());
        yield () {
          var state = ProgressBlocState();
          state.error = true;
          state.errorMessage = 'Error adding card';
          return state;
        }();
      }
    }
  }
}
