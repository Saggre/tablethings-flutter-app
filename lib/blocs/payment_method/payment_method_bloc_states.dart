import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/services/stripe/payment_method.dart';

class CardNumberState extends ProgressBlocState {
  CardNumberState() {
    progress = 0.0;
  }

  @override
  String toString() {
    return t('Add a card number');
  }
}

class SecurityInfoState extends ProgressBlocState {
  SecurityInfoState() {
    progress = 0.33;
  }

  @override
  String toString() {
    return t('Add security information');
  }
}

class ApiConnectionState extends ProgressBlocState {
  ApiConnectionState() {
    progress = 0.66;
  }

  @override
  String toString() {
    return t('Sending card');
  }
}

class CardAddedState extends ProgressBlocState {
  final PaymentMethod paymentMethod;

  CardAddedState(this.paymentMethod) {
    progress = 1.0;
  }

  @override
  String toString() {
    return t('Card successfully added');
  }
}
