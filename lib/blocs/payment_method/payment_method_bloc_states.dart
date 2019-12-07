import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/services/stripe/payment_method.dart';

class PaymentMethodsOverview extends BlocState {
  final List<PaymentMethod> paymentMethods;

  PaymentMethodsOverview(this.paymentMethods) : super();
}

abstract class AddCardState extends BlocState {}

class CardNumberState extends AddCardState {}

class SecurityInfoState extends AddCardState {}

class ThreeDSecureState extends AddCardState {}

// TODO card added state?
