/// Abstract class for a product that is orderable through an Order object
abstract class Product {
  final String _id;
  final String _name;
  final int _price;

  Product(this._id, this._name, this._price);

  int get price => _price;

  String get name => _name;

  String get id => _id;
}
