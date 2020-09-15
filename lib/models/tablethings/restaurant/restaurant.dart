import 'package:json_annotation/json_annotation.dart';

part 'restaurant.g.dart';

enum PriceRange { cheap, medium, expensive }

enum Currency { eur, usd, gbp }

/// Establishment represents a business selling food items or drinks
@JsonSerializable(nullable: false)
class Restaurant {
  final String id;
  final Address address;
  final String name;
  final String description;

  @JsonKey(name: 'priceRange', nullable: true)
  final int priceRange;

  final String thumbnail;
  final List<String> images;

  @JsonKey(nullable: true)
  final String graphId; // Facebook graph place id

  @JsonKey(name: 'cuisineTypes', nullable: true)
  final List<int> cuisineTypes;

  String activeMenuId;
  List<String> menuIds;

  /// Variables
  // TODO transform into future
  /*@JsonKey(ignore: true)
  Place _placeInformation;

  /// Get graph place if it exists
  Future<Place> get placeInformation async {
    if (_placeInformation == null && graphId != null && graphId.length > 0) {
      // TODO decentralise access token
      _placeInformation = await Graph(accessToken: '2663499567071177|ciGy4HA1F7EU9gQFgYGnzvbMrAw').getPlaceWithId(graphId);
    }

    return _placeInformation;
  }
   */

  Restaurant(this.id, this.address, this.name, this.description, this.priceRange, this.thumbnail, this.images, this.graphId, this.cuisineTypes,
      this.activeMenuId, this.menuIds);

  /*List<CuisineType> get cuisineTypes {
    return cuisineTypeValues.map((value) {
      return CuisineType.values[value];
    }).toList();
  }*/

  factory Restaurant.fromJson(Map<String, dynamic> json) => _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);

  PriceRange get getPriceRange {
    return PriceRange.values[priceRange];
  }

  /// Translate price range into a string of currency symbols eg. €€€
  String get priceDisplay {
    final buffer = StringBuffer();
    for (int i = 0; i < priceRange + 1; i++) {
      buffer.write('\$');
    }
    return buffer.toString();
  }

  /*String get currencySymbol {
    String currencySymbol = '€';

    if (currency == Currency.gbp) {
      currencySymbol = '£';
    } else if (currency == Currency.usd) {
      currencySymbol = '\$';
    }

    return currencySymbol;
  }*/

  /// Get formatted string of a currency value
  /*String formatCurrency(int value) {
    // TODO variable locales
    var format = NumberFormat.currency(decimalDigits: 2, locale: 'fi_FI', symbol: currencySymbol);
    return format.format(value / 100.0);
  }*/

  /// Get this establishment's main cuisine type or 'other' type if no types are set
  /*CuisineTypeDescription get defaultCuisineTypeDescription {
    CuisineType defaultCuisineType = cuisineTypes != null && cuisineTypes.length > 0 ? cuisineTypes[0] : CuisineType.other;
    return cuisineTypeDescriptions[defaultCuisineType];
  }*/

  /// Check object equality
  @override
  bool operator ==(Object other) => identical(this, other) || other is Restaurant && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
