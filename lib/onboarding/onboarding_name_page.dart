import 'package:flutter/material.dart';
import 'package:ayursutra_app/theme/colors.dart';

class OnboardingNamePage extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onNext;
  const OnboardingNamePage({super.key, required this.controller, required this.onNext});

  @override
  State<OnboardingNamePage> createState() => _OnboardingNamePageState();
}

class _OnboardingNamePageState extends State<OnboardingNamePage> {
  String? _error;

  void _validateAndNext() {
    if (widget.controller.text.trim().isEmpty) {
      setState(() {
        _error = 'Name is required';
      });
      return;
    }
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    const Color secondaryDark = Color(0xFF0F172A);
    const Color pureWhite = Color(0xFFFFFFFF);
    return Scaffold(
      backgroundColor: pureWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 32),
              Image.asset('assets/icon.png', height: 80),
              const SizedBox(height: 24),
              Text('Let’s get to know you!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: secondaryDark, fontFamily: 'Poppins')),
              const SizedBox(height: 12),
              Text('What is your name?', style: TextStyle(fontSize: 18, color: secondaryDark.withOpacity(0.7), fontFamily: 'Poppins')),
              const SizedBox(height: 32),
              TextField(
                controller: widget.controller,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  errorText: _error,
                  filled: true,
                  fillColor: secondaryDark.withOpacity(0.05),
                  labelStyle: TextStyle(color: secondaryDark),
                ),
                style: TextStyle(color: secondaryDark, fontSize: 18),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryTeal,
                    foregroundColor: pureWhite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _validateAndNext,
                  child: const Text('Next', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
