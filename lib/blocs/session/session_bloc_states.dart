import 'package:tablethings/models/tablethings/restaurant/menu/menu.dart';
import 'package:tablethings/models/tablethings/restaurant/restaurant.dart';

abstract class SessionBlocState {}

/// User not present
class NotPresent extends SessionBlocState {}

/// User is physically present at a restaurant
class PhysicallyPresent extends SessionBlocState {
  Restaurant restaurant;
  Menu menu;
  String tableId;

  PhysicallyPresent(this.restaurant, this.menu, this.tableId);
}

// TODO not physically present state
