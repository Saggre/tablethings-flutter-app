import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tablething/localization/translate.dart';
import 'package:tablething/services/stripe/stripe.dart';
import 'package:tablething/services/tablething/user.dart';
import 'auth_bloc_states.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:tablething/services/tablething/tablething.dart' as Api;

class AppStartedEvent extends BlocEvent {}

class GoogleLoginEvent extends BlocEvent {}

class FacebookLoginEvent extends BlocEvent {}

class AuthBloc extends Bloc<BlocEvent, BlocState> {
  final GoogleSignIn _google = GoogleSignIn();
  final FacebookLogin _facebook = FacebookLogin();
  final Api.Tablething _api = Api.Tablething();
  final Stripe _stripe = Stripe();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _currentFirebaseUser;
  User _currentUser;

  User get currentUser => _currentUser;

  @override
  BlocState get initialState => Unauthenticated();

  void refreshPaymentMethods() {
    _currentUser.paymentMethods = _stripe.getPaymentMethods(_currentUser.stripeCustomer.id, 'card');
  }

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* {
    try {
      if (event is GoogleLoginEvent) {
        yield Authenticating();

        _currentFirebaseUser = await _googleSignIn().catchError((e) {
          // TODO error
          print("Error signing in with Google");
        });

        _currentUser = await _api.getUser(_currentFirebaseUser.uid);

        // Get user payment methods
        _currentUser.paymentMethods = _stripe.getPaymentMethods(_currentUser.stripeCustomer.id, 'card');

        print("Signed in " + _currentUser.displayName + " with Google");

        yield Authenticated(_currentUser);
      } else if (event is FacebookLoginEvent) {
        yield Authenticating();

        _currentFirebaseUser = await _facebookSignIn().catchError((e) {
          // TODO error
          print("Error signing in with Facebook");
        });

        _currentUser = await _api.getUser(_currentFirebaseUser.uid);

        // Get user payment methods
        _currentUser.paymentMethods = _stripe.getPaymentMethods(_currentUser.stripeCustomer.id, 'card');

        print("Signed in " + _currentUser.displayName + " with Facebook");

        yield Authenticated(_currentUser);
      }
    } catch (err) {
      print(err.toString());
      yield () {
        var state = Unauthenticated();
        state.error = true;
        state.errorMessage = t('Could not sign in. An unknown error occurred');
        return state;
      }();
    }
  }

  Future<FirebaseUser> _googleSignIn() async {
    final GoogleSignInAccount googleUser = await _google.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    return user;
  }

  Future<FirebaseUser> _facebookSignIn() async {
    FirebaseUser user;

    final FacebookLoginResult result = await _facebook.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: result.accessToken.token);

        user = (await _auth.signInWithCredential(credential)).user;

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

    return user;
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
