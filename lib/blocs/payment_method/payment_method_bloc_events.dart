import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/services/stripe/payment_method.dart';
import 'package:tablething/services/tablething/user.dart';

class GetPaymentMethods extends BlocEvent {
  final User user;

  GetPaymentMethods(this.user) : super();
}

class AddPaymentMethod extends BlocEvent {
  AddPaymentMethod() : super();
}

class RemovePaymentMethod extends BlocEvent {
  final PaymentMethod paymentMethod;

  RemovePaymentMethod(this.paymentMethod) : super();
}

class ViewPaymentMethod extends BlocEvent {
  final PaymentMethod paymentMethod;

  ViewPaymentMethod(this.paymentMethod) : super();
}
