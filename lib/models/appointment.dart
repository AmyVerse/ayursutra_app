// models/appointment.dart
class Appointment {
  final String appointmentId;
  final String patientAyursutraId;
  final String doctorAyursutraId;
  final DateTime dateTime;
  final String? notes;
  final String? treatmentType;
  final int duration;
  final String status;
  final DateTime createdAt;

  Appointment({
    required this.appointmentId,
    required this.patientAyursutraId,
    required this.doctorAyursutraId,
    required this.dateTime,
    this.notes,
    this.treatmentType,
    required this.duration,
    required this.status,
    required this.createdAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      appointmentId: json['appointmentId'],
      patientAyursutraId: json['patientAyursutraId'],
      doctorAyursutraId: json['doctorAyursutraId'],
      dateTime: DateTime.parse(json['dateTime']),
      notes: json['notes'],
      treatmentType: json['treatmentType'],
      duration: json['duration'] ?? 60,
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
