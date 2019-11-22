import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong/latlong.dart';
import 'package:tablething/models/establishment/opening_hour_period.dart';
import 'cuisine_type_description.dart';
import 'cuisine_types.dart';
import 'menu/menu.dart';

enum PriceRange { cheap, medium, expensive }

enum Currency { eur, usd, gbp }

/// Establishment represents a business selling food items or drinks
class Establishment {
  final String id;

  /// Address
  final String streetAddress;
  final String streetAddress2;
  final String zipCode;
  final String city;
  final String state;
  final String country;

  /// GPS location
  final LatLng location;

  /// Info
  final String name;
  final String description;
  final String fbPlaceId; // Not required
  final Currency currency;
  final PriceRange priceRange;
  final List<CuisineType> cuisineTypes;
  final List<OpeningHourPeriod> openingHours;

  Menu menu;

  /// Pics
  final String thumbUrl;
  final String imageUrl;

  Establishment(
      {this.id,
      this.streetAddress,
      this.streetAddress2,
      this.zipCode,
      this.city,
      this.state,
      this.country,
      this.location,
      this.name,
      this.description,
      this.fbPlaceId,
      this.currency,
      this.priceRange,
      this.cuisineTypes,
      this.openingHours,
      this.thumbUrl,
      this.imageUrl,
      this.menu});

  /// Translate price range into a string of currency symbols eg. €€€
  String get priceDisplay {
    final buffer = StringBuffer();
    for (int i = 0; i < priceRange.index + 1; i++) {
      buffer.write(currencySymbol);
    }
    return buffer.toString();
  }

  String get currencySymbol {
    String currencySymbol = '€';

    if (currency == Currency.gbp) {
      currencySymbol = '£';
    } else if (currency == Currency.usd) {
      currencySymbol = '\$';
    }

    // TODO add more currencies
  }

  /// Formats a price string. Adds currency symbol and decides decimal point etc.
  String formatPrice(String priceString) {
    return priceString + currencySymbol;
  }

  /// Get this establishment's main cuisine type or 'other' type if no types are set
  CuisineTypeDescription getDefaultCuisineTypeDescription() {
    CuisineType defaultCuisineType = cuisineTypes != null && cuisineTypes.length > 0 ? cuisineTypes[0] : CuisineType.other;
    return cuisineTypeDescriptions[defaultCuisineType];
  }

  /// Set menu
  void setMenu(Menu menu) {
    this.menu = menu;
  }

  /// Gets LatLng from geopoint json
  static LatLng _getLocation(json) {
    LatLng location; // No default location as it's a fatal error
    try {
      GeoPoint position = json as GeoPoint;
      location = LatLng(position.latitude, position.longitude);
    } catch (e) {
      try {
        location = LatLng(json['_latitude'] as double, json['_longitude'] as double);
      } catch (e) {
        // TODO handle FATAL error
        print("Error getting establishment GPS location!");
        print("JSON: " + json.toString());
      }
    }

    return location;
  }

  /// Gets a list of cuisine types from json array
  static List<CuisineType> _getCuisineTypes(json) {
    // Transform database cuisine type indices to enums
    List<int> cuisineTypeIndices = List();
    List<CuisineType> cuisineTypes = List();

    try {
      cuisineTypeIndices = List.from(json);
      for (var value in cuisineTypeIndices) {
        cuisineTypes.add(CuisineType.values[value]);
      }
    } catch (e) {
      // TODO handle error
      print("Error getting establishment cuisine types!");
      cuisineTypes = [CuisineType.other]; // 'Other' type on error
    }

    return cuisineTypes;
  }

  /// Gets PriceRange from json
  static PriceRange _getPriceRange(json) {
    int priceRangeIndex;

    try {
      priceRangeIndex = json as int;
    } catch (e) {
      priceRangeIndex = 1; // Default to medium price on error
      // TODO handle error
      print("Error getting establishment price range!");
    }

    return PriceRange.values[priceRangeIndex];
  }

  /// Gets currency enum from json int
  static Currency _getCurrency(json) {
    int currencyIndex;
    try {
      currencyIndex = json as int;
    } catch (e) {
      currencyIndex = 0; // Default to eur on error
      // TODO handle error
      print("Error getting establishment currency!");
    }

    return Currency.values[currencyIndex];
  }

  /// Gets opening hours from json
  static List<OpeningHourPeriod> _getOpeningHours(json) {
    try {
      return (json as List).map((period) {
        return OpeningHourPeriod.fromJson(period);
      }).toList();
    } catch (err) {
      print("Error getting opening hours! " + err.toString());
      return List<OpeningHourPeriod>(); // Default to empty periods
    }
  }

  /// Construct from json
  static Establishment fromJson(Map<String, dynamic> json) {
    return Establishment(
        id: json['id'] as String,
        streetAddress: json['streetAddress'] as String,
        streetAddress2: json['streetAddress2'] as String,
        zipCode: json['zipCode'] as String,
        city: json['city'] as String,
        state: json['state'] as String,
        country: json['country'] as String,
        location: _getLocation(json['position']),
        name: json['name'] as String,
        description: json['description'] as String,
        fbPlaceId: '',
        currency: _getCurrency(json['currency']),
        priceRange: _getPriceRange(json['priceRange']),
        cuisineTypes: _getCuisineTypes(json['cuisineTypes']),
        openingHours: _getOpeningHours(json['businessHours']),
        thumbUrl: json['thumbUrl'] as String,
        imageUrl: json['imageUrl'] as String,
        menu: Menu());
  }

  /// Only check id equality
  @override
  bool operator ==(Object other) => identical(this, other) || other is Establishment && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
