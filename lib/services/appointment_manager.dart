// services/appointment_manager.dart
import 'package:flutter/material.dart';

import '../models/appointment.dart';
import '../models/notification.dart';
import 'ably_service.dart';
import 'appointment_service.dart';
import 'auth_service.dart';
import 'notification_service.dart';

class AppointmentManager {
  final AppointmentService _appointmentService = AppointmentService();
  final NotificationService _notificationService = NotificationService();
  final AblyService _ablyService = AblyService();
  final AuthService _authService = AuthService();

  String? _currentUserAyursutraId;
  bool _initialized = false;

  // Singleton pattern
  static final AppointmentManager _instance = AppointmentManager._internal();
  factory AppointmentManager() => _instance;
  AppointmentManager._internal();

  // Initialize with user details
  Future<bool> initialize() async {
    try {
      final user = await _authService.getUserDetails();
      if (user == null || user.ayursutraId == null) {
        debugPrint(
          'Cannot initialize AppointmentManager: User not found or missing ID',
        );
        return false;
      }

      _currentUserAyursutraId = user.ayursutraId;

      // Initialize real-time notifications
      _initialized = await _ablyService.connect(_currentUserAyursutraId!);

      debugPrint(
        'AppointmentManager initialized for user: ${user.ayursutraId}',
      );
      return _initialized;
    } catch (e) {
      debugPrint('Error initializing AppointmentManager: $e');
      return false;
    }
  }

  // Get stream of notifications
  Stream<AyursutraNotification> get notificationStream =>
      _ablyService.notifications;

  // Get all appointments for the current user
  Future<List<Appointment>> getMyAppointments({String? status}) async {
    if (!_initialized || _currentUserAyursutraId == null) {
      await initialize();
    }

    if (_currentUserAyursutraId == null) return [];
    return _appointmentService.getAppointments(
      _currentUserAyursutraId!,
      status: status,
    );
  }

  // Get all notifications for the current user
  Future<List<AyursutraNotification>> getMyNotifications({
    String? status,
  }) async {
    if (!_initialized || _currentUserAyursutraId == null) {
      await initialize();
    }

    if (_currentUserAyursutraId == null) return [];
    return _notificationService.getNotifications(
      _currentUserAyursutraId!,
      status: status,
    );
  }

  // Request an appointment with a doctor
  Future<bool> requestAppointment({
    required String doctorAyursutraId,
    required DateTime appointmentDateTime,
    String? notes,
    String? treatmentType,
  }) async {
    if (!_initialized || _currentUserAyursutraId == null) {
      await initialize();
    }

    if (_currentUserAyursutraId == null) return false;

    // Create the appointment
    final appointment = await _appointmentService.createAppointment(
      patientAyursutraId: _currentUserAyursutraId!,
      doctorAyursutraId: doctorAyursutraId,
      dateTime: appointmentDateTime,
      notes: notes,
      treatmentType: treatmentType,
    );

    return appointment != null;
  }

  // Request appointment from doctor profile
  Future<bool> requestAppointmentWithDoctor({
    required String doctorAyursutraId,
    required String doctorName,
    DateTime? appointmentDateTime,
    String? notes,
    String? treatmentType,
  }) async {
    if (!_initialized || _currentUserAyursutraId == null) {
      await initialize();
    }

    if (_currentUserAyursutraId == null) return false;

    try {
      // Validate ayursutraId is not an integer or numeric string
      if (doctorAyursutraId.isEmpty ||
          int.tryParse(doctorAyursutraId) != null) {
        debugPrint(
          'Warning: doctorAyursutraId appears to be numeric or empty: $doctorAyursutraId',
        );
        debugPrint('This might be a doctor ID instead of ayursutraId');
      }

      // If no date specified, create a notification request without an appointment
      if (appointmentDateTime == null) {
        // Just create a notification for the doctor
        final notification = await _notificationService.createNotification(
          senderAyursutraId: _currentUserAyursutraId!,
          receiverAyursutraId: doctorAyursutraId,
          type: 'appointment_request',
          title: 'New Appointment Request',
          message: 'A patient would like to consult with you.',
          data: {
            'patientAyursutraId': _currentUserAyursutraId,
            'patientName': 'Patient', // Get patient name if available
            'requestedAt': DateTime.now().toIso8601String(),
            'doctorAyursutraId': doctorAyursutraId,
            'doctorName': doctorName,
          },
          priority: 'high',
        );

        return notification != null;
      } else {
        // Create a formal appointment
        return await requestAppointment(
          doctorAyursutraId: doctorAyursutraId,
          appointmentDateTime: appointmentDateTime,
          notes: notes,
          treatmentType: treatmentType,
        );
      }
    } catch (e) {
      print('Error requesting appointment: $e');
      return false;
    }
  }

  // Mark a notification as read
  Future<bool> markNotificationAsRead(String notificationId) async {
    return await _notificationService.markAsRead(notificationId);
  }

  // Mark all notifications as read
  Future<bool> markAllNotificationsAsRead() async {
    if (_currentUserAyursutraId == null) return false;
    return await _notificationService.markAllAsRead(_currentUserAyursutraId!);
  }

  // Clean up resources
  void dispose() {
    _ablyService.disconnect();
  }
}
