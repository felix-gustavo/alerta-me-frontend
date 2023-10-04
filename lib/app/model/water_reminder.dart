import 'package:flutter/material.dart';

import '../shared/extensions/int_extension.dart';
import '../shared/extensions/time_of_day_extension.dart';

class WaterReminder {
  final TimeOfDay start;
  final TimeOfDay end;
  final int interval;
  final int amount;
  final bool active;

  WaterReminder({
    required this.start,
    required this.end,
    required this.interval,
    required this.amount,
    required this.active,
  });

  factory WaterReminder.empty() {
    return WaterReminder(
      start: const TimeOfDay(hour: 8, minute: 0),
      end: const TimeOfDay(hour: 12, minute: 0),
      interval: 60,
      amount: 3000,
      active: true,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'start': start.toHHMM,
      'end': end.toHHMM,
      'interval': interval,
      'amount': amount,
      'active': active,
    };
  }

  factory WaterReminder.fromMap(Map<String, dynamic> map) {
    final start = map['start'] as int;
    final end = map['end'] as int;

    return WaterReminder(
      start: start.intHHMMToTimeOfDay,
      end: end.intHHMMToTimeOfDay,
      interval: map['interval'] as int,
      amount: map['amount'] as int,
      active: map['active'] as bool,
    );
  }

  WaterReminder copyWith({
    TimeOfDay? start,
    TimeOfDay? end,
    int? interval,
    int? amount,
    bool? active,
  }) {
    return WaterReminder(
      start: start ?? this.start,
      end: end ?? this.end,
      interval: interval ?? this.interval,
      amount: amount ?? this.amount,
      active: active ?? this.active,
    );
  }
}
