import 'menu_item.dart';

/// Represents a category under the main menu such as fish or pizza
class MenuCategory {
  final String name;
  final String description;
  final List<MenuItem> items;

  MenuCategory(this.name, this.description, this.items);
}
