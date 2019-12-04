/// Exports all blocs used in the app
export 'map_bloc.dart';
export 'order/order_bloc.dart';
export 'auth/auth_bloc.dart';
import 'package:tablething/localization/translate.dart';

class BlocEvent {}

class BlocState {
  bool error = false;
  String errorMessage = t('An unknown error occurred');

  BlocState();

  BlocState.withError(errorMessage) {
    this.error = true;
    this.errorMessage = errorMessage;
  }
}
