import 'package:ayursutra_app/doctor/doctor_home_page.dart';
import 'package:flutter/material.dart';

class DoctorRootPage extends StatefulWidget {
  const DoctorRootPage({super.key});

  @override
  State<DoctorRootPage> createState() => _DoctorRootPageState();
}

class _DoctorRootPageState extends State<DoctorRootPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const DoctorHomePage(),
      Center(child: Text('Doctor Appointments')),
      Center(child: Text('Doctor Messages')),
    ];

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(title: const Text('Doctor Dashboard')),
        body: Stack(
          children: [
            pages[_selectedIndex],
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.home, 0),
                  _buildNavItem(Icons.calendar_today, 1),
                  _buildNavItem(Icons.message, 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final active = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: active ? Colors.blue.shade700 : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6),
          ],
        ),
        child: Icon(icon, color: active ? Colors.white : Colors.black),
      ),
    );
  }
}
