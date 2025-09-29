// services/ably_service.dart
import 'dart:async';

import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/notification.dart';

class AblyService {
  // API constants
  static const String apiKey = 'ayursutra_rollar';
  static const String baseUrl = 'https://ayursutra.amyverse.in/api';

  // Ably client
  ably.Realtime? _realtime;
  ably.RealtimeChannel? _channel;

  // User identification
  String? _userAyursutraId;

  // Stream controller for notifications
  final _notificationController =
      StreamController<AyursutraNotification>.broadcast();
  Stream<AyursutraNotification> get notifications =>
      _notificationController.stream;

  // Local notifications plugin
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Singleton instance
  static final AblyService _instance = AblyService._internal();
  factory AblyService() => _instance;
  AblyService._internal();

  /// Initialize connection to Ably
  Future<bool> connect(String ayursutraId) async {
    try {
      _userAyursutraId = ayursutraId;

      // Create Ably Realtime instance with direct API auth
      _realtime = ably.Realtime(
        options: ably.ClientOptions(
          authUrl: '$baseUrl/ably/auth',
          authHeaders: {'x-api-key': apiKey, 'x-ayursutra-id': ayursutraId},
        ),
      );

      // Set up connection state change listener
      _realtime?.connection.on().listen((
        ably.ConnectionStateChange stateChange,
      ) {
        debugPrint('Ably connection state: ${stateChange.current}');

        if (stateChange.current == ably.ConnectionState.failed) {
          debugPrint('Ably connection failed: ${stateChange.reason}');
        }
      });

      // Initialize notifications plugin
      await _initializeLocalNotifications();

      // Subscribe to user's notification channel
      await _subscribeToNotifications(ayursutraId);

      return true;
    } catch (e) {
      debugPrint('Error connecting to Ably: $e');
      return false;
    }
  }

  /// Subscribe to notifications for the specified user
  Future<void> _subscribeToNotifications(String ayursutraId) async {
    try {
      // Get channel for this user's notifications
      _channel = _realtime?.channels.get('notifications:$ayursutraId');

      // Subscribe to all messages on this channel
      _channel?.subscribe().listen(
        (ably.Message message) {
          try {
            // Parse the notification data
            final notificationData = Map<String, dynamic>.from(
              message.data as Map,
            );
            final notification = AyursutraNotification.fromJson(
              notificationData,
            );

            // Add to stream for UI updates
            _notificationController.add(notification);

            // Show local notification
            _showLocalNotification(notification);

            debugPrint('Received notification: ${notification.title}');
          } catch (e) {
            debugPrint('Error handling notification: $e');
          }
        },
        onError: (error) {
          debugPrint('Ably subscription error: $error');
        },
      );
    } catch (e) {
      debugPrint('Error subscribing to notifications: $e');
    }
  }

  /// Initialize the local notifications plugin
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );
  }

  /// Show a local notification
  Future<void> _showLocalNotification(
    AyursutraNotification notification,
  ) async {
    const androidDetails = AndroidNotificationDetails(
      'ayursutra_notifications',
      'AyurSutra Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      notification.notificationId.hashCode,
      notification.title,
      notification.message,
      notificationDetails,
    );
  }

  /// Check if currently connected to Ably
  bool get isConnected {
    return _realtime?.connection.state == ably.ConnectionState.connected;
  }

  /// Disconnect from Ably
  Future<void> disconnect() async {
    await _channel?.detach();
    await _realtime?.close();
    _notificationController.close();
  }

  /// Reconnect if connection was lost
  Future<bool> reconnect() async {
    if (_userAyursutraId == null) return false;

    await disconnect();
    return await connect(_userAyursutraId!);
  }
}
