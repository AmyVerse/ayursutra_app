import 'package:ayursutra_app/models/appointment.dart';
import 'package:ayursutra_app/services/appointment_manager.dart';
import 'package:ayursutra_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  DateTime _selectedDate = DateTime.now();
  final AppointmentManager _appointmentManager = AppointmentManager();
  List<Appointment> _appointments = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
    _listenForNewAppointments();
  }

  Future<void> _loadAppointments() async {
    try {
      if (!mounted) return;

      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      // Initialize the manager if needed
      await _appointmentManager.initialize();

      // Fetch appointments
      final appointments = await _appointmentManager.getMyAppointments();

      if (!mounted) return;

      setState(() {
        _appointments = appointments;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading appointments: $e');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _listenForNewAppointments() {
    // We could add real-time appointment updates using the notification stream
    // For example:
    // _appointmentManager.notificationStream.listen((notification) {
    //   if (notification.type == 'appointment_update' && mounted) {
    //     _loadAppointments();
    //   }
    // });

    // For now we'll just refresh appointments every time we open the page
  }

  // These methods have been removed as they're unused
  // We're now formatting dates directly in the build method

  @override
  Widget build(BuildContext context) {
    const Color secondaryDark = Color(0xFF0F172A);
    const Color pureWhite = Color(0xFFFFFFFF);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: _loadAppointments,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  'Appointments',
                  style: TextStyle(
                    color: secondaryDark,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Schedule your Ayurvedic consultation',
                  style: TextStyle(
                    color: secondaryDark.withOpacity(0.7),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 24),

                // Calendar Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: pureWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: secondaryDark.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _selectedDate,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDate, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDate = selectedDay;
                      });
                    },
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: secondaryDark.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: secondaryDark,
                        shape: BoxShape.circle,
                      ),
                      weekendTextStyle: TextStyle(
                        color: secondaryDark.withOpacity(0.7),
                      ),
                      defaultTextStyle: TextStyle(color: secondaryDark),
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        color: secondaryDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Upcoming Appointments
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Your Appointments',
                      style: TextStyle(
                        color: secondaryDark,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    if (_isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: primaryTeal,
                          strokeWidth: 2,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                _isLoading && _appointments.isEmpty
                    ? const Center(child: Text('Loading appointments...'))
                    : _hasError
                    ? _buildErrorState(secondaryDark)
                    : _appointments.isEmpty
                    ? _buildEmptyState(secondaryDark)
                    : _buildAppointmentsList(secondaryDark, pureWhite),
                const SizedBox(height: 100), // Extra space for floating nav
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(Color secondaryDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.error_outline, size: 64, color: Colors.red),
          ),
          const SizedBox(height: 24),
          const Text(
            'Failed to load appointments',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your connection and try again',
            style: TextStyle(
              color: secondaryDark.withOpacity(0.7),
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _loadAppointments,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryTeal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Retry',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Color secondaryDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: primaryTeal.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_today_rounded,
              size: 64,
              color: Color(0xFF14B8A6),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No appointments scheduled',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Book your first consultation with a Vaidya',
            style: TextStyle(
              color: secondaryDark.withOpacity(0.7),
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Book appointment logic
              Navigator.pushNamed(context, '/doctors');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryTeal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Find a Doctor',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(Color secondaryDark, Color pureWhite) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _appointments.length,
      itemBuilder: (context, index) {
        final appointment = _appointments[index];

        // Determine status color based on appointment status
        Color statusColor;
        switch (appointment.status.toLowerCase()) {
          case 'pending':
          case 'upcoming':
            statusColor = Colors.orange;
            break;
          case 'confirmed':
            statusColor = primaryTeal;
            break;
          case 'cancelled':
            statusColor = Colors.red;
            break;
          case 'completed':
            statusColor = Colors.blue;
            break;
          default:
            statusColor = Colors.grey;
        }

        // Format date and time
        final formattedDate = DateFormat(
          'd MMM yyyy',
        ).format(appointment.dateTime);
        final formattedTime = DateFormat('h:mm a').format(appointment.dateTime);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: pureWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: secondaryDark.withOpacity(0.1), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.medical_services,
                  color: statusColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dr. Appointment", // This would normally come from a doctor profile
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appointment.treatmentType ?? "General Consultation",
                      style: TextStyle(
                        color: secondaryDark.withOpacity(0.6),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$formattedDate • $formattedTime',
                      style: TextStyle(
                        color: secondaryDark.withOpacity(0.8),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  appointment.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _appointmentManager.dispose();
    super.dispose();
  }
}
