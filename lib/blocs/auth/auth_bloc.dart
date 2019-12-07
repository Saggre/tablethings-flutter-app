import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tablething/services/tablething/user.dart';
import 'auth_bloc_states.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:tablething/services/tablething/tablething.dart' as Api;

class AuthBlocEvent extends BlocEvent {}

class AppStartedEvent extends AuthBlocEvent {}

class GoogleLoginEvent extends AuthBlocEvent {}

class FacebookLoginEvent extends AuthBlocEvent {}

class AuthBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  final GoogleSignIn _google = GoogleSignIn();
  final FacebookLogin _facebook = FacebookLogin();
  final Api.Tablething _api = Api.Tablething();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _currentFirebaseUser;
  User _currentUser;

  @override
  AuthBlocState get initialState => AuthBlocState();

  @override
  Stream<AuthBlocState> mapEventToState(AuthBlocEvent event) async* {
    if (event is GoogleLoginEvent) {
      _currentFirebaseUser = await _googleSignIn().catchError((e) {
        // TODO error
        print("Error signing in with Google");
      });

      _signedIn(_currentFirebaseUser);

      print("Signed in with Google");
    } else if (event is FacebookLoginEvent) {
      _currentFirebaseUser = await _facebookSignIn().catchError((e) {
        // TODO error
        print("Error signing in with Facebook");
      });

      _signedIn(_currentFirebaseUser);

      print("Signed in with Facebook");
    }
  }

  void _signedIn(FirebaseUser firebaseUser) async {
    _currentUser = await _api.getUser(firebaseUser.uid);
    print(_currentUser.toJson().toString());
  }

  Future<FirebaseUser> _googleSignIn() async {
    final GoogleSignInAccount googleUser = await _google.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }

  Future<FirebaseUser> _facebookSignIn() async {
    final FacebookLoginResult result = await _facebook.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: result.accessToken.token);

        final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

        print("signed in " + user.displayName);
        return user;

        break;
      case FacebookLoginStatus.cancelledByUser:
        print("cancelled by user");
        throw Error();
        break;
      case FacebookLoginStatus.error:
        print("login error");
        throw Error();
        break;
    }
  }

  Future _credentialsSignIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future _credentialsRegistration({String email, String password}) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future _signOut() async {
    return Future.wait([
      _auth.signOut(),
      _google.signOut(),
      _facebook.logOut(),
    ]);
  }

  Future<bool> _isSignedIn() async {
    final currentUser = await _auth.currentUser();
    return currentUser != null;
  }

  Future<String> _getUser() async {
    return (await _auth.currentUser()).email;
  }
}
