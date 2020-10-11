import 'package:tablethings/blocs/navigation/view_types.dart';

abstract class NavigationBlocEvent {}

/// Show QR-scan screen
class ViewQRScan extends NavigationBlocEvent {}

/// Show restaurant screen
class ViewRestaurant extends NavigationBlocEvent {}

/// Show profile screen
class ViewProfile extends NavigationBlocEvent {}

// View cart
class ViewCart extends NavigationBlocEvent {}

// View checkout
class ViewCheckout extends NavigationBlocEvent {}

// View auth
class ViewAuth extends NavigationBlocEvent {
  final AuthViewType authViewType;
  final int requiredAuthLevel;
  final NavigationBlocEvent nextScreen;

  ViewAuth(this.requiredAuthLevel, this.nextScreen, [this.authViewType = AuthViewType.login]);
}
