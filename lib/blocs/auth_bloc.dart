import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tablething/blocs/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthBlocEvent extends BlocEvent {}

class GoogleLoginEvent extends AuthBlocEvent {}

class AuthBlocState extends BlocState {}

class AuthBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  AuthBlocState get initialState => AuthBlocState();

  @override
  Stream<AuthBlocState> mapEventToState(AuthBlocEvent event) async* {
    if (event is GoogleLoginEvent) {
      _handleGoogleSignIn().then((FirebaseUser user) => print(user)).catchError((e) => print(e));
    }
  }

  Future<FirebaseUser> _handleGoogleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }
}
