/// RestaurantId is RFC4122 v4
/// TableId is just a number
class Barcode {
  final String restaurantId;
  final String tableId;

  Barcode(this.restaurantId, this.tableId);
}
