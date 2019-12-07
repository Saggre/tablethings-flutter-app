// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opening_hour_period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpeningHourPeriod _$OpeningHourPeriodFromJson(Map json) {
  return OpeningHourPeriod(
    day: json['day'] as int,
    time: json['time'] as int,
    open: json['open'] as bool,
  );
}

Map<String, dynamic> _$OpeningHourPeriodToJson(OpeningHourPeriod instance) =>
    <String, dynamic>{
      'day': instance.day,
      'time': instance.time,
      'open': instance.open,
    };
