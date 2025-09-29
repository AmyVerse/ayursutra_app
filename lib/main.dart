import 'package:ayursutra_app/pages/appointments_page.dart';
import 'package:ayursutra_app/pages/landing_page.dart';
import 'package:ayursutra_app/pages/notification_page.dart';
import 'package:ayursutra_app/pages/report_page.dart';
import 'package:ayursutra_app/root.dart';
import 'package:ayursutra_app/screens/doctor_search_screen.dart';
import 'package:ayursutra_app/services/appointment_manager.dart';
import 'package:ayursutra_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding/onboarding_slider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _onboardingComplete = false;
  bool _isLoggedIn = false;
  bool _loading = true;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _checkOnboarding();
    await _checkAuthStatus();

    // Initialize appointment manager if user is logged in
    if (_isLoggedIn) {
      try {
        final appointmentManager = AppointmentManager();
        await appointmentManager.initialize();
      } catch (e) {
        print('Error initializing appointment manager: $e');
      }
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    _onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
  }

  Future<void> _checkAuthStatus() async {
    _isLoggedIn = await _authService.isLoggedIn();
    // No need to check role since we only support patient flow now
  }

  @override
  Widget build(BuildContext context) {
    const Color pureWhite = Color(0xFFFFFFFF);
    const Color secondaryDark = Color(0xFF0F172A);
    if (_loading) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    return MaterialApp(
      title: 'Ayursutra App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: pureWhite,
        appBarTheme: const AppBarTheme(
          backgroundColor: pureWhite,
          elevation: 0,
          iconTheme: IconThemeData(color: secondaryDark),
          toolbarTextStyle: TextStyle(color: secondaryDark),
          titleTextStyle: TextStyle(color: secondaryDark),
        ),
      ),
      home: _getInitialScreen(),
      routes: {
        '/doctors': (context) => DoctorSearchScreen(),
        '/appointments': (context) => const AppointmentsPage(),
        '/reports': (context) => const ReportPage(),
        '/notifications': (context) => const NotificationPage(),
      },
    );
  }

  Widget _getInitialScreen() {
    // First check onboarding
    if (!_onboardingComplete) {
      return const OnboardingSlider();
    }

    // Then check if user is logged in
    if (_isLoggedIn) {
      // Only patient flow remains
      return const RootPage(); // Patient dashboard
    }

    // Show landing page for authentication
    return const LandingPage();
  }
}
