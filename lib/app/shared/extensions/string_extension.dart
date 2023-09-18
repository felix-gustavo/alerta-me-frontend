import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  String get capitalize =>
      '${this[0].toUpperCase()}${substring(1).toLowerCase()}';

  DateTime get stringUTCtoDateTime =>
      DateFormat('yyyy-MM-ddThh:mm:ss').parseUTC(this).toLocal();

  DateTime get dateBRLtoDateTime =>
      DateFormat('dd/MM/yyyy', 'pt_BR').parse(this);

  TimeOfDay get hhmmToTime {
    final subTimeString = split(':');

    return TimeOfDay(
      hour: int.parse(subTimeString[0]),
      minute: int.parse(subTimeString[1]),
    );
  }
}
