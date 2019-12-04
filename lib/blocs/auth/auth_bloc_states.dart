import 'package:tablething/blocs/bloc.dart';

class AuthBlocState extends BlocState {}

class Uninitialized extends AuthBlocState {
  @override
  String toString() => 'Uninitialized';
}

class Authenticated extends AuthBlocState {
  final String displayName;

  Authenticated(this.displayName) : super();

  @override
  String toString() => 'Authenticated { displayName: $displayName }';
}

class Unauthenticated extends AuthBlocState {
  @override
  String toString() => 'Unauthenticated';
}
