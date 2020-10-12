abstract class AuthBlocEvent {
  int retryCount;
  int maxRetries;

  AuthBlocEvent([this.maxRetries = 0]) {
    retryCount = 0;
  }
}

/// Auth as guest
class AuthenticateGuest extends AuthBlocEvent {
  AuthenticateGuest() : super(4);
}

/// Login with email
class AuthenticateEmail extends AuthBlocEvent {
  String email;
  String password;

  AuthenticateEmail(
    this.email,
    this.password,
  ) : super(0);
}

/// Create new account with email
class RegisterEmail extends AuthBlocEvent {
  String email;
  String password;

  RegisterEmail(this.email, this.password) : super(0);
}

// TODO auth with google, fb..
