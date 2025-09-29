// models/notification.dart
import 'dart:convert';

class AyursutraNotification {
  final String notificationId;
  final String senderAyursutraId;
  final String receiverAyursutraId;
  final String type;
  final String title;
  final String message;
  final Map<String, dynamic>? data;
  final String priority;
  final DateTime createdAt;
  final bool isRead;

  AyursutraNotification({
    required this.notificationId,
    required this.senderAyursutraId,
    required this.receiverAyursutraId,
    required this.type,
    required this.title,
    required this.message,
    this.data,
    required this.priority,
    required this.createdAt,
    required this.isRead,
  });

  factory AyursutraNotification.fromJson(Map<String, dynamic> json) {
    return AyursutraNotification(
      notificationId: json['notificationId'],
      senderAyursutraId: json['senderAyursutraId'],
      receiverAyursutraId: json['receiverAyursutraId'],
      type: json['type'],
      title: json['title'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] is String ? jsonDecode(json['data']) : json['data'])
          : null,
      priority: json['priority'] ?? 'medium',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      isRead: json['isRead'] ?? false,
    );
  }
}
