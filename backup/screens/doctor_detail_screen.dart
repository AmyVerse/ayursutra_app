// screens/doctor_detail_screen.dart
import 'package:flutter/material.dart';

import 'package:ayursutra_app/models/doctor.dart';
import 'package:ayursutra_app/services/auth_service.dart';
import 'package:ayursutra_app/services/doctor_service.dart';

class DoctorDetailScreen extends StatefulWidget {
  final int doctorId;

  const DoctorDetailScreen({Key? key, required this.doctorId})
    : super(key: key);

  @override
  _DoctorDetailScreenState createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  final DoctorService _doctorService = DoctorService();
  final AuthService _authService = AuthService();

  Doctor? _doctor;
  bool _isLoading = true;
  String? _error;
  String? _patientAyursutraId;
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();
    _loadDoctor();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final userDetails = await _authService.getUserDetails();
    if (userDetails != null) {
      setState(() {
        _patientAyursutraId = userDetails.ayursutraId;
      });
    }
  }

  Future<void> _loadDoctor() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final doctor = await _doctorService.getDoctorById(widget.doctorId);
      setState(() {
        _doctor = doctor;
        _isLoading = false;
        _error = doctor == null ? 'Doctor not found' : null;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load doctor: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Doctor Details'),
          backgroundColor: Color(0xFF10B981),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _doctor == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Doctor Details'),
          backgroundColor: Color(0xFF10B981),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
              SizedBox(height: 16),
              Text(
                _error ?? 'Doctor not found',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: _loadDoctor, child: Text('Try Again')),
            ],
          ),
        ),
      );
    }

    final doctor = _doctor!;

    return Scaffold(
      appBar: AppBar(
        title: Text(doctor.name),
        backgroundColor: Color(0xFF10B981),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor header
            Container(
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFF10B981),
                        child: Text(
                          doctor.name
                              .split(' ')
                              .map((s) => s.isNotEmpty ? s[0] : '')
                              .join(''),
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctor.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              doctor.specialization,
                              style: TextStyle(
                                color: Color(0xFF10B981),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: 4),
                                Text(
                                  doctor.location,
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 18),
                              SizedBox(width: 4),
                              Text(
                                doctor.rating,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          if (doctor.isVerified)
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Verified',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green[800],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 8),

            // Statistics
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  _buildStatItem(
                    'Experience',
                    doctor.experience.contains('year')
                        ? doctor.experience
                        : '${doctor.experience} years',
                  ),
                  _buildStatItem('Patients', '${doctor.patientsChecked}+'),
                ],
              ),
            ),

            SizedBox(height: 8),

            // Biography
            if (doctor.biography != null && doctor.biography!.isNotEmpty)
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About Doctor',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      doctor.biography!,
                      style: TextStyle(color: Colors.grey[800], height: 1.5),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 8),

            // Contact
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  if (doctor.userEmail != null)
                    _buildContactItem(Icons.email, doctor.userEmail!),
                  if (doctor.userPhone != null)
                    _buildContactItem(Icons.phone, doctor.userPhone!),
                ],
              ),
            ),

            // Book appointment button
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _patientAyursutraId == null || _isBooking
                          ? null
                          : () => _requestAppointment(doctor),
                      child: Text(
                        _isBooking
                            ? 'Sending Request...'
                            : _patientAyursutraId == null
                            ? '📅 Login to Book'
                            : '📅 Request Appointment',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF10B981),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Doctor ID: ${doctor.ayursutraId}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          SizedBox(width: 12),
          Text(text, style: TextStyle(color: Colors.grey[800], fontSize: 15)),
        ],
      ),
    );
  }

  Future<void> _requestAppointment(Doctor doctor) async {
    if (_patientAyursutraId == null) return;

    setState(() {
      _isBooking = true;
    });

    try {
      final success = await _doctorService.requestAppointment(
        doctor.id,
        doctor.name,
        _patientAyursutraId!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? '✅ Appointment request sent!'
                : '❌ Failed to send request',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isBooking = false;
      });
    }
  }
}
