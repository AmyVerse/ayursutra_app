import 'package:ayursutra_app/pages/landing_page.dart';
import 'package:ayursutra_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Tridosh values (null initially)
  final List<int?> tridoshValues = [null, null, null];
  final List<String> tridoshLabels = ["Vata", "Pitta", "Kapha"];
  String _patientName = '';
  String _age = '';
  String _aadhar = '';
  // bool _notifInApp = true;
  bool _notifEmail = false;
  bool _notifPhone = false;
  bool _notifExpanded = false;

  // User object from API
  User? _user;
  final AuthService _authService = AuthService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });

    // Load API user data
    try {
      final user = await _authService.getUserDetails();
      if (user != null) {
        setState(() {
          _user = user;
          _patientName = user.name ?? 'Patient';
        });
      }
    } catch (e) {
      print('Error loading user details: $e');
    }

    // Load local preferences as fallback
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_patientName.isEmpty) {
        _patientName = 'Patient';
      }
      _age = prefs.getString('patient_age') ?? '';
      _aadhar = prefs.getString('aadhar_number') ?? '';
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color secondaryDark = Color(0xFF0F172A);
    const Color cardBg = Color(0xFFF7F7F7);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: secondaryDark,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: secondaryDark),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Card with user information
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 18,
                ),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: primaryTeal),
                      )
                    : Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: secondaryDark.withOpacity(0.08),
                            child: const Icon(
                              Icons.person,
                              color: secondaryDark,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _user?.name ?? _patientName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'AyurSutra ID: ${_user?.ayursutraId ?? 'AYR123456'}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: secondaryDark.withOpacity(0.7),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                if (_user?.email != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    _user!.email!,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: secondaryDark.withOpacity(0.7),
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 24),

              // Info Container for Age, Aadhar, and Tridosh Analysis
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 18, 0),
                child: Text(
                  'Info',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    fontFamily: 'Poppins',
                    color: primaryTeal,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: primaryTeal.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: primaryTeal.withOpacity(0.07),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 18.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.cake, color: primaryTeal),
                          const SizedBox(width: 8),
                          Text(
                            'Age: ',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            _age.isNotEmpty ? _age : '--',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.credit_card, color: primaryTeal),
                          const SizedBox(width: 8),
                          Text(
                            'Aadhar: ',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            _aadhar.isNotEmpty ? _aadhar : '--',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Tridosh Analysis Section
                      Text(
                        'Prakriti',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(3, (index) {
                          Color doshColors = [
                            const Color.fromARGB(255, 255, 208, 0),
                            const Color(0xFFE74C3C),
                            const Color.fromARGB(255, 53, 126, 237),
                          ][index];
                          return Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: doshColors.withOpacity(0.3),
                                        width: 6,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: CircularProgressIndicator(
                                      value: tridoshValues[index] != null
                                          ? tridoshValues[index]! / 100
                                          : 0,
                                      strokeWidth: 6,
                                      backgroundColor: Colors.transparent,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        doshColors,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Center(
                                      child: Text(
                                        tridoshValues[index] != null
                                            ? "${tridoshValues[index]}%"
                                            : "--",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: doshColors,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                tridoshLabels[index],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0F172A),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implement prakriti test navigation or logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryTeal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          child: const Text('Run Test'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Settings title OUTSIDE the container
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 18, 18, 0),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    fontFamily: 'Poppins',
                    color: primaryTeal,
                  ),
                ),
              ),
              // Notifications section INSIDE the container
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _notifExpanded = !_notifExpanded;
                  });
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: primaryTeal.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: primaryTeal.withOpacity(0.07),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18.0,
                          vertical: 18.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.notifications, color: primaryTeal),
                                const SizedBox(width: 8),
                                const Text(
                                  'Notifications',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              _notifExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: primaryTeal,
                            ),
                          ],
                        ),
                      ),
                      if (_notifExpanded)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18.0,
                            vertical: 8.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'In-app',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const Spacer(),
                                  Switch(
                                    value: true,
                                    activeColor: primaryTeal,
                                    onChanged: null, // disables interaction
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Email',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const Spacer(),
                                  Switch(
                                    value: _notifEmail,
                                    activeColor: primaryTeal,
                                    onChanged: (val) {
                                      setState(() => _notifEmail = val);
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Phone',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const Spacer(),
                                  Switch(
                                    value: _notifPhone,
                                    activeColor: primaryTeal,
                                    onChanged: (val) {
                                      setState(() => _notifPhone = val);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Logout Button
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Log Out',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryTeal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    // Clear all session data using AuthService
                    final authService = AuthService();
                    await authService.logout();

                    // Clear onboarding data
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('appointment_doctor');
                    await prefs.remove('appointment_specialization');
                    await prefs.remove('appointment_date');
                    await prefs.remove('patient_age');
                    await prefs.remove('aadhar_number');

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LandingPage(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
