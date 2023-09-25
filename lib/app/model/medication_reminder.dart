// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

import '../shared/extensions/int_extension.dart';
import '../shared/extensions/time_of_day_extension.dart';

enum Weekday {
  sun,
  mon,
  tue,
  wed,
  thu,
  fri,
  sat;

  String get namePtBrShort {
    switch (this) {
      case Weekday.sun:
        return 'DOM';
      case Weekday.mon:
        return 'SEG';
      case Weekday.tue:
        return 'TER';
      case Weekday.wed:
        return 'QUA';
      case Weekday.thu:
        return 'QUI';
      case Weekday.fri:
        return 'SEX';
      case Weekday.sat:
        return 'SÁB';
    }
  }

  String get namePtBr {
    switch (this) {
      case Weekday.sun:
        return 'Domingo';
      case Weekday.mon:
        return 'Segunda';
      case Weekday.tue:
        return 'Terça';
      case Weekday.wed:
        return 'Quarta';
      case Weekday.thu:
        return 'Quinta';
      case Weekday.fri:
        return 'Sexta';
      case Weekday.sat:
        return 'Sábado';
    }
  }
}

class Dosage {
  final TimeOfDay time;
  final int amount;

  Dosage({
    required this.time,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return <String, String>{
      'time': time.toHHMM,
      'amount': amount.toString(),
    };
  }

  factory Dosage.fromMap(Map<String, dynamic> map) {
    return Dosage(
      time: (map['time'] as int).intHHMMToTimeOfDay,
      amount: map['amount'] as int,
    );
  }

  @override
  bool operator ==(covariant Dosage other) {
    if (identical(this, other)) return true;

    return other.time == time && other.amount == amount;
  }

  @override
  int get hashCode => time.hashCode ^ amount.hashCode;
}

class MedicationReminder {
  final String? id;
  final String name;
  final String dosageUnit;
  final String dosagePronunciation;
  final String? comments;
  final Map<Weekday, List<Dosage>?> dose;

  factory MedicationReminder.empty() {
    return MedicationReminder(
      id: null,
      name: '',
      dosagePronunciation: '',
      dosageUnit: '',
      dose: {for (var weekday in Weekday.values) weekday: null},
      comments: '',
    );
  }

  MedicationReminder({
    this.id,
    required this.name,
    required this.dosageUnit,
    required this.dosagePronunciation,
    this.comments,
    required this.dose,
  });

  MedicationReminder copyWith({
    String? id,
    String? name,
    String? dosageUnit,
    String? dosagePronunciation,
    String? comments,
    Map<Weekday, List<Dosage>?>? dose,
  }) {
    return MedicationReminder(
      id: id ?? this.id,
      name: name ?? this.name,
      dosageUnit: dosageUnit ?? this.dosageUnit,
      dosagePronunciation: dosagePronunciation ?? this.dosagePronunciation,
      comments: comments ?? this.comments,
      dose: dose ?? this.dose,
    );
  }

  Map<String, dynamic> toMap() {
    final doseMap = dose.map(
      (key, value) {
        final dosages = value?.map((e) => e.toMap()).toList();
        return MapEntry(key.name, dosages);
      },
    );

    return <String, dynamic>{
      'id': id,
      'name': name,
      'dosage_unit': dosageUnit,
      'dosage_pronunciation': dosagePronunciation,
      'comments': comments,
      'dose': doseMap,
    };
  }

  factory MedicationReminder.fromMap(Map<String, dynamic> map) {
    final doseMap = map['dose'] as Map<String, dynamic>?;

    final Map<Weekday, List<Dosage>?> dose = {};

    for (final key in Weekday.values) {
      final List<dynamic>? dosageList = doseMap?[key.name];

      if (dosageList != null) {
        final dosages = dosageList.map((dosage) => Dosage.fromMap(dosage));
        dose[key] = dosages.toList();
      } else {
        dose[key] = null;
      }
    }

    return MedicationReminder(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      dosageUnit: map['dosage_unit'] as String,
      dosagePronunciation: map['dosage_pronunciation'] as String,
      comments: map['comments'] != null ? map['comments'] as String : null,
      dose: dose,
    );
  }

  String toJson() => json.encode(toMap());

  factory MedicationReminder.fromJson(String source) =>
      MedicationReminder.fromMap(json.decode(source) as Map<String, dynamic>);
}
