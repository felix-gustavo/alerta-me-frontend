import 'dart:convert';

import 'package:flutter/material.dart';

import '../shared/extensions/int_extension.dart';
import '../shared/extensions/string_extension.dart';
import '../shared/extensions/time_of_day_extension.dart';

class WaterReminder {
  final TimeOfDay start;
  final TimeOfDay end;
  final int interval;
  final int amount;
  final bool active;
  final List<TimeOfDay> reminders;

  WaterReminder({
    required this.start,
    required this.end,
    required this.interval,
    required this.amount,
    required this.active,
    required this.reminders,
  });

  factory WaterReminder.empty() {
    return WaterReminder(
      start: const TimeOfDay(hour: 8, minute: 0),
      end: const TimeOfDay(hour: 12, minute: 0),
      interval: 30,
      amount: 3000,
      active: true,
      reminders: [],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'start': start.toHHMM,
      'end': end.toHHMM,
      'interval': interval,
      'amount': amount,
      'active': active,
      'reminders': reminders.map((e) => e.toHHMM).toList()
    };
  }

  factory WaterReminder.fromMap(Map<String, dynamic> map) {
    final start = map['start'] as int;
    final end = map['end'] as int;
    final remindersList = List<String>.from(map['reminders'] as List);

    return WaterReminder(
      start: start.intHHMMToTimeOfDay,
      end: end.intHHMMToTimeOfDay,
      interval: map['interval'] as int,
      amount: map['amount'] as int,
      active: map['active'] as bool,
      reminders: remindersList.map((e) => e.hhmmToTime).toList(),
    );
  }

  WaterReminder copyWith({
    TimeOfDay? start,
    TimeOfDay? end,
    int? interval,
    int? amount,
    bool? active,
    List<TimeOfDay>? reminders,
  }) {
    return WaterReminder(
      start: start ?? this.start,
      end: end ?? this.end,
      interval: interval ?? this.interval,
      amount: amount ?? this.amount,
      active: active ?? this.active,
      reminders: reminders ?? this.reminders,
    );
  }

  String toJson() => json.encode(toMap());

  factory WaterReminder.fromJson(String source) =>
      WaterReminder.fromMap(json.decode(source) as Map<String, dynamic>);
}
