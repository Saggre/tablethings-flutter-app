import 'package:latlong/latlong.dart';
import 'package:tablething/models/cuisine_type_description.dart';
import 'package:tablething/models/cuisine_types.dart';

enum PriceRange { cheap, medium, expensive }

enum EstablishmentType { cafe, restaurant, bar, hotel, fastFood }

enum Currency { eur, usd, gbp }

/// Establishment represents a business selling food items or drinks
class Establishment {
  final String id;

  /// Address
  final String streetAddress;
  final String streetAddress_2;
  final String zipCode;
  final String city;
  final String state;
  final String country;

  /// GPS location
  final LatLng location;

  /// Info
  final String name;
  final Currency currency;
  final EstablishmentType restaurantType;
  final PriceRange priceRange;
  final List<CuisineType> cuisineTypes;

  /// Pics
  final String thumbUrl;
  final String imageUrl;

  Establishment(this.id, this.streetAddress, this.streetAddress_2, this.zipCode, this.city, this.state, this.country, this.location, this.name, this.currency,
      this.restaurantType, this.priceRange, this.cuisineTypes, this.thumbUrl, this.imageUrl);

  /// Translate price range into a string of currency symbols eg. €€€
  String get priceDisplay {
    String currencySymbol = '€';

    if (currency == Currency.gbp) {
      currencySymbol = '£';
    } else if (currency == Currency.usd) {
      currencySymbol = '\$';
    }

    // TODO add more currencies

    final buffer = StringBuffer();
    for (int i = 0; i < priceRange.index; i++) {
      buffer.write(currencySymbol);
    }
    return buffer.toString();
  }

  /// Get this establishment's main cuisine type or 'other' type if no types are set
  CuisineTypeDescription getDefaultCuisineTypeDescription() {
    CuisineType defaultCuisineType = cuisineTypes != null && cuisineTypes.length > 0 ? cuisineTypes[0] : CuisineType.other;
    return cuisineTypeDescriptions[defaultCuisineType];
  }

  /// Construct from json
  static Establishment fromJson(json) {
    Currency currency = Currency.values[json['currency']];

    EstablishmentType restaurantType = EstablishmentType.values[json['restaurantType']];

    PriceRange priceRange = PriceRange.values[json['priceRange']];

    List<CuisineType> cuisineTypes;

    LatLng location = LatLng(0, 0);

    return Establishment(
      json['id'],
      json['streetAddress'],
      json['streetAddress2'],
      json['zipCode'],
      json['city'],
      json['state'],
      json['country'],
      location,
      json['name'],
      currency,
      restaurantType,
      priceRange,
      cuisineTypes,
      json['thumbUrl'],
      json['imageUrl'],
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Establishment && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
