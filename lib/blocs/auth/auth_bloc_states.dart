import 'package:camera/camera.dart';
import 'package:tablethings/models/tablethings/tablethings_error.dart';
import 'package:tablethings/models/tablethings/user.dart';

import 'auth_levels.dart';

abstract class AuthBlocState {
  final int authLevel;

  AuthBlocState(this.authLevel);
}

/// No authentication
class NoAuth extends AuthBlocState {
  NoAuth() : super(AuthLevel.noAuth);
}

/// When an exception occurs during auth and it can be caught
class AuthException extends NoAuth {
  final int errorCode;
  final List<TablethingsError> errors;

  AuthException(this.errorCode, this.errors);
}

/// When an error that can't be caught occurs during authentication
class AuthError extends NoAuth {}

class Authenticated extends AuthBlocState {
  final User currentUser;
  final String token;

  Authenticated(authLevel, this.currentUser, this.token) : super(authLevel);
}

/// Authenticated as a guest
/// Means there is a saved token for making reguests
/// But it's not associated with any account
class GuestAuth extends Authenticated {
  GuestAuth(User currentUser, String token) : super(AuthLevel.guestAuth, currentUser, token);
}

/// Authenticated
class EmailAuth extends Authenticated {
  EmailAuth(User currentUser, String token) : super(AuthLevel.normalAuth, currentUser, token);
}
