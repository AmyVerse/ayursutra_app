import 'package:ayursutra_app/pages/appointments_page.dart';
import 'package:ayursutra_app/pages/home_page.dart';
import 'package:ayursutra_app/pages/progress_page.dart';
import 'package:ayursutra_app/pages/report_page.dart';
import 'package:ayursutra_app/widgets/floating_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;
  DateTime? _lastBackPressed;
  int _homeRefreshCounter = 0;

  @override
  void initState() {
    super.initState();
    // Set status bar icons to dark
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Import services if not already

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      );
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // If navigating to Home, increment counter to force a remount/rebuild
      if (index == 0) _homeRefreshCounter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color pureWhite = Color(0xFFFFFFFF);

    final List<Widget> pages = <Widget>[
      // Use a ValueKey that changes when _homeRefreshCounter increments
      HomePage(key: ValueKey('home-$_homeRefreshCounter')),
      const ProgressPage(),
      const AppointmentsPage(),
      const ReportPage(),
    ];

    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (_lastBackPressed == null ||
            now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
          _lastBackPressed = now;
          _showFloatingToast(context, 'Press back again to exit');
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: pureWhite,
        body: Stack(
          children: [
            pages[_selectedIndex],
            FloatingNavBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          ],
        ),
      ),
    );
  }

  void _showFloatingToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);

    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 35,
        left: 24,
        right: 24,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.85),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2)).then((_) {
      overlayEntry.remove();
      if (!mounted) return;
      setState(() {
        _lastBackPressed = null;
      });
    });
  }
}
