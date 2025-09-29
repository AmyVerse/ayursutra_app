// screens/doctor_search_screen.dart
import 'package:flutter/material.dart';

import '../models/doctor.dart';
import '../services/auth_service.dart';
import '../services/doctor_service.dart';

class DoctorSearchScreen extends StatefulWidget {
  @override
  _DoctorSearchScreenState createState() => _DoctorSearchScreenState();
}

class _DoctorSearchScreenState extends State<DoctorSearchScreen> {
  final DoctorService _doctorService = DoctorService();
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();

  List<Doctor> _doctors = [];
  bool _isLoading = true; // Start with loading true
  String? _error;
  String? _patientAyursutraId;

  @override
  void initState() {
    super.initState();
    // Delay a tiny bit to ensure the screen is fully rendered before loading data
    Future.delayed(Duration.zero, () {
      _loadDoctors();
      _loadUserDetails();
    });
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUserDetails() async {
    try {
      final userDetails = await _authService.getUserDetails();
      // Check if widget is still mounted before calling setState
      if (mounted && userDetails != null) {
        setState(() {
          _patientAyursutraId = userDetails.ayursutraId;
        });
      }
    } catch (e) {
      print('Error loading user details: $e');
    }
  }

  Future<void> _loadDoctors() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      print('Fetching doctors...');
      final doctors = await _doctorService.searchDoctors();
      if (mounted) {
        setState(() {
          _doctors = doctors;
          _isLoading = false;
        });
      }
      print('Loaded ${doctors.length} doctors');
    } catch (e) {
      print('Error loading doctors: $e');
      if (mounted) {
        setState(() {
          _error = 'Failed to load doctors: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _searchDoctors() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      _loadDoctors();
      return;
    }

    // Check if widget is still mounted before setting state
    if (mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final doctors = await _doctorService.searchDoctors(query: query);
      // Check if widget is still mounted before setting state
      if (mounted) {
        setState(() {
          _doctors = doctors;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Check if widget is still mounted before setting state
      if (mounted) {
        setState(() {
          _error = 'Search failed: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _quickSearch(String searchTerm) {
    _searchController.text = searchTerm;
    _searchDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Doctors'),
        backgroundColor: Color(0xFF10B981), // emerald-600 equivalent
      ),
      body: Column(
        children: [
          // Search Box
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find Ayurvedic Doctors',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText:
                              'Search by name, specialization, or location...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (_) => _searchDoctors(),
                      ),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _searchDoctors,
                      child: Text(_isLoading ? 'Searching...' : 'Search'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF10B981),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Quick filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Panchakarma'),
                      _buildFilterChip('Skin Care'),
                      _buildFilterChip('Mumbai'),
                      _buildFilterChip('Delhi'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Search Results
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _error != null
                ? _buildErrorWidget()
                : _doctors.isEmpty
                ? _buildEmptyStateWidget()
                : _buildDoctorsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        label: Text(label),
        backgroundColor: Colors.grey[200],
        onPressed: () => _quickSearch(label),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
            SizedBox(height: 16),
            Text(
              'Error',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(_error ?? 'Failed to load doctors'),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _loadDoctors, child: Text('Try Again')),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStateWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search, size: 48, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              _searchController.text.isNotEmpty
                  ? 'No doctors found'
                  : 'No doctors available',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              _searchController.text.isNotEmpty
                  ? 'Try searching with different keywords like "Panchakarma", "Mumbai", or "Dermatology"'
                  : 'There are currently no verified doctors in the system.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorsList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _doctors.length,
      itemBuilder: (context, index) {
        final doctor = _doctors[index];
        return _buildDoctorCard(doctor);
      },
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: TextStyle(
                          fontSize: 18,
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
                      Text(
                        doctor.location,
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),

                // Rating and verified badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        Text(
                          doctor.rating,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    if (doctor.isVerified)
                      Container(
                        margin: EdgeInsets.only(top: 4),
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

            SizedBox(height: 12),

            // Experience and patients
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                      children: [
                        TextSpan(text: 'Experience: '),
                        TextSpan(
                          text: doctor.experience.contains('year')
                              ? doctor.experience
                              : '${doctor.experience} years',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                      children: [
                        TextSpan(text: 'Patients: '),
                        TextSpan(
                          text: '${doctor.patientsChecked}+',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Biography
            if (doctor.biography != null && doctor.biography!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  doctor.biography!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                ),
              ),

            SizedBox(height: 16),

            // Book appointment button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _patientAyursutraId == null
                    ? null
                    : () => _requestAppointment(doctor),
                child: Text(
                  _patientAyursutraId == null
                      ? '📅 Login to Book'
                      : '📅 Request Appointment',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF10B981),
                  disabledBackgroundColor: Colors.grey[400],
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            SizedBox(height: 4),
            Center(
              child: Text(
                'Doctor ID: ${doctor.ayursutraId}',
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestAppointment(Doctor doctor) async {
    if (_patientAyursutraId == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      final success = await _doctorService.requestAppointment(
        doctor.id,
        doctor.name,
        _patientAyursutraId!,
      );

      Navigator.of(context).pop(); // Close loading dialog

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
      Navigator.of(context).pop(); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
