import 'review.dart';
import '../../models/establishment/opening_hour_period.dart';

class Place {
  final String name;
  final List<OpeningHourPeriod> openingHours;
  final double rating;
  final List<Review> reviews;
  final int userRatingsTotal;

  Place({this.name, this.openingHours, this.rating, this.reviews, this.userRatingsTotal});

  static Place fromJson(Map<String, dynamic> json) {
    List<dynamic> openingHours = List();

    // Map opens/closes to better format
    (json["opening_hours"]["periods"] as List).forEach((period) {
      // Usually (maybe always) contains a "open" and a "close" field
      //Map duration = period as Map<String, List>;
      if (period["close"] != null) {
        period["close"]["type"] = "close";
        openingHours.add(period["close"]);
      }

      if (period["open"] != null) {
        period["open"]["type"] = "open";
        openingHours.add(period["open"]);
      }
    });

    List<Review> reviews = List();

    return Place(
      name: json["name"].toString(),
      openingHours: openingHours.map((period){
        return OpeningHourPeriod.fromJson(period);
      }),
      rating: json["rating"] as double,

    );
  }
}
