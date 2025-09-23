import 'package:ayursutra_app/pages/appointments_page.dart';
import 'package:ayursutra_app/pages/profile_page.dart';
import 'package:ayursutra_app/theme/colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color secondaryDark = Color(0xFF0F172A);

    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Header Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Title and Profile Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'AyurSutra',
                        style: TextStyle(
                          color: secondaryDark,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
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
                  const SizedBox(height: 30),
                  // Greeting Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Namaste Lokesh 👋',
                        style: TextStyle(
                          color: secondaryDark,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'How is your health!',
                        style: TextStyle(
                          color: secondaryDark.withOpacity(0.7),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Search Bar
              TextField(
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
                  fillColor: const Color(0xFF0F172A).withOpacity(0.05),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 20,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              // Upcoming Appointments
              const UpcomingAppointmentsCard(),
              const SizedBox(height: 24),

              // Popular Doctors Section
              const PopularDoctorsSection(),
              const SizedBox(height: 100), // Extra space for floating nav
            ],
          ),
        ),
      ),
    );
  }
}

class UpcomingAppointmentsCard extends StatelessWidget {
  const UpcomingAppointmentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    const Color secondaryDark = Color(0xFF0F172A);
    const Color pureWhite = Color(0xFFFFFFFF);

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
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 245, 245, 245),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
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
                        const Text(
                          'Dr. Rajesh Sharma',
                          style: TextStyle(
                            color: secondaryDark,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Text(
                              '08.30 am',
                              style: TextStyle(
                                color: secondaryDark,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: secondaryDark,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Text(
                              'Panchakarma Specialist',
                              style: TextStyle(
                                color: secondaryDark,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '25 September 2025',
                    style: TextStyle(
                      color: secondaryDark,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle join call action
                    },
                    label: const Text(
                      'Expand',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryTeal, // Light green
                      foregroundColor: pureWhite,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PopularDoctorsSection extends StatelessWidget {
  const PopularDoctorsSection({super.key});

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
              onPressed: () {},
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
        Row(
          children: [
            Expanded(
              child: DoctorCard(
                name: 'Dr. Priya Nair',
                specialty: 'Rasayana Specialist',
                rating: 4.8,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DoctorCard(
                name: 'Dr. Vikram Singh',
                specialty: 'Shalya Tantra',
                rating: 4.6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DoctorCard(
                name: 'Dr. Meera Gupta',
                specialty: 'Kayachikitsa',
                rating: 4.7,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DoctorCard(
                name: 'Dr. Amit Joshi',
                specialty: 'Panchakarma',
                rating: 4.9,
              ),
            ),
          ],
        ),
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
                children: [
                  for (int i = 0; i < 5; i++)
                    Icon(
                      Icons.star,
                      color: i < rating.floor()
                          ? Colors.orange
                          : Colors.grey.withOpacity(0.3),
                      size: 14,
                    ),
                  if (rating % 1 != 0)
                    Icon(Icons.star_half, color: Colors.orange, size: 14),
                ],
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
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
}
