import 'package:ayursutra_app/pages/landing_page.dart';
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
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
      _loading = false;
    });
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
      home: _onboardingComplete ? const LandingPage() : const OnboardingSlider(),
    );
  }
}
