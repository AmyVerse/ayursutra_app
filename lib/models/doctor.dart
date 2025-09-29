// models/doctor.dart
class Doctor {
  final int id;
  final String ayursutraId;
  final String name;
  final String specialization;
  final String experience;
  final int patientsChecked;
  final String rating;
  final String? biography;
  final String location;
  final bool isVerified;
  final String? userEmail;
  final String? userPhone;

  Doctor({
    required this.id,
    required this.ayursutraId,
    required this.name,
    required this.specialization,
    required this.experience,
    required this.patientsChecked,
    required this.rating,
    this.biography,
    required this.location,
    required this.isVerified,
    this.userEmail,
    this.userPhone,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      ayursutraId: json['ayursutraId'] ?? '',
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      experience: json['experience'] ?? '0',
      patientsChecked: json['patientsChecked'] ?? 0,
      rating: json['rating'] ?? '0',
      biography: json['biography'],
      location: json['location'] ?? '',
      isVerified: json['isVerified'] ?? false,
      userEmail: json['userEmail'],
      userPhone: json['userPhone'],
    );
  }
}
