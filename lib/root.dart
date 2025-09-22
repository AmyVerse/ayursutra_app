import 'package:ayursutra_app/pages/appointments_page.dart';
import 'package:ayursutra_app/pages/home_page.dart';
import 'package:ayursutra_app/pages/progress_page.dart';
import 'package:ayursutra_app/pages/report_page.dart';
import 'package:ayursutra_app/widgets/floating_navbar.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color pureWhite = Color(0xFFFFFFFF);

    final List<Widget> pages = <Widget>[
      const HomePage(),
      const ProgressPage(),
      const AppointmentsPage(),
      const ReportPage(),
    ];

    return Scaffold(
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
    );
  }
}
