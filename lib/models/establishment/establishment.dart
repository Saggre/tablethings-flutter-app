import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';
import 'package:tablething/models/establishment/opening_hour_period.dart';
import 'package:tablething/services/graph/place.dart';
import 'package:tablething/services/graph/graph.dart';
import 'package:tablething/services/tablething/menu/menu.dart';
import 'cuisine_type_description.dart';
import 'cuisine_types.dart';

part 'establishment.g.dart';

enum PriceRange { cheap, medium, expensive }

enum Currency { eur, usd, gbp }

/// Establishment represents a business selling food items or drinks
@JsonSerializable(nullable: false)
class Establishment {
  final String id;

  /// Address
  final String streetAddress;
  @JsonKey(nullable: true)
  final String streetAddress2;
  final String zipCode;
  final String city;
  @JsonKey(nullable: true)
  final String state;
  final String country;

  /// GPS location
  final double latitude;
  final double longitude;

  /// Info
  final String name;
  final String description;
  @JsonKey(nullable: true)
  final String graphId; // Facebook graph place id
  @JsonKey(name: 'currency', nullable: true)
  final int currencyValue;
  @JsonKey(name: 'priceRange', nullable: true)
  final int priceRangeValue;
  @JsonKey(name: 'cuisineTypes', nullable: true)
  final List<int> cuisineTypeValues;

  @JsonKey(nullable: true)
  Menu menu;

  /// Pics
  @JsonKey(nullable: true)
  final String thumbUrl;
  @JsonKey(nullable: true)
  final String imageUrl;

  /// Variables
  // TODO transform into future
  @JsonKey(ignore: true)
  Place _placeInformation;

  /// Get graph place if it exists
  Future<Place> get placeInformation async {
    if (_placeInformation == null && graphId != null && graphId.length > 0) {
      // TODO decentralise access token
      _placeInformation = await Graph(accessToken: '2663499567071177|ciGy4HA1F7EU9gQFgYGnzvbMrAw').getPlaceWithId(graphId);
    }

    return _placeInformation;
  }

  Currency get currency {
    return Currency.values[currencyValue];
  }

  PriceRange get priceRange {
    return PriceRange.values[priceRangeValue];
  }

  List<CuisineType> get cuisineTypes {
    return cuisineTypeValues.map((value) {
      return CuisineType.values[value];
    }).toList();
  }

  Establishment({
    this.id,
    this.streetAddress,
    this.streetAddress2,
    this.zipCode,
    this.city,
    this.state,
    this.country,
    this.latitude,
    this.longitude,
    this.name,
    this.description,
    this.graphId,
    this.currencyValue,
    this.priceRangeValue,
    this.cuisineTypeValues,
    this.thumbUrl,
    this.imageUrl,
  });

  factory Establishment.fromJson(Map<String, dynamic> json) => _$EstablishmentFromJson(json);

  Map<String, dynamic> toJson() => _$EstablishmentToJson(this);

  /// Translate price range into a string of currency symbols eg. €€€
  String get priceDisplay {
    final buffer = StringBuffer();
    for (int i = 0; i < priceRangeValue + 1; i++) {
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

    return currencySymbol;
  }

  /// Get formatted string of a currency value
  String formatCurrency(int value) {
    // TODO variable locales
    var format = NumberFormat.currency(decimalDigits: 2, locale: 'fi_FI', symbol: currencySymbol);
    return format.format(value / 100.0);
  }

  /// Get this establishment's main cuisine type or 'other' type if no types are set
  CuisineTypeDescription get defaultCuisineTypeDescription {
    CuisineType defaultCuisineType = cuisineTypes != null && cuisineTypes.length > 0 ? cuisineTypes[0] : CuisineType.other;
    return cuisineTypeDescriptions[defaultCuisineType];
  }

  /// Only check id equality
  @override
  bool operator ==(Object other) => identical(this, other) || other is Establishment && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
