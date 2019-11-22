class GraphPlace {
  final String id;
  final double rating;
  final int ratingCount;

  GraphPlace({this.id, this.rating, this.ratingCount});

  /// Format:
  /// {
  ///   "overall_star_rating": 4.3,
  ///   "rating_count": 23,
  ///   "id": "335584633290150"
  /// }
  factory GraphPlace.fromJson(Map<String, dynamic> json) {
    return GraphPlace(
      id: json["id"].toString(),
      rating: json["overall_star_rating"] as double,
      ratingCount: json["rating_count"],
    );
  }
}
