import '../shared/extensions/datetime_extension.dart';
import '../shared/extensions/string_extension.dart';

class MedicalReminder {
  final String? id;
  final String medicName;
  final String specialty;
  final DateTime dateTime;
  final String address;
  final bool active;

  MedicalReminder({
    this.id,
    required this.medicName,
    required this.specialty,
    required this.dateTime,
    required this.address,
    required this.active,
  });

  factory MedicalReminder.empty() {
    return MedicalReminder(
      id: null,
      medicName: '',
      specialty: '',
      dateTime: DateTime.now(),
      address: '',
      active: false,
    );
  }

  MedicalReminder copyWith({
    String? id,
    String? medicName,
    String? specialty,
    DateTime? dateTime,
    String? address,
    bool? active,
  }) {
    return MedicalReminder(
      id: id ?? this.id,
      medicName: medicName ?? this.medicName,
      specialty: specialty ?? this.specialty,
      dateTime: dateTime ?? this.dateTime,
      address: address ?? this.address,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'medic_name': medicName,
      'specialty': specialty,
      'datetime': dateTime.toUtcDateTime,
      'address': address,
      'active': active,
    };
  }

  factory MedicalReminder.fromMap(Map<String, dynamic> map) {
    final dateTime = (map['datetime'] as String).stringUTCtoDateTime;

    return MedicalReminder(
      id: map['id'] as String,
      medicName: map['medic_name'] as String,
      specialty: map['specialty'] as String,
      dateTime: dateTime,
      address: map['address'] as String,
      active: map['active'] as bool,
    );
  }

  @override
  String toString() {
    return 'MedicalReminder(id: $id, medicName: $medicName, specialty: $specialty, dateTime: $dateTime, address: $address, active: $active)';
  }
}
