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
import 'package:tablethings/blocs/session/session_bloc.dart';
import 'package:tablethings/blocs/session/session_bloc_events.dart';
import 'package:tablethings/screens/restaurant/restaurant_screen.dart';
import 'cart/cart_screen.dart';
import 'checkout/checkout_screen.dart';
import 'qr_scan/qr_scan_screen.dart';

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
                context.bloc<SessionBloc>().add(SetScannedRestaurant(result.barcode.restaurantId, result.barcode.tableId));
                context.bloc<NavigationBloc>().add(ViewRestaurant());
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
                } else if (state is CartView) {
                  return 'Cart';
                } else if (state is CheckoutView) {
                  return 'Checkout';
                }

                return '';
              }()),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.gradient),
                  title: Text('Scan'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.restaurant_menu),
                  title: Text('Menu'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  title: Text('Cart'),
                ),
              ],
              currentIndex: 0,
              selectedItemColor: Colors.amber[800],
              onTap: (int index) {
                if (index != 0) {
                  context.bloc<QRScanBloc>().add(StopScanning());
                }

                if (index == 0) {
                  context.bloc<QRScanBloc>().add(StartScanning());
                  context.bloc<NavigationBloc>().add(ViewQRScan());
                } else if (index == 1) {
                  context.bloc<NavigationBloc>().add(ViewRestaurant());
                } else if (index == 2) {
                  context.bloc<NavigationBloc>().add(ViewCart());
                }
              },
            ),
            body: Stack(
              children: [
                () {
                  if (state is QRScanView) {
                    return QRScanScreen();
                  } else if (state is RestaurantView) {
                    return RestaurantScreen();
                  } else if (state is CartView) {
                    return CartScreen();
                  } else if (state is CheckoutView) {
                    return CheckoutScreen();
                  }

                  // TODO profile screen

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
