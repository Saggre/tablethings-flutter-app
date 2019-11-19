enum Day { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

enum EventType { open, close }

/// Represent an opening or a closing of a business. A list of these is used to represent the business hours of an establishment
class BusinessHoursEvent {
  final Day day;
  final int hour; // 0-1440
  final EventType eventType; // Open or close

  BusinessHoursEvent(this.day, this.hour, this.eventType);
}
