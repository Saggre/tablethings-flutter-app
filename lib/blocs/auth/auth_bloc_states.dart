import 'package:camera/camera.dart';
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

/// When an error occurs during authentication
class AuthError extends NoAuth {
  int errorCode;
  List<String> errorMessages;
}

class Authenticated extends AuthBlocState {
  User currentUser;
  String token;

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
