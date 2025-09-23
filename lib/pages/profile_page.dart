import 'package:ayursutra_app/theme/colors.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color secondaryDark = Color(0xFF0F172A);

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
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF0F172A)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 44,
                backgroundColor: primaryTeal.withOpacity(0.1),
                child: const Icon(Icons.person, color: primaryTeal, size: 44),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Lokesh Kumar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'lokesh.kumar@example.com',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF0F172A),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Account Options',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Profile'),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password'),
                onTap: () {},
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Account Settings'),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
