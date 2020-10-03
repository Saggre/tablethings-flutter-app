abstract class AuthBlocEvent {}

class AuthenticateGuest extends AuthBlocEvent {}

class AuthenticateUsername extends AuthBlocEvent {
  String username;
  String password;

  AuthenticateUsername(this.username, this.password);
}

// TODO auth with google, fb..
