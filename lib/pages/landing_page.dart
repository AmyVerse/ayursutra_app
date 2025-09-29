import 'package:ayursutra_app/onboarding/onboarding_entry.dart';
import 'package:ayursutra_app/services/auth_service.dart';
import 'package:ayursutra_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _contactController = TextEditingController();
  final _otpController = TextEditingController();
  final _hprIdController = TextEditingController();
  final _abhaIdController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _showOtpField = false;
  bool _isDoctorMode = false; // Kept for UI, but functionality removed
  String? _errorMessage;

  @override
  void dispose() {
    _contactController.dispose();
    _otpController.dispose();
    _hprIdController.dispose();
    _abhaIdController.dispose();
    super.dispose();
  }

  // Validate contact (email or phone)
  bool _isEmail(String contact) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(contact);
  }

  bool _isPhone(String contact) {
    return RegExp(r'^\d{10}$').hasMatch(contact);
  }

  Future<void> _sendOTP() async {
    final contact = _contactController.text.trim();

    if (contact.isEmpty) {
      setState(() => _errorMessage = 'Please enter your email or phone number');
      return;
    }

    if (_isDoctorMode) {
      final hprId = _hprIdController.text.trim();
      final abhaId = _abhaIdController.text.trim();

      if (hprId.isEmpty && abhaId.isEmpty) {
        setState(() => _errorMessage = 'Please enter either HPR ID or ABHA ID');
        return;
      }

      // Show message that doctor login is disabled in this version
      setState(() {
        _errorMessage =
            'Doctor login is not available in this version. Please use patient login.';
      });
      return;
    } else {
      if (!_isEmail(contact) && !_isPhone(contact)) {
        setState(
          () => _errorMessage =
              'Please enter a valid email or 10-digit phone number',
        );
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _authService.sendOTP(contact);
      if (result) {
        setState(() {
          _showOtpField = true;
          _errorMessage = null;
        });
      } else {
        setState(() => _errorMessage = 'Failed to send OTP. Please try again.');
      }
    } catch (e) {
      setState(() => _errorMessage = 'An error occurred while sending OTP');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOTP() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty || otp.length != 6) {
      setState(() => _errorMessage = 'Please enter a valid 6-digit OTP');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.verifyOTP(
        _contactController.text.trim(),
        otp,
        isDoctor: false, // Always false since we only support patient flow
        hprId: null,
        abhaId: null,
      );

      if (!mounted) return;

      // Patient-only flow - no doctor mode check needed
      // Always go to onboarding for simplicity, regardless of new user status
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingEntry()),
      );
    } catch (e) {
      setState(
        () => _errorMessage = e.toString().replaceAll('Exception: ', ''),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _toggleDoctorMode() {
    setState(() {
      _isDoctorMode = !_isDoctorMode;
      _showOtpField = false;
      _errorMessage = null;
      _otpController.clear();
      if (_isDoctorMode) {
        _contactController.clear();
        // Show a helpful message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Doctor mode is not available in this version.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        _hprIdController.clear();
        _abhaIdController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: primaryTeal,
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset('assets/bg.png', fit: BoxFit.cover),
            ),
            // subtle overlay for contrast
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.25)),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            const SizedBox(height: 48),

                            // Centered static logo and title
                            SizedBox(
                              height: 120,
                              child: Image.asset('assets/icon.png'),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'AyurSutra',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 45,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Traditional Healing, Modern Convenience',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            // Flexible spacer to center the form
                            const Spacer(),

                            // Authentication Form
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Header
                                  Text(
                                    _isDoctorMode
                                        ? (_showOtpField
                                              ? 'Doctor Verification'
                                              : 'Doctor Registration')
                                        : (_showOtpField
                                              ? 'Verify OTP'
                                              : 'Welcome to AyurSutra'),
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F172A),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _showOtpField
                                        ? 'Enter the OTP sent to your ${_isEmail(_contactController.text) ? 'email' : 'mobile'}'
                                        : _isDoctorMode
                                        ? 'Complete your doctor profile'
                                        : 'Enter your mobile number or email to continue',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),

                                  // Form Fields
                                  if (_isDoctorMode && !_showOtpField) ...[
                                    // Doctor Registration Fields
                                    TextField(
                                      controller: _hprIdController,
                                      decoration: InputDecoration(
                                        labelText:
                                            'HPR ID (Health Professional Registry)',
                                        hintText: 'Enter your HPR ID',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    const Row(
                                      children: [
                                        Expanded(child: Divider()),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: Text(
                                            'OR',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Expanded(child: Divider()),
                                      ],
                                    ),
                                    const SizedBox(height: 16),

                                    TextField(
                                      controller: _abhaIdController,
                                      decoration: InputDecoration(
                                        labelText:
                                            'ABHA ID (Ayushman Bharat Health Account)',
                                        hintText: 'Enter your ABHA ID',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        border: Border.all(
                                          color: Colors.blue.shade200,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            color: Colors.blue,
                                            size: 20,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'We\'ll fetch your profile details and send OTP to your registered mobile number',
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],

                                  // Contact Field (always show except for doctor registration step)
                                  if (!_isDoctorMode || _showOtpField)
                                    TextField(
                                      controller: _contactController,
                                      keyboardType: TextInputType.text,
                                      enabled: !_showOtpField,
                                      decoration: InputDecoration(
                                        hintText:
                                            'Enter mobile number or email',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                      ),
                                    ),

                                  // OTP Field
                                  if (_showOtpField) ...[
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: _otpController,
                                      keyboardType: TextInputType.number,
                                      maxLength: 6,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        letterSpacing: 4,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Enter OTP',
                                        hintText: '6-digit OTP',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                        counterText: '',
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'OTP sent to ${_contactController.text}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: _isLoading
                                              ? null
                                              : _sendOTP,
                                          child: const Text(
                                            'Resend OTP',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],

                                  // Error Message
                                  if (_errorMessage != null) ...[
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        _errorMessage!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],

                                  const SizedBox(height: 20),

                                  // Main Action Button
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryTeal,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size.fromHeight(48),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      disabledBackgroundColor:
                                          Colors.grey.shade400,
                                    ),
                                    onPressed: _isLoading
                                        ? null
                                        : (_showOtpField
                                              ? _verifyOTP
                                              : _sendOTP),
                                    child: _isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : Text(
                                            _showOtpField
                                                ? 'Verify & Continue'
                                                : (_isDoctorMode
                                                      ? 'Verify & Send OTP'
                                                      : 'Continue'),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                  ),

                                  // Navigation Options
                                  if (_showOtpField) ...[
                                    TextButton(
                                      onPressed: _isLoading
                                          ? null
                                          : () {
                                              setState(() {
                                                _showOtpField = false;
                                                _otpController.clear();
                                                _errorMessage = null;
                                              });
                                            },
                                      child: const Text(
                                        '← Change Mobile/Email',
                                      ),
                                    ),
                                  ] else ...[
                                    const SizedBox(height: 12),
                                    if (!_isDoctorMode) ...[
                                      const Divider(),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Are you a healthcare professional?',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextButton.icon(
                                        onPressed: _isLoading
                                            ? null
                                            : _toggleDoctorMode,
                                        icon: const Icon(
                                          Icons.medical_services,
                                        ),
                                        label: const Text(
                                          '👨‍⚕️ Sign up as Doctor',
                                        ),
                                        style: TextButton.styleFrom(
                                          foregroundColor: primaryTeal,
                                          side: BorderSide(
                                            color: primaryTeal,
                                            width: 1,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ] else ...[
                                      TextButton(
                                        onPressed: _isLoading
                                            ? null
                                            : _toggleDoctorMode,
                                        child: const Text(
                                          '← Back to Patient Login',
                                        ),
                                      ),
                                    ],
                                  ],
                                ],
                              ),
                            ),

                            // Bottom spacer for better balance
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
