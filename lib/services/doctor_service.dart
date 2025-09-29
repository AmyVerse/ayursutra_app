// services/doctor_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/doctor.dart';
import 'auth_service.dart';
import 'doctor_cache_service.dart';

class DoctorService {
  final String baseUrl = 'https://ayursutra.amyverse.in/api';
  final AuthService _authService = AuthService();

  // Get API headers with authorization
  Future<Map<String, String>> get _headers async => {
    'Content-Type': 'application/json',
    'x-api-key': _authService.apiKey,
  };

  // Search doctors
  Future<List<Doctor>> searchDoctors({
    String? query,
    String? specialization,
    String? location,
    bool useCache = true,
  }) async {
    // Generate a cache key based on search parameters
    String cacheKey = 'doctors_search';
    if (query != null && query.isNotEmpty) cacheKey += '_q${query}';
    if (specialization != null && specialization.isNotEmpty)
      cacheKey += '_s${specialization}';
    if (location != null && location.isNotEmpty) cacheKey += '_l${location}';

    // Try to get results from cache first if useCache is true
    if (useCache &&
        query == null &&
        specialization == null &&
        location == null) {
      final cachedDoctors = await DoctorCacheService.getCachedDoctorsList();
      if (cachedDoctors != null) {
        print('Using cached doctors list');
        return cachedDoctors.map((doctor) => Doctor.fromJson(doctor)).toList();
      }
    }

    try {
      final queryParams = <String, String>{};

      if (query != null && query.isNotEmpty) {
        queryParams['search'] = query;
      }

      if (specialization != null && specialization.isNotEmpty) {
        queryParams['specialization'] = specialization;
      }

      if (location != null && location.isNotEmpty) {
        queryParams['location'] = location;
      }

      final uri = Uri.parse(
        '$baseUrl/doctors',
      ).replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: await _headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['doctors'] != null) {
          final doctorsList = data['doctors'] as List;

          // Cache the results if this is a general search (no specific filters)
          if (query == null && specialization == null && location == null) {
            await DoctorCacheService.cacheDoctorsList(doctorsList);
          }

          return doctorsList.map((doctor) => Doctor.fromJson(doctor)).toList();
        } else {
          return [];
        }
      } else {
        print('Error searching doctors: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error searching doctors: $e');
      return [];
    }
  }

  // Get doctor by ID
  Future<Doctor?> getDoctorById(int doctorId, {bool useCache = true}) async {
    try {
      // Try to get from cache first if useCache is true
      if (useCache) {
        final cachedDoctor = await DoctorCacheService.getCachedDoctorDetails(
          doctorId,
        );
        if (cachedDoctor != null) {
          print('Using cached doctor details for ID: $doctorId');
          return Doctor.fromJson(cachedDoctor);
        }
      }

      // Fetch from API if not in cache or cache not requested
      final response = await http.get(
        Uri.parse('$baseUrl/doctors/$doctorId'),
        headers: await _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['doctor'] != null) {
          final doctorData = data['doctor'];

          // Cache the doctor details
          await DoctorCacheService.cacheDoctorDetails(doctorId, doctorData);

          return Doctor.fromJson(doctorData);
        }
      }

      return null;
    } catch (e) {
      print('Error fetching doctor: $e');
      return null;
    }
  }

  // Book appointment with doctor
  Future<bool> requestAppointment(
    int doctorId,
    String doctorName,
    String patientAyursutraId,
  ) async {
    try {
      // First get the doctor details to retrieve their ayursutraId
      final doctorDetails = await getDoctorById(doctorId);
      if (doctorDetails == null) {
        print('Error: Doctor details not found');
        return false;
      }

      if (doctorDetails.ayursutraId.isEmpty) {
        print('Error: Doctor ayursutraId is empty');
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/notifications'),
        headers: await _headers,
        body: jsonEncode({
          'senderAyursutraId': patientAyursutraId,
          'receiverAyursutraId':
              doctorDetails.ayursutraId, // Use ayursutraId instead of doctorId
          'type': 'appointment_request',
          'title': 'New Appointment Request',
          'message':
              'Patient $patientAyursutraId has requested an appointment with you.',
          'data': jsonEncode({
            'doctorId': doctorId,
            'doctorName': doctorName,
            'patientAyursutraId': patientAyursutraId,
            'requestedAt': DateTime.now().toIso8601String(),
          }),
          'priority': 'high',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }

      return false;
    } catch (e) {
      print('Error requesting appointment: $e');
      return false;
    }
  }
}
