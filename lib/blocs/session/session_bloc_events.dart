abstract class SessionBlocEvent {}

/// When a restaurant was scanned and the user is physically present
class SetScannedRestaurant extends SessionBlocEvent {
  final String restaurantId;
  final String tableId;

  SetScannedRestaurant(this.restaurantId, this.tableId);
}

/// When a restaurant was selected from map and the user is not present
class SetFromMapRestaurant extends SessionBlocEvent {
  // TODO
}
