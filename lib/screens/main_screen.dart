import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tablethings/blocs/auth/auth_bloc.dart';
import 'package:tablethings/blocs/auth/auth_bloc_states.dart';
import 'package:tablethings/blocs/navigation/navigation_bloc.dart';
import 'package:tablethings/blocs/navigation/navigation_bloc_events.dart';
import 'package:tablethings/blocs/navigation/navigation_bloc_states.dart';
import 'package:tablethings/blocs/qr_scan/qr_scan_bloc.dart';
import 'package:tablethings/blocs/qr_scan/qr_scan_bloc_events.dart';
import 'package:tablethings/blocs/qr_scan/qr_scan_bloc_states.dart';
import 'package:tablethings/blocs/qr_scan/qr_scan_result.dart';
import 'package:tablethings/screens/restaurant/restaurant_screen.dart';
import 'qr_scan/qr_scan_screen.dart';

/*
tabs: [
                Tab(icon: Icon(Icons.add)),
                Tab(icon: Icon(Icons.restaurant)),
                Tab(icon: Icon(Icons.person)),
              ],
 */

/// Main screen that acts as a parent to other screens (and animates their transitions?)
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<QRScanBloc, QRScanBlocState>(
          listener: (context, state) {
            if (state is Scanned) {
              var result = state.scanResult;
              if (result is TablethingsQRResult) {
                context.bloc<QRScanBloc>().add(StopScanning());
                context.bloc<NavigationBloc>().add(ViewRestaurant(result.barcode.restaurantId));
              }
            }
          },
        ),
        BlocListener<AuthBloc, AuthBlocState>(
          listener: (context, state) {},
        ),
        BlocListener<NavigationBloc, NavigationBlocState>(
          listener: (context, state) {},
        ),
      ],
      child: BlocBuilder<NavigationBloc, NavigationBlocState>(builder: (context, state) {
        return AnimatedSwitcher(
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.25),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          duration: Duration(milliseconds: 250),
          child: Scaffold(
            appBar: AppBar(
              title: Text(() {
                if (state is QRScanView) {
                  return 'QR Scan';
                } else if (state is RestaurantView) {
                  return 'Restaurant';
                } else if (state is ProfileView) {
                  return 'My profile';
                }

                return '';
              }()),
            ),
            body: Stack(
              children: [
                () {
                  if (state is QRScanView) {
                    return QRScanScreen();
                  } else if (state is RestaurantView) {
                    return RestaurantScreen(state.restaurant, state.menu);
                  }

                  return Text('Wtf happen :D');
                }(),
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
                          return Text('Guest authenticated: ' + state.currentUser.username);
                        }

                        return Text('Other auth');
                      }),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
