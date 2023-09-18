import 'package:flutter/material.dart';

extension IntExtension on int {
  TimeOfDay get intFormatToTimeOfDay {
    int hours = this ~/ 10000;
    int minutes = (this % 10000) ~/ 100;
    int seconds = this % 100;

    hours = hours.clamp(0, 23);
    minutes = minutes.clamp(0, 59);
    seconds = seconds.clamp(0, 59);

    return TimeOfDay(hour: hours, minute: minutes);
  }

  TimeOfDay get convertMinutestoTimeOfDay {
    int hours = this ~/ 60;
    int minutes = this % 60;

    hours = hours.clamp(0, 23);
    minutes = minutes.clamp(0, 59);

    return TimeOfDay(hour: hours, minute: minutes);
  }
}
