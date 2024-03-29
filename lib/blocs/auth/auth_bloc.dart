import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sprintf/sprintf.dart';
import 'package:tablethings/blocs/auth/auth_bloc_events.dart';
import 'package:tablethings/blocs/auth/auth_bloc_states.dart';
import 'package:tablethings/models/tablethings/user.dart';
import 'package:tablethings/services/exceptions.dart';
import 'package:tablethings/services/tablethings.dart';

class AuthBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  User _currentUser;
  String _token;
  int _authRetryTimeout;

  AuthBloc() : super(NoAuth()) {
    _authRetryTimeout = 1000;
    add(AuthenticateGuest());
  }

  @override
  Stream<AuthBlocState> mapEventToState(AuthBlocEvent event) async* {
    if (event is AuthenticateGuest) {
      // Log in as a guest to perform actions without an account

      try {
        var result = await Tablethings.authGuest();
        _currentUser = result['user'];
        _token = result['token'];

        log('Authenticated as a guest');

        Tablethings.setToken(_token);

        yield GuestAuth(_currentUser, _token);
      } on TablethingsAPIException catch (e) {
        yield AuthException(e.code, e.errors);
      } catch (ex) {
        log('Error during guest authentication: ' + ex.toString());
        _retryAuth(event);
        yield AuthError();
      }
    } else if (event is AuthenticateEmail) {
      // Log in with email

      try {
        var result = await Tablethings.authEmail(event.email, event.password);
        _currentUser = result['user'];
        _token = result['token'];

        log('Authenticated with email');

        Tablethings.setToken(_token);

        yield EmailAuth(_currentUser, _token);
      } on TablethingsAPIException catch (e) {
        yield AuthException(e.code, e.errors);
      } catch (e, s) {
        log('Error during email authentication: ' + e.toString());
        log(s.toString());
        _retryAuth(event);
        yield AuthError();
      }
    } else if (event is RegisterEmail) {
      // Register with email

      try {
        var result = await Tablethings.createUser(event.email, event.password);
        _currentUser = result['user'];
        _token = result['token'];

        log('Created new user with email');

        Tablethings.setToken(_token);

        yield EmailAuth(_currentUser, _token);
      } on TablethingsAPIException catch (e) {
        yield AuthException(e.code, e.errors);
      } catch (e) {
        log('Error during email registration: ' + e.toString());
        _retryAuth(event);
        yield AuthError();
      }
    } else if (event is AddPaymentMethod) {
      // Add a payment method to the logged in user

      if (_currentUser == null || _currentUser.isGuest()) {
        return;
      }

      //Tablethings.
    }
  }

  /// Retry auth after a while
  _retryAuth(AuthBlocEvent event) {
    if (event.retryCount >= event.maxRetries) {
      return;
    }

    event.retryCount++;
    Future.delayed(Duration(milliseconds: _authRetryTimeout), () {
      add(event);
    });
  }
}
