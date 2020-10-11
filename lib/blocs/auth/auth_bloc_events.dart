abstract class AuthBlocEvent {}

class AuthenticateGuest extends AuthBlocEvent {}

class AuthenticateEmail extends AuthBlocEvent {
  String email;
  String password;

  AuthenticateEmail(this.email, this.password);
}

// TODO auth with google, fb..
