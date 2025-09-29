import 'package:ayursutra_app/models/doctor.dart' as api_model;
import 'package:ayursutra_app/pages/appointments_page.dart';
import 'package:ayursutra_app/pages/chatbot_page.dart';
import 'package:ayursutra_app/pages/notification_page.dart';
import 'package:ayursutra_app/pages/profile_page.dart';
import 'package:ayursutra_app/screens/doctor_detail_screen.dart' as api_screen;
import 'package:ayursutra_app/screens/doctor_search_screen.dart';
import 'package:ayursutra_app/services/auth_service.dart';
import 'package:ayursutra_app/services/doctor_service.dart';
import 'package:ayursutra_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _patientName = '';
  User? _user;
  final AuthService _authService = AuthService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatientName();
  }

  Future<void> _loadPatientName() async {
    setState(() {
      _isLoading = true;
    });

    // First try to get user details from API
    try {
      final user = await _authService.getUserDetails();
      if (user != null) {
        setState(() {
          _user = user;
          _patientName = user.name ?? '';
        });
      }
    } catch (e) {
      print('Error loading user details: $e');
    }

    // If API failed or name is empty, use a default value instead
    if (_patientName.isEmpty) {
      setState(() {
        _patientName = 'Patient';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom Header Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'AyurSutra',
                      style: TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.notifications_none,
                            color: Color(0xFF0F172A),
                            size: 26,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NotificationPage(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: const Duration(
                                  milliseconds: 300,
                                ),
                                reverseTransitionDuration: const Duration(
                                  milliseconds: 250,
                                ),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                      return ProfilePage();
                                    },
                                transitionsBuilder:
                                    (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      final offsetAnimation =
                                          Tween<Offset>(
                                            begin: const Offset(1.0, 0.0),
                                            end: Offset.zero,
                                          ).animate(
                                            CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.easeOut,
                                            ),
                                          );
                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: primaryTeal.withOpacity(0.1),
                            child: const Icon(
                              Icons.person,
                              color: primaryTeal,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Greeting Section
                _isLoading
                    ? const SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: primaryTeal,
                        ),
                      )
                    : Text(
                        'Namaste ${_user?.name ?? (_patientName.isNotEmpty ? _patientName : 'Patient')} 👋',
                        style: const TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 22,
                          fontFamily: 'Poppins',
                        ),
                      ),
                const SizedBox(height: 4),
                Text(
                  'How is your health!',
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 24),
                // Search Bar with Chatbot Icon
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DoctorSearchScreen(),
                            ),
                          );
                        },
                        child: TextField(
                          enabled: false, // Disable direct input
                          style: const TextStyle(color: Color(0xFF0F172A)),
                          decoration: InputDecoration(
                            hintText: 'Search for doctor',
                            hintStyle: TextStyle(
                              color: const Color(0xFF0F172A).withOpacity(0.6),
                              fontFamily: 'Poppins',
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Color(0xFF0F172A),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: const Color(
                              0xFF0F172A,
                            ).withOpacity(0.05),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatbotPage(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: primaryTeal,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryTeal.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.chat_bubble_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Upcoming Appointments
                UpcomingAppointmentsCard(key: UniqueKey()),
                const SizedBox(height: 24),
                // Popular Doctors Section
                PopularDoctorsSection(),
                const SizedBox(height: 100), // Extra space for floating nav
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UpcomingAppointmentsCard extends StatefulWidget {
  const UpcomingAppointmentsCard({super.key});

  @override
  State<UpcomingAppointmentsCard> createState() =>
      _UpcomingAppointmentsCardState();
}

class _UpcomingAppointmentsCardState extends State<UpcomingAppointmentsCard> {
  String? doctorName;
  String? specialization;
  String? appointmentDate;

  @override
  void initState() {
    super.initState();
    _loadAppointment();
  }

  Future<void> _loadAppointment() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      doctorName = prefs.getString('appointment_doctor');
      specialization = prefs.getString('appointment_specialization');
      appointmentDate = prefs.getString('appointment_date');
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color secondaryDark = Color(0xFF0F172A);
    final bool noAppointment = doctorName == null || doctorName!.trim().isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Upcoming Appointment',
              style: TextStyle(
                color: secondaryDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppointmentsPage(),
                  ),
                );
              },
              child: const Text(
                'View all',
                style: TextStyle(
                  color: primaryTeal,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 245, 245, 245),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: noAppointment
              ? Column(
                  children: [
                    Icon(
                      Icons.event_busy,
                      color: secondaryDark.withOpacity(0.3),
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No appointments yet',
                      style: TextStyle(
                        color: secondaryDark.withOpacity(0.7),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: secondaryDark.withOpacity(0.2),
                          child: const Icon(
                            Icons.person,
                            color: secondaryDark,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctorName ?? '',
                                style: const TextStyle(
                                  color: secondaryDark,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                specialization ?? '',
                                style: const TextStyle(
                                  color: secondaryDark,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      appointmentDate ?? '',
                      style: const TextStyle(
                        color: secondaryDark,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class PopularDoctorsSection extends StatefulWidget {
  const PopularDoctorsSection({super.key});

  @override
  State<PopularDoctorsSection> createState() => _PopularDoctorsSectionState();
}

class _PopularDoctorsSectionState extends State<PopularDoctorsSection> {
  final DoctorService _doctorService = DoctorService();
  List<api_model.Doctor> _doctors = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    try {
      final doctors = await _doctorService.searchDoctors();
      setState(() {
        _doctors = doctors.take(4).toList(); // Get the first 4 doctors
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading doctors: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Widget _buildDoctorGrid() {
    return Column(
      children: [
        for (int i = 0; i < _doctors.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Expanded(child: _buildDoctorCard(_doctors[i])),
                const SizedBox(width: 16),
                Expanded(
                  child: i + 1 < _doctors.length
                      ? _buildDoctorCard(_doctors[i + 1])
                      : Container(), // Empty container for odd number of doctors
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDoctorCard(api_model.Doctor doctor) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                api_screen.DoctorDetailScreen(doctorId: doctor.id),
          ),
        );
      },
      child: DoctorCard(
        name: doctor.name,
        specialty: doctor.specialization,
        rating: double.tryParse(doctor.rating) ?? 0.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color secondaryDark = Color(0xFF0F172A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Popular doctor near you',
              style: TextStyle(
                color: secondaryDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to doctor search screen with proper initialization
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DoctorSearchScreen(),
                    settings: const RouteSettings(name: 'DoctorSearchScreen'),
                  ),
                );
              },
              child: const Text(
                'View all',
                style: TextStyle(
                  color: primaryTeal,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _hasError
            ? Center(
                child: Column(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(height: 8),
                    const Text('Failed to load doctors'),
                    TextButton(
                      onPressed: _loadDoctors,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : _doctors.isEmpty
            ? const Center(child: Text('No doctors available'))
            : _buildDoctorGrid(),
      ],
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final double rating;

  const DoctorCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    const Color secondaryDark = Color(0xFF0F172A);
    const Color pureWhite = Color(0xFFFFFFFF);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: secondaryDark.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: primaryTeal.withOpacity(0.1),
            child: const Icon(Icons.person, color: primaryTeal, size: 30),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              color: secondaryDark,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            specialty,
            style: TextStyle(
              color: secondaryDark.withOpacity(0.7),
              fontSize: 12,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [..._buildStarRating()],
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: secondaryDark,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: pureWhite,
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStarRating() {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    // Add full stars
    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.orange, size: 14));
    }

    // Add half star if applicable
    if (hasHalfStar) {
      stars.add(const Icon(Icons.star_half, color: Colors.orange, size: 14));
    }

    // Add empty stars to complete the 5-star rating
    int emptyStars = 5 - fullStars;
    if (hasHalfStar) {
      emptyStars--;
    }
    for (int i = 0; i < emptyStars; i++) {
      stars.add(
        Icon(Icons.star_border, color: Colors.grey.withOpacity(0.5), size: 14),
      );
    }

    return stars;
  }
}
