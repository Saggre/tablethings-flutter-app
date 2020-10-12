import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tablethings/blocs/auth/auth_bloc.dart';
import 'package:tablethings/blocs/auth/auth_bloc_events.dart';
import 'package:tablethings/blocs/auth/auth_bloc_states.dart';
import 'package:tablethings/blocs/navigation/navigation_bloc.dart';
import 'package:tablethings/blocs/navigation/navigation_bloc_events.dart';
import 'package:tablethings/blocs/navigation/navigation_bloc_states.dart';
import 'package:tablethings/blocs/navigation/view_types.dart';

class AuthScreen extends StatelessWidget {
  Map<String, TextEditingController> _fieldControllers;

  AuthScreen() {
    _fieldControllers = {
      'email': TextEditingController(),
      'password': TextEditingController(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationBlocState>(
      builder: (context, navState) {
        if (navState is AuthView) {
          return BlocConsumer<AuthBloc, AuthBlocState>(
            listener: (context, state) {
              // Navigate to next screen if we have the required auth level
              if (state.authLevel >= navState.requiredAuthLevel) {
                BlocProvider.of<NavigationBloc>(context).add(navState.nextScreen);
              }
            },
            builder: (context, authState) {
              if (navState.authViewType == AuthViewType.login) {
                // Login
                return Column(
                  children: [
                    TextField(
                      controller: _fieldControllers['email'],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                    TextField(
                      controller: _fieldControllers['password'],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context).add(AuthenticateEmail(_fieldControllers['email'].text, _fieldControllers['password'].text));
                      },
                      child: Text('Login'),
                    ),
                    RaisedButton(
                      onPressed: () {
                        BlocProvider.of<NavigationBloc>(context).add(ViewAuth(navState.requiredAuthLevel, navState.nextScreen, AuthViewType.register));
                      },
                      child: Text('Register instead'),
                    )
                  ],
                );
              } else if (navState.authViewType == AuthViewType.register) {
                // Register
                return Column(
                  children: [
                    TextField(
                      controller: _fieldControllers['email'],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                    TextField(
                      controller: _fieldControllers['password'],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        BlocProvider.of<AuthBloc>(context).add(RegisterEmail(_fieldControllers['email'].text, _fieldControllers['password'].text));
                      },
                      child: Text('Register'),
                    ),
                    RaisedButton(
                      onPressed: () {
                        BlocProvider.of<NavigationBloc>(context).add(ViewAuth(navState.requiredAuthLevel, navState.nextScreen));
                      },
                      child: Text('Login instead'),
                    )
                  ],
                );
              }

              return Text('Error');
            },
          );
        } else {
          return Text('Error');
        }
      },
    );
  }
}
