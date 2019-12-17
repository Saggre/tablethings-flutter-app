import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/services/tablething/user.dart';

class Uninitialized extends BlocState {
  @override
  String toString() => t('Uninitialized');
}

class Authenticating extends BlocState {
  @override
  String toString() => t('Authenticating');
}

class Authenticated extends BlocState {
  final User user;

  Authenticated(this.user) : super();

  @override
  String toString() => t('Authenticated') + ' ' + user.displayName;
}

class Unauthenticated extends BlocState {
  @override
  String toString() => t('Unauthenticated');
}
