import 'package:tablething/blocs/bloc.dart';

class InitCard extends BlocEvent {}

class AddCardNumber extends BlocEvent {
  final String cardNumber;

  AddCardNumber(this.cardNumber);
}

class AddSecurityInfo extends BlocEvent {
  final String month;
  final String year;
  final String cvv;

  AddSecurityInfo(this.month, this.year, this.cvv);
}
