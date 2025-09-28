import 'package:flutter/material.dart';
import 'package:ayursutra_app/theme/colors.dart';

class NotificationPage extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      'title': 'Appointment Confirmed',
      'body': 'Your appointment with Dr. Sharma is confirmed for tomorrow at 10:00 AM.'
    },
    {
      'title': 'Health Tip',
      'body': 'Drink warm water every morning to boost your metabolism.'
    },
    {
      'title': 'Report Ready',
      'body': 'Your latest health report is now available in the app.'
    },
  ];

  NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
            leading: const Icon(Icons.notifications, color: primaryTeal, size: 30),
            title: Text(
              notif['title'] ?? '',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF0F172A),
              ),
            ),
            subtitle: Text(
              notif['body'] ?? '',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color(0xFF0F172A),
              ),
            ),
          );
        },
      ),
    );
  }
}
