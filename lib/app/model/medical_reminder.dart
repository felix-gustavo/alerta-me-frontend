import '../shared/extensions/datetime_extension.dart';
import '../shared/extensions/string_extension.dart';

class MedicalReminder {
  final String? id;
  final String medicName;
  final String specialty;
  final DateTime dateTime;
  final String address;

  MedicalReminder({
    this.id,
    required this.medicName,
    required this.specialty,
    required this.dateTime,
    required this.address,
  });

  factory MedicalReminder.empty() {
    return MedicalReminder(
      id: null,
      medicName: '',
      specialty: '',
      dateTime: DateTime.now(),
      address: '',
    );
  }

  MedicalReminder copyWith({
    String? id,
    String? medicName,
    String? specialty,
    DateTime? dateTime,
    String? address,
  }) {
    return MedicalReminder(
      id: id ?? this.id,
      medicName: medicName ?? this.medicName,
      specialty: specialty ?? this.specialty,
      dateTime: dateTime ?? this.dateTime,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'medic_name': medicName,
      'specialty': specialty,
      'date': dateTime.toUtcDateTime,
      'address': address,
    };
  }

  factory MedicalReminder.fromMap(Map<String, dynamic> map) {
    return MedicalReminder(
      id: map['id'] as String,
      medicName: map['medic_name'] as String,
      specialty: map['specialty'] as String,
      dateTime: (map['date'] as String).stringUTCtoDateTime,
      address: map['address'] as String,
    );
  }

  @override
  String toString() {
    return 'MedicalReminder(id: $id, medicName: $medicName, specialty: $specialty, dateTime: $dateTime, address: $address)';
  }
}
