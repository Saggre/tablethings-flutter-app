abstract class NavigationBlocEvent {}

/// Show QR-scan screen
class ViewQRScan extends NavigationBlocEvent {}

/// Show restaurant screen
class ViewRestaurant extends NavigationBlocEvent {}

/// Show profile screen
class ViewProfile extends NavigationBlocEvent {}

/// View cart
class ViewCart extends NavigationBlocEvent {}

/// View checkout
class ViewCheckout extends NavigationBlocEvent {}

/// View payment methods
abstract class ViewPaymentMethods extends NavigationBlocEvent {}

/// Form to add a new payment method
class ViewAddPaymentMethod extends ViewPaymentMethods {}

/// General payment methods view
class ViewBrowsePaymentMethods extends ViewPaymentMethods {}

/// View auth
abstract class ViewAuth extends NavigationBlocEvent {
  final int requiredAuthLevel;
  final NavigationBlocEvent nextScreen;

  ViewAuth(this.requiredAuthLevel, this.nextScreen);
}

/// View login
class ViewLoginAuth extends ViewAuth {
  ViewLoginAuth(requiredAuthLevel, nextScreen) : super(requiredAuthLevel, nextScreen);
}

/// View registration
class ViewRegisterAuth extends ViewAuth {
  ViewRegisterAuth(requiredAuthLevel, nextScreen) : super(requiredAuthLevel, nextScreen);
}
