import 'package:camera/camera.dart';
import 'package:tablethings/models/tablethings/user.dart';

abstract class AuthBlocState {}

/// No authentication
class NoAuth extends AuthBlocState {}

/// When an error occurs during authentication
class AuthError extends NoAuth {}

class Authenticated extends AuthBlocState {
  User currentUser;
  String token;

  Authenticated(this.currentUser, this.token);
}

/// Authenticated as a guest
/// Means there is a saved token for making reguests
/// But it's not associated with any account
class GuestAuth extends Authenticated {
  GuestAuth(User currentUser, String token) : super(currentUser, token);
}

/// Authenticated
class RegularAuth extends Authenticated {
  RegularAuth(User currentUser, String token) : super(currentUser, token);
}
