class Review {
  final String authorName;
  final String authorUrl;
  final String language;
  final String profilePhotoUrl;
  final double rating;
  final String text;
  final int time;

  Review({this.authorName, this.authorUrl, this.language, this.profilePhotoUrl, this.rating, this.text, this.time});

  /// Format:
  /// {
  ///    "author_name" : "Nina Stenman",
  ///    "author_url" : "https://www.google.com/maps/contrib/109304761311078977830/reviews",
  ///    "profile_photo_url" : "https://lh4.ggpht.com/-gFUj4FQd13k/AAAAAAAAAAI/AAAAAAAAAAA/Ce8gyZAKi70/s128-c0x00000000-cc-rp-mo/photo.jpg",
  ///    "rating" : 5,
  ///    "relative_time_description" : "a month ago",
  ///    "text" : "",
  ///    "time" : 1571586228
  ///  }
  ///
  static Review fromJson(Map<String, dynamic> json) {
    return Review(
      authorName: json["author_name"] as String,
      authorUrl: json["author_url"] as String,
      profilePhotoUrl: json["profile_photo_url" as String],
      rating: json["rating"] as double,
      text: json["text"] as String,
      time: json["time"] as int,
    );
  }
}
