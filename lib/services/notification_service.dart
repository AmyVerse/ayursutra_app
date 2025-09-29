// services/notification_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/notification.dart';

class NotificationService {
  final String baseUrl = 'https://ayursutra.amyverse.in/api';
  final String apiKey = 'ayursutra_rollar'; // From your .env file

  // Headers with API key
  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'x-api-key': apiKey,
  };

  // Get notifications for a user
  Future<List<AyursutraNotification>> getNotifications(
    String ayursutraId, {
    String? status,
  }) async {
    try {
      final queryParams = {'ayursutraId': ayursutraId};
      if (status != null) {
        queryParams['status'] = status;
      }

      final uri = Uri.parse(
        '$baseUrl/notifications',
      ).replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['notifications'] != null) {
          return (data['notifications'] as List)
              .map(
                (notification) => AyursutraNotification.fromJson(notification),
              )
              .toList();
        } else {
          return [];
        }
      } else {
        print('Error fetching notifications: ${response.statusCode}');
        print('Response: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  // Create a new notification
  Future<AyursutraNotification?> createNotification({
    required String senderAyursutraId,
    required String receiverAyursutraId,
    required String type,
    required String title,
    required String message,
    Map<String, dynamic>? data,
    String priority = 'medium',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/notifications'),
        headers: headers,
        body: jsonEncode({
          'senderAyursutraId': senderAyursutraId,
          'receiverAyursutraId': receiverAyursutraId,
          'type': type,
          'title': title,
          'message': message,
          'data': data,
          'priority': priority,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['notification'] != null) {
          return AyursutraNotification.fromJson(data['notification']);
        }
      }

      print('Error creating notification: ${response.statusCode}');
      print('Response: ${response.body}');
      return null;
    } catch (e) {
      print('Error creating notification: $e');
      return null;
    }
  }

  // Mark a notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/notifications/$notificationId/read'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }

      return false;
    } catch (e) {
      print('Error marking notification as read: $e');
      return false;
    }
  }

  // Mark all notifications as read
  Future<bool> markAllAsRead(String ayursutraId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/notifications/mark-all-read'),
        headers: headers,
        body: jsonEncode({'ayursutraId': ayursutraId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }

      return false;
    } catch (e) {
      print('Error marking all notifications as read: $e');
      return false;
    }
  }

  // Get notification type icon (you can use this with your own UI)
  String getNotificationIcon(String type) {
    switch (type) {
      case 'appointment_request':
        return '📅';
      case 'appointment_confirmed':
        return '✅';
      case 'appointment_cancelled':
        return '❌';
      case 'appointment_rescheduled':
        return '🕒';
      case 'appointment_reminder':
        return '⏰';
      case 'treatment_update':
        return '💊';
      case 'prescription_ready':
        return '📝';
      case 'general':
        return '📣';
      default:
        return '📬';
    }
  }
}
