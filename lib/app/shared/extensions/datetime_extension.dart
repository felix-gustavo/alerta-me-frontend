import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'string_extension.dart';

extension DateTimeExtension on DateTime {
  String _toPad(int value) => value.toString().padLeft(2, '0');

  String get toDateBRL => '${_toPad(day)}/${_toPad(month)}/$year';
  String get toTime => '${_toPad(hour)}:${_toPad(minute)}';
  String get toUtcDateTime => DateFormat('yyyy-MM-ddTHH:mm:ss').format(this);

  String get toDateBRLExtension =>
      DateFormat('EEEE, d MMMM yyyy', 'pt_BR').format(this).capitalize;

  DateTime updateTime(TimeOfDay newTime) => DateTime(
        year,
        month,
        day,
        newTime.hour,
        newTime.minute,
      );

  DateTime updateDate(DateTime newDate) => DateTime(
        newDate.year,
        newDate.month,
        newDate.day,
        hour,
        minute,
      );
}
