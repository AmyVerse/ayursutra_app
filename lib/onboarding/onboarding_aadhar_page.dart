import 'package:ayursutra_app/root.dart';
import 'package:flutter/material.dart';
import 'package:ayursutra_app/theme/colors.dart';

class OnboardingAadharPage extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onNext;
  const OnboardingAadharPage({super.key, required this.controller, required this.onNext});

  void _finish(BuildContext context) {
    // 1. Execute the parent callback (this is likely where you save the data).
    onNext();
    
    // 2. Correct navigation: use pushReplacement with MaterialPageRoute
    // to navigate directly to the HomePage widget.
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const RootPage()),
        (route) => false,
      );
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
              Text('Aadhaar Number (optional)', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: secondaryDark, fontFamily: 'Poppins')),
              const SizedBox(height: 12),
              Text('You can skip this step', style: TextStyle(fontSize: 18, color: secondaryDark.withOpacity(0.7), fontFamily: 'Poppins')),
              const SizedBox(height: 32),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Aadhaar Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                  onPressed: () => _finish(context),
                  child: const Text('Finish', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => _finish(context),
                child: Text('Skip', style: TextStyle(color: primaryTeal, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
