import 'package:tablething/blocs/bloc.dart';
import 'package:tablething/services/tablething/user.dart';

class Uninitialized extends BlocState {
  @override
  String toString() => 'Uninitialized';
}

class Authenticated extends BlocState {
  final User user;

  Authenticated(this.user) : super();

  @override
  String toString() => 'Authenticated ' + user.displayName;
}

class Unauthenticated extends BlocState {
  @override
  String toString() => 'Unauthenticated';
}
