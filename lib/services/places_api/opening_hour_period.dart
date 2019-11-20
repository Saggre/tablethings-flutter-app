enum Day { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

enum EventType { open, close }

/// Represent an opening or a closing of a business. A list of these is used to represent the business hours of an establishment
class OpeningHourPeriod {
  final Day day;
  final int time; // 0-1440
  final EventType eventType; // Open or close

  OpeningHourPeriod({this.day, this.time, this.eventType});

  /// Format:
  /// {
  ///   "day" : 0, 0-6
  ///   "open" : true, or false
  ///   "time" : 0, 0-1440
  /// }
  static OpeningHourPeriod fromJson(Map<String, dynamic> json) {
    return OpeningHourPeriod(
      day: Day.values[json["day"] as int],
      time: json["time"] as int,
      eventType: (json["open"] as bool) == true ? EventType.open : EventType.close,
    );
  }
}
