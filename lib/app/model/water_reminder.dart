import 'package:flutter/material.dart';

import '../shared/extensions/int_extension.dart';
import '../shared/extensions/time_of_day_extension.dart';

class WaterReminder {
  final TimeOfDay start;
  final TimeOfDay end;
  final int interval;
  final int amount;

  WaterReminder({
    required this.start,
    required this.end,
    required this.interval,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'start': start.toHHMMSS,
      'end': end.toHHMMSS,
      'interval': interval,
      'amount': amount,
    };
  }

  factory WaterReminder.fromMap(Map<String, dynamic> map) {
    final start = map['start'] as int;
    final end = map['end'] as int;

    return WaterReminder(
      start: start.intHHMMSSToTimeOfDay,
      end: end.intHHMMSSToTimeOfDay,
      interval: map['interval'] as int,
      amount: map['amount'] as int,
    );
  }
}
