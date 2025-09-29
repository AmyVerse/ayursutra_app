import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding_aadhar_page.dart';
import 'onboarding_age_page.dart';

class OnboardingSlider extends StatefulWidget {
  const OnboardingSlider({super.key});

  @override
  State<OnboardingSlider> createState() => _OnboardingSliderState();
}

class _OnboardingSliderState extends State<OnboardingSlider> {
  final PageController _pageController = PageController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();

  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      _saveDataAndFinish();
    }
  }

  Future<void> _saveDataAndFinish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('patient_age', _ageController.text);
    await prefs.setString('patient_aadhar', _aadharController.text);
    await prefs.setBool('onboarding_complete', true);
    // Navigation is now handled in OnboardingAadharPage after Finish/Skip
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          OnboardingAgePage(controller: _ageController, onNext: _nextPage),
          OnboardingAadharPage(
            controller: _aadharController,
            onNext: _saveDataAndFinish,
          ),
        ],
      ),
    );
  }
}
