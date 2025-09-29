// example_usage.dart
import 'package:flutter/material.dart';

import '../services/appointment_manager.dart';

class NotificationExample extends StatefulWidget {
  const NotificationExample({Key? key}) : super(key: key);

  @override
  State<NotificationExample> createState() => _NotificationExampleState();
}

class _NotificationExampleState extends State<NotificationExample> {
  final AppointmentManager _appointmentManager = AppointmentManager();
  bool _isInitialized = false;
  String _status = 'Not initialized';

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      final success = await _appointmentManager.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = success;
          _status = success
              ? 'Connected to notifications'
              : 'Failed to connect to notifications';
        });
      }

      // Listen for notifications
      _appointmentManager.notificationStream.listen((notification) {
        if (mounted) {
          setState(() {
            _status = 'New notification: ${notification.title}';
          });

          // Show a snackbar with the notification
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(notification.message),
              action: SnackBarAction(
                label: 'View',
                onPressed: () {
                  // Navigate to notification details
                },
              ),
            ),
          );
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _status = 'Error: $e';
        });
      }
    }
  }

  @override
  void dispose() {
    _appointmentManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isInitialized ? Icons.check_circle : Icons.error,
              color: _isInitialized ? Colors.green : Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _status,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isInitialized
                  ? () {
                      // Example booking - would be connected to a doctor detail page
                      _bookAppointmentExample();
                    }
                  : null,
              child: const Text('Book Test Appointment'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _bookAppointmentExample() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Booking appointment...'),
          ],
        ),
      ),
    );

    try {
      // Example booking with a test doctor ID
      final success = await _appointmentManager.requestAppointmentWithDoctor(
        doctorAyursutraId: 'test-doctor-id',
        doctorName: 'Dr. Test Doctor',
        appointmentDateTime: DateTime.now().add(const Duration(days: 1)),
        notes: 'This is a test appointment',
      );

      Navigator.pop(context); // Close progress dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Appointment booked successfully!'
                : 'Failed to book appointment',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Close progress dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }
}
