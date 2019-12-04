import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_bloc_states.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class AuthBlocEvent extends BlocEvent {}

class AppStartedEvent extends AuthBlocEvent {}

class GoogleLoginEvent extends AuthBlocEvent {}

class FacebookLoginEvent extends AuthBlocEvent{}

class AuthBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  final GoogleSignIn _google = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  AuthBlocState get initialState => AuthBlocState();

  @override
  Stream<AuthBlocState> mapEventToState(AuthBlocEvent event) async* {
    if (event is GoogleLoginEvent) {
      _googleSignIn().then((FirebaseUser user) => print(user)).catchError((e) => print(e));
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
    print("signed in " + user.displayName);
    return user;
  }

  Future<FirebaseUser> _facevookSignIn() async{
    //final FacebookLoginResult
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
