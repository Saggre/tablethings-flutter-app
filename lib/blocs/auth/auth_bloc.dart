import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sprintf/sprintf.dart';
import 'package:tablethings/blocs/auth/auth_bloc_events.dart';
import 'package:tablethings/blocs/auth/auth_bloc_states.dart';
import 'package:tablethings/models/tablethings/user.dart';
import 'package:tablethings/services/tablethings.dart';

class AuthBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  User _currentUser;
  String _token;

  AuthBloc() : super(NoAuth()) {
    add(AuthenticateGuest());
  }

  @override
  Stream<AuthBlocState> mapEventToState(AuthBlocEvent event) async* {
    if (event is AuthenticateGuest) {
      log('Authenticating as a guest');
      try {
        var result = await Tablethings.authGuest();
        _currentUser = result['user'];
        _token = result['token'];

        log('Authenticated as a guest');
        yield GuestAuth(_currentUser, _token);
      } catch (ex) {
        log('Error during guest authentication: ' + ex.toString());
        yield AuthError();
      }
    }
  }
}
