import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// You'll likely have a Doctor model in a real app.
// For this example, we'll define a simple one here.
class Doctor {
  final String name;
  final String specialization;
  final String biography;
  final double rating;
  final int yearsOfExperience;
  final String patientsChecked;
  final String imageUrl;
  final String location; // New location field

  Doctor({
    required this.name,
    required this.specialization,
    required this.biography,
    required this.rating,
    required this.yearsOfExperience,
    required this.patientsChecked,
    required this.imageUrl,
    required this.location,
  });
}

class DoctorDetailScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF90EE90); // Light Green
    const Color darkBlue = Color(0xFF0F172A);
    const Color lightGrey = Color(0xFFF0F0F0); // For background of cards

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: darkBlue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Doctor Details',
          style: TextStyle(color: darkBlue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true, // Allows content to go behind the app bar
      body: Stack(
        children: [
          // Background Gradient (if desired, adjust colors)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFE0F7FA), Color(0xFFFFFFFF)], // Light blue to white gradient
              ),
            ),
          ),
          // Main content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: kToolbarHeight + 40), // Space for the app bar
                  // Doctor Profile Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: lightGrey,
                          backgroundImage: NetworkImage(doctor.imageUrl),
                          onBackgroundImageError: (exception, stackTrace) {
                            // Fallback for image loading errors
                            print("Image failed to load: $exception");
                          },
                          child: doctor.imageUrl.isEmpty // If image URL is empty or fails
                              ? Icon(Icons.person, size: 60, color: Colors.grey[600])
                              : null,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          doctor.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: darkBlue,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          doctor.specialization,
                          style: TextStyle(
                            fontSize: 16,
                            color: darkBlue.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildRatingStars(doctor.rating),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Biography Section
                  Text(
                    'Biography',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    doctor.biography,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: darkBlue.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Specialty & Experience Section
                  Text(
                    'Specialty',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: lightGrey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Years of experience',
                              style: TextStyle(color: darkBlue.withOpacity(0.7)),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${doctor.yearsOfExperience} Years',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: darkBlue,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Patients checked',
                              style: TextStyle(color: darkBlue.withOpacity(0.7)),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${doctor.patientsChecked}+',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: darkBlue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Location Section (New)
                  Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: lightGrey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: darkBlue, size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            doctor.location,
                            style: const TextStyle(
                              fontSize: 16,
                              color: darkBlue,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30), // Increased spacing

                  // Book Appointment Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        String? aadhar = prefs.getString('aadhar_number');
                        if (aadhar == null || aadhar.trim().isEmpty) {
                          String enteredAadhar = '';
                          await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Enter Aadhar Number', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                                content: TextField(
                                  keyboardType: TextInputType.number,
                                  maxLength: 12,
                                  decoration: const InputDecoration(
                                    hintText: 'Aadhar Number',
                                    counterText: '',
                                  ),
                                  onChanged: (value) {
                                    enteredAadhar = value;
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      if (enteredAadhar.trim().length == 12) {
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    child: const Text('Confirm', style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF0F172A))),
                                  ),
                                ],
                              );
                            },
                          );
                          if (enteredAadhar.trim().length == 12) {
                            await prefs.setString('aadhar_number', enteredAadhar.trim());
                            aadhar = enteredAadhar.trim();
                          } else {
                            // If not valid, do not proceed
                            return;
                          }
                        }
                        // Save appointment details to SharedPreferences
                        final now = DateTime.now();
                        final formattedDate = "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
                        await prefs.setString('appointment_doctor', doctor.name);
                        await prefs.setString('appointment_specialization', doctor.specialization);
                        await prefs.setString('appointment_date', formattedDate);
                        // Show top notification
                        final overlay = Overlay.of(context);
                        final overlayEntry = OverlayEntry(
                          builder: (context) => Positioned(
                            top: MediaQuery.of(context).padding.top + 16,
                            left: 16,
                            right: 16,
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Color(0xFF90EE90),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Color(0xFF0F172A)),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Appointment booked with ${doctor.name}',
                                        style: const TextStyle(
                                          color: Color(0xFF0F172A),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                        overlay.insert(overlayEntry);
                        Future.delayed(const Duration(seconds: 2), () {
                          overlayEntry.remove();
                        });
                        Navigator.pop(context); // Go back to home
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen, // Button color
                        foregroundColor: Colors.white, // Text color
                        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Book Appointment'),
                    ),
                  ),
                  const SizedBox(height: 20), // Padding at the bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    for (int i = 0; i < 5; i++) {
      if (i < fullStars) {
        stars.add(const Icon(Icons.star_rounded, color: Colors.amber, size: 24));
      } else if (hasHalfStar && i == fullStars) {
        stars.add(const Icon(Icons.star_half_rounded, color: Colors.amber, size: 24));
      } else {
        stars.add(Icon(Icons.star_border_rounded, color: Colors.grey[400], size: 24));
      }
    }
    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }
}

// Example of how to use this screen (e.g., in a navigation flow)
// You might call this from a list of doctors in another screen.
class DoctorsListScreen extends StatelessWidget {
  DoctorsListScreen({super.key});

  final List<Doctor> _doctors = [
    Doctor(
      name: 'Dr. Robert Fox',
      specialization: 'Dental specialist',
      biography:
          'Dr. Robert is a dental specialist. He received her Doctor of Dental Surgery (DDS) degree from he pursued specialized training in orthodontics at the Read more',
      rating: 4.5,
      yearsOfExperience: 10,
      patientsChecked: '25,454',
      imageUrl: 'https://cdn.pixabay.com/photo/2017/08/07/20/05/people-2606558_960_720.jpg', // Placeholder image
      location: '123 Main St, Anytown, CA 90210, USA',
    ),
    Doctor(
      name: 'Dr. Jane Doe',
      specialization: 'Cardiologist',
      biography:
          'Dr. Jane Doe is an experienced cardiologist dedicated to heart health. She has published numerous papers on cardiovascular diseases and preventative care.',
      rating: 4.8,
      yearsOfExperience: 15,
      patientsChecked: '30,123',
      imageUrl: 'https://cdn.pixabay.com/photo/2017/03/06/17/57/doctor-2122396_960_720.jpg', // Another placeholder
      location: '456 Oak Ave, Metropolis, NY 10001, USA',
    ),
    // Add more doctors as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Doctors'),
        backgroundColor: const Color(0xFFE0F7FA), // Light blue app bar
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _doctors.length,
        itemBuilder: (context, index) {
          final doctor = _doctors[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 15.0),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(doctor.imageUrl),
                onBackgroundImageError: (exception, stackTrace) {
                  print("Image failed to load: $exception");
                },
              ),
              title: Text(doctor.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(doctor.specialization),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorDetailScreen(doctor: doctor),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}