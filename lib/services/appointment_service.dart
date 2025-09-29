// services/appointment_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/appointment.dart';

class AppointmentService {
  final String baseUrl = 'https://ayursutra.amyverse.in/api';
  final String apiKey = 'ayursutra_rollar'; // From your .env file

  // Headers with API key
  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'x-api-key': apiKey,
  };

  // Get appointments for a user (doctor or patient)
  Future<List<Appointment>> getAppointments(
    String ayursutraId, {
    String? status,
  }) async {
    try {
      final queryParams = {'ayursutraId': ayursutraId};
      if (status != null) {
        queryParams['status'] = status;
      }

      final uri = Uri.parse(
        '$baseUrl/appointments',
      ).replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['appointments'] != null) {
          return (data['appointments'] as List)
              .map((appointment) => Appointment.fromJson(appointment))
              .toList();
        } else {
          return [];
        }
      } else {
        print('Error fetching appointments: ${response.statusCode}');
        print('Response: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching appointments: $e');
      return [];
    }
  }

  // Create a new appointment
  Future<Appointment?> createAppointment({
    required String patientAyursutraId,
    required String doctorAyursutraId,
    required DateTime dateTime,
    String? notes,
    String? treatmentType,
    int duration = 60,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/appointments'),
        headers: headers,
        body: jsonEncode({
          'patientAyursutraId': patientAyursutraId,
          'doctorAyursutraId': doctorAyursutraId,
          'dateTime': dateTime.toUtc().toIso8601String(),
          'notes': notes,
          'treatmentType': treatmentType,
          'duration': duration,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['appointment'] != null) {
          return Appointment.fromJson(data['appointment']);
        }
      }

      print('Error creating appointment: ${response.statusCode}');
      print('Response: ${response.body}');
      return null;
    } catch (e) {
      print('Error creating appointment: $e');
      return null;
    }
  }

  // Format appointment date for display
  String formatAppointmentDate(DateTime dateTime) {
    return DateFormat('EEEE, MMMM d, yyyy • h:mm a').format(dateTime.toLocal());
  }

  // Get appointment status color (you can use this with your own UI)
  String getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return '#FFA500'; // Orange
      case 'confirmed':
        return '#10B981'; // Green
      case 'cancelled':
        return '#EF4444'; // Red
      case 'completed':
        return '#3B82F6'; // Blue
      default:
        return '#6B7280'; // Gray
    }
  }
}
