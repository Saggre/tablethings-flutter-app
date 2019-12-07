import 'package:json_annotation/json_annotation.dart';

part 'opening_hour_period.g.dart';

enum Day { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

enum EventType { open, close }

/// Represent an opening or a closing of a business. A list of these is used to represent the business hours of an establishment
@JsonSerializable(nullable: false, anyMap: true)
class OpeningHourPeriod {
  final int day;
  final int time; // 0-1440
  final bool open; // Open or close

  EventType get eventType {
    return open ? EventType.open : EventType.close;
  }

  OpeningHourPeriod({this.day, this.time, this.open});

  factory OpeningHourPeriod.fromJson(Map<String, dynamic> json) => _$OpeningHourPeriodFromJson(json);

  Map<String, dynamic> toJson() => _$OpeningHourPeriodToJson(this);
}
