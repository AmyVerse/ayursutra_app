import 'package:ayursutra_app/models/notification.dart';
import 'package:ayursutra_app/services/appointment_manager.dart';
import 'package:ayursutra_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final AppointmentManager _appointmentManager = AppointmentManager();
  List<AyursutraNotification> _notifications = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _listenForNewNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      // Initialize the manager if needed
      await _appointmentManager.initialize();

      // Fetch notifications
      final notifications = await _appointmentManager.getMyNotifications();

      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading notifications: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _listenForNewNotifications() {
    _appointmentManager.notificationStream.listen((notification) {
      setState(() {
        // Add to the top of the list
        _notifications.insert(0, notification);
      });
    });
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return DateFormat('MMM d, yyyy').format(dateTime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'appointment_request':
        return Icons.calendar_today;
      case 'appointment_confirmed':
        return Icons.check_circle;
      case 'appointment_cancelled':
        return Icons.cancel;
      case 'appointment_rescheduled':
        return Icons.update;
      case 'appointment_reminder':
        return Icons.alarm;
      case 'treatment_update':
        return Icons.medical_services;
      case 'prescription_ready':
        return Icons.receipt;
      default:
        return Icons.notifications;
    }
  }

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
        actions: [
          if (_notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.done_all, color: Color(0xFF0F172A)),
              onPressed: () async {
                final result = await _appointmentManager
                    .markAllNotificationsAsRead();
                if (result) {
                  setState(() {
                    _notifications = _notifications.map((n) {
                      return AyursutraNotification(
                        notificationId: n.notificationId,
                        senderAyursutraId: n.senderAyursutraId,
                        receiverAyursutraId: n.receiverAyursutraId,
                        type: n.type,
                        title: n.title,
                        message: n.message,
                        data: n.data,
                        priority: n.priority,
                        createdAt: n.createdAt,
                        isRead: true,
                      );
                    }).toList();
                  });
                }
              },
              tooltip: 'Mark all as read',
            ),
        ],
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _loadNotifications,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: primaryTeal))
            : _hasError
            ? _buildErrorView()
            : _notifications.isEmpty
            ? _buildEmptyView()
            : _buildNotificationsList(),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Failed to load notifications',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _loadNotifications,
            style: ElevatedButton.styleFrom(backgroundColor: primaryTeal),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return ListView(
      // This ensures pull-to-refresh works even when empty
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No notifications yet',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'We\'ll notify you when something important happens',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      itemCount: _notifications.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final notif = _notifications[index];
        return Dismissible(
          key: Key(notif.notificationId),
          background: Container(
            color: Colors.green,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.done, color: Colors.white),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              // Delete logic would go here if you add it to your API
              setState(() {
                _notifications.removeAt(index);
              });
            } else {
              // Mark as read
              _appointmentManager.markNotificationAsRead(notif.notificationId);
              setState(() {
                final updatedNotif = AyursutraNotification(
                  notificationId: notif.notificationId,
                  senderAyursutraId: notif.senderAyursutraId,
                  receiverAyursutraId: notif.receiverAyursutraId,
                  type: notif.type,
                  title: notif.title,
                  message: notif.message,
                  data: notif.data,
                  priority: notif.priority,
                  createdAt: notif.createdAt,
                  isRead: true,
                );
                _notifications[index] = updatedNotif;
              });
            }
          },
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 4.0,
            ),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: notif.isRead
                    ? primaryTeal.withOpacity(0.1)
                    : primaryTeal.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getNotificationIcon(notif.type),
                color: primaryTeal,
                size: 24,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    notif.title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: notif.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                      fontSize: 16,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
                Text(
                  _formatTimeAgo(notif.createdAt),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  notif.message,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: notif.isRead
                        ? const Color(0xFF0F172A).withOpacity(0.7)
                        : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            // Show an indicator for unread notifications
            trailing: notif.isRead
                ? null
                : Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: primaryTeal,
                      shape: BoxShape.circle,
                    ),
                  ),
            onTap: () {
              // Mark as read on tap
              if (!notif.isRead) {
                _appointmentManager.markNotificationAsRead(
                  notif.notificationId,
                );
                setState(() {
                  final updatedNotif = AyursutraNotification(
                    notificationId: notif.notificationId,
                    senderAyursutraId: notif.senderAyursutraId,
                    receiverAyursutraId: notif.receiverAyursutraId,
                    type: notif.type,
                    title: notif.title,
                    message: notif.message,
                    data: notif.data,
                    priority: notif.priority,
                    createdAt: notif.createdAt,
                    isRead: true,
                  );
                  _notifications[index] = updatedNotif;
                });
              }

              // Handle notification tap based on type
              _handleNotificationTap(notif);
            },
          ),
        );
      },
    );
  }

  void _handleNotificationTap(AyursutraNotification notification) {
    // Handle different notification types
    switch (notification.type) {
      case 'appointment_request':
      case 'appointment_confirmed':
      case 'appointment_cancelled':
      case 'appointment_rescheduled':
        // Navigate to appointments page
        Navigator.pushNamed(context, '/appointments');
        break;
      case 'prescription_ready':
        // Navigate to prescriptions or reports page
        Navigator.pushNamed(context, '/reports');
        break;
      default:
        // Do nothing for other types
        break;
    }
  }

  @override
  void dispose() {
    _appointmentManager.dispose();
    super.dispose();
  }
}
