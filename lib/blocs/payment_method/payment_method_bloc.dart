import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/services/stripe/payment_method.dart';
import 'package:tablething/services/stripe/stripe.dart';
import 'package:tablething/services/tablething/user.dart';
import 'payment_method_bloc_events.dart';
import 'payment_method_bloc_states.dart';
export 'payment_method_bloc_events.dart';
export 'payment_method_bloc_states.dart';

class PaymentMethodBloc extends Bloc<BlocEvent, BlocState> {
  Stripe stripeApi = Stripe();

  @override
  // Init with empty list
  BlocState get initialState {
    return BlocState();
  }

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    if (event is GetPaymentMethods) {
      print('Getting payment methods for user: ' + event.user.displayName);

      if (event.user == null) {
        yield BlocState.withError(t('User not logged in'));
        return;
      }

      try {
        var paymentMethods = await _getPaymentMethodsForUser(event.user);
        yield PaymentMethodsOverview(paymentMethods);
      } catch (err) {
        // TODO error handling
        print(err.toString());
        yield BlocState.withError(t('An unknown error occurred'));
      }
    }
  }

  /// Gets a list of payment methods through stripe api
  Future<List<PaymentMethod>> _getPaymentMethodsForUser(User user) async {
    if (user.stripeCustomerId == null || user.stripeCustomerId.length == 0) {
      throw Exception('No payment processor id');
    }

    return stripeApi.getPaymentMethods(user.stripeCustomerId, 'card');
  }
}
