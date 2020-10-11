import 'package:tablethings/blocs/navigation/view_types.dart';

import 'navigation_bloc_events.dart';

abstract class NavigationBlocState {}

/// Show QR-scan screen
class QRScanView extends NavigationBlocState {}

/// Show restaurant screen
class RestaurantView extends NavigationBlocState {}

/// Show profile screen
class ProfileView extends NavigationBlocState {}

/// Show cart screen
class CartView extends NavigationBlocState {}

/// Show checkout screen
class CheckoutView extends NavigationBlocState {}

/// Show auth screen
class AuthView extends NavigationBlocState {
  final AuthViewType authViewType;
  final int requiredAuthLevel;
  final NavigationBlocEvent nextScreen;

  AuthView(this.authViewType, this.requiredAuthLevel, this.nextScreen);
}
