abstract class NavigationBlocEvent {}

/// Show QR-scan screen
class ViewQRScan extends NavigationBlocEvent {}

/// Show restaurant screen
class ViewRestaurant extends NavigationBlocEvent {
  String restaurantId;

  ViewRestaurant(this.restaurantId);
}

/// Show profile screen
class ViewProfile extends NavigationBlocEvent {
  String userId;

  ViewProfile(this.userId);
}
