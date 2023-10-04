import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay interval(TimeOfDay time) {
    final int startMinutes = hour * 60 + minute;
    final int endMinutes = time.hour * 60 + time.minute;

    int intervalMinutes = endMinutes - startMinutes;

    if (intervalMinutes < 0) intervalMinutes += 24 * 60;

    final int hours = intervalMinutes ~/ 60;
    final int minutes = intervalMinutes % 60;

    return TimeOfDay(hour: hours, minute: minutes);
  }

  String get toHHMM =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  int get toInt {
    final hours = hour.clamp(0, 23);
    final minutes = minute.clamp(0, 59);
    return hours * 10000 + minutes * 100;
  }

  int get convertToMinutes {
    final hours = hour.clamp(0, 23);
    final minutes = minute.clamp(0, 59);
    return hours * 60 + minutes;
  }

  int compareTo(TimeOfDay other) {
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (minute < other.minute) return -1;
    if (minute > other.minute) return 1;
    return 0;
  }
}
