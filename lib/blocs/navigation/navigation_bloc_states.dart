import 'package:tablethings/models/tablethings/restaurant/menu/menu.dart';
import 'package:tablethings/models/tablethings/restaurant/restaurant.dart';
import 'package:tablethings/models/tablethings/user.dart';

abstract class NavigationBlocState {}

/// Show QR-scan screen
class QRScanView extends NavigationBlocState {}

/// Show restaurant screen
class RestaurantView extends NavigationBlocState {
  Restaurant restaurant;
  Menu menu;

  RestaurantView(this.restaurant, this.menu);
}

/// Show profile screen
class ProfileView extends NavigationBlocState {
  User user;

  ProfileView(this.user);
}
