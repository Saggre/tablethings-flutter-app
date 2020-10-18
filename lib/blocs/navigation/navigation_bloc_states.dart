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

/// View payment methods
abstract class PaymentMethodsView extends NavigationBlocState {}

/// Form to add a new payment method
class AddPaymentMethodView extends PaymentMethodsView {}

/// General payment methods view
class BrowsePaymentMethodsView extends PaymentMethodsView {}

/// Show auth screen
class AuthView extends NavigationBlocState {
  final int requiredAuthLevel;
  final NavigationBlocEvent nextScreen;

  AuthView(this.requiredAuthLevel, this.nextScreen);
}

/// Show registration screen
class LoginAuthView extends AuthView {
  LoginAuthView(requiredAuthLevel, nextScreen) : super(requiredAuthLevel, nextScreen);
}

/// Show login screen
class RegisterAuthView extends AuthView {
  RegisterAuthView(requiredAuthLevel, nextScreen) : super(requiredAuthLevel, nextScreen);
}
