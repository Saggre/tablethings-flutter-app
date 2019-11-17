import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong/latlong.dart';
import 'package:tablething/models/cuisine_type_description.dart';
import 'package:tablething/models/cuisine_types.dart';

enum PriceRange { cheap, medium, expensive }

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
  final String description;
  final String googlePlaceId; // Not required
  final Currency currency;
  final PriceRange priceRange;
  final List<CuisineType> cuisineTypes;

  /// Pics
  final String thumbUrl;
  final String imageUrl;

  Establishment(this.id, this.streetAddress, this.streetAddress_2, this.zipCode, this.city, this.state, this.country, this.location, this.name,
      this.description, this.googlePlaceId, this.currency, this.priceRange, this.cuisineTypes, this.thumbUrl, this.imageUrl);

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
  static Establishment fromJson(Map<String, dynamic> json) {
    int currencyIndex = 0; // Default to eur
    try {
      currencyIndex = json['currency'] as int;
    } catch (e) {
      // TODO handle error
      print("Error getting establishment currency!");
    }
    Currency currency = Currency.values[currencyIndex];

    int priceRangeIndex = 1; // Default to medium price
    try {
      priceRangeIndex = json['priceRange'] as int;
    } catch (e) {
      // TODO handle error
      print("Error getting establishment price range!");
    }
    PriceRange priceRange = PriceRange.values[priceRangeIndex];

    // Transform database cuisine type indices to enums
    List<int> cuisineTypeIndices = List();
    List<CuisineType> cuisineTypes = List();
    try {
      cuisineTypeIndices = List.from(json['cuisineTypes']);
      for (var value in cuisineTypeIndices) {
        cuisineTypes.add(CuisineType.values[value]);
      }
    } catch (e) {
      // TODO handle error
      print("Error getting establishment cuisine types!");
      cuisineTypes = [CuisineType.other]; // 'Other' type on error
    }

    LatLng location; // No default location as it's a fatal error
    try {
      GeoPoint position = json['position'] as GeoPoint;
      location = LatLng(position.latitude, position.longitude);
    } catch (e) {
      // TODO handle FATAL error
      print("Error getting establishment GPS location!");
    }

    return Establishment(
      json['id'].toString(),
      json['streetAddress'].toString(),
      json['streetAddress2'].toString(),
      json['zipCode'].toString(),
      json['city'].toString(),
      json['state'].toString(),
      json['country'].toString(),
      location,
      json['name'].toString(),
      json['description'].toString(),
      '',
      currency,
      priceRange,
      cuisineTypes,
      json['thumbUrl'].toString(),
      json['imageUrl'].toString(),
    );
  }

  /// Only check id equality
  @override
  bool operator ==(Object other) => identical(this, other) || other is Establishment && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
