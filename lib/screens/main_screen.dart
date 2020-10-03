import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tablethings/blocs/auth/auth_bloc.dart';
import 'package:tablethings/blocs/auth/auth_bloc_states.dart';
import 'qr_scan/qr_scan_screen.dart';

/// Main screen that acts as a parent to other screens (and animates their transitions?)
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.add)),
                Tab(icon: Icon(Icons.restaurant)),
                Tab(icon: Icon(Icons.person)),
              ],
            ),
          ),
          body: Stack(
            children: [
              QRScanScreen(),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Row(
                  // For debug
                  children: [
                    BlocBuilder<AuthBloc, AuthBlocState>(builder: (context, state) {
                      if (state is NoAuth) {
                        if (state is AuthError) {
                          return Text('Auth error');
                        }

                        return Text('Not authenticated');
                      } else if (state is GuestAuth) {
                        return Text('Guest authenticated');
                      }

                      return Text('Other auth');
                    }),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
