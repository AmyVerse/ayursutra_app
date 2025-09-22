import 'package:ayursutra_app/progress_screen.dart';
import 'package:flutter/material.dart';
class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _goToAppointments() {
    setState(() {
      _selectedIndex = 2; // Switch to the Appointments tab
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryTeal = Color(0xFF14B8A6);
    const Color secondaryDark = Color(0xFF0F172A);
    const Color pureWhite = Color(0xFFFFFFFF);

    final List<Widget> _widgetOptions = <Widget>[
      // Home Screen
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                style: const TextStyle(color: Color(0xFF0F172A)),
                decoration: InputDecoration(
                  hintText: 'Find Doctor',
                  hintStyle: TextStyle(
                      color: const Color(0xFF0F172A).withOpacity(0.6)),
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFF0F172A)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF0F172A).withOpacity(0.05),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                ),
              ),
              const SizedBox(height: 16.0),
              UpcomingAppointmentsCard(
                onViewAll: _goToAppointments,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      // Progress Screen
      const ProgressScreen(),
      // Appointments Screen
      const Center(
        child: Text(
          'Appointments Screen',
          style: TextStyle(color: Color(0xFF0F172A)),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: pureWhite,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: secondaryDark),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text(
          'AYURSUTRA',
          style: TextStyle(
            color: secondaryDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: secondaryDark),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: pureWhite,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: secondaryDark,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: pureWhite,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle, color: secondaryDark),
              title: const Text('Profile',
                  style: TextStyle(color: secondaryDark)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: secondaryDark),
              title: const Text('Settings',
                  style: TextStyle(color: secondaryDark)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: pureWhite,
        selectedItemColor: primaryTeal,
        unselectedItemColor: secondaryDark.withOpacity(0.6),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'App.',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class UpcomingAppointmentsCard extends StatelessWidget {
  final VoidCallback onViewAll;

  const UpcomingAppointmentsCard({super.key, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    const Color primaryTeal = Color(0xFF14B8A6);
    const Color secondaryDark = Color(0xFF0F172A);
    const Color pureWhite = Color(0xFFFFFFFF);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: secondaryDark.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upcoming Appointments',
                style: TextStyle(
                  color: secondaryDark,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: primaryTeal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.calendar_today,
                color: secondaryDark,
                size: 40,
              ),
              const SizedBox(width: 10),
              const Text(
                'No upcoming\nappointments',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: secondaryDark,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookAppointmentScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryTeal,
                  foregroundColor: pureWhite,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: const Text('Book New'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BookAppointmentScreen extends StatelessWidget {
  const BookAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color secondaryDark = Color(0xFF0F172A);
    const Color pureWhite = Color(0xFFFFFFFF);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book an Appointment',
          style: TextStyle(color: secondaryDark),
        ),
        backgroundColor: pureWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: secondaryDark),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text(
          'This is the appointment booking screen.',
          style: TextStyle(color: secondaryDark),
        ),
      ),
    );
  }
}

// class ProgressScreen extends StatelessWidget {
//   const ProgressScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const Color primaryTeal = Color(0xFF14B8A6);
//     const Color secondaryDark = Color(0xFF0F172A);

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Your Progress',
//             style: TextStyle(
//               color: secondaryDark,
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Container(
//             height: 300,
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: secondaryDark.withOpacity(0.05),
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: LineChart(
//               LineChartData(
//                 minX: 0,
//                 maxX: 7,
//                 minY: 0,
//                 maxY: 10,
//                 gridData: FlGridData(show: true, drawVerticalLine: true),
//                 titlesData: FlTitlesData(
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 30,
//                       getTitlesWidget: (value, meta) {
//                         const style = TextStyle(
//                           color: secondaryDark,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12,
//                         );
//                         Widget text;
//                         switch (value.toInt()) {
//                           case 1:
//                             text = const Text('Mon', style: style);
//                             break;
//                           case 3:
//                             text = const Text('Wed', style: style);
//                             break;
//                           case 5:
//                             text = const Text('Fri', style: style);
//                             break;
//                           case 7:
//                             text = const Text('Sun', style: style);
//                             break;
//                           default:
//                             text = const Text('', style: style);
//                             break;
//                         }
//                         return SideTitleWidget(
//                           axisSide: meta.axisSide,
//                           space: 8,
//                           child: text,
//                         );
//                       },
//                     ),
//                   ),
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 40,
//                       getTitlesWidget: (value, meta) {
//                         const style = TextStyle(
//                           color: secondaryDark,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12,
//                         );
//                         if (value % 2 == 0) {
//                           return Text(value.toInt().toString(), style: style);
//                         }
//                         return Container();
//                       },
//                     ),
//                   ),
//                   topTitles:
//                       const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   rightTitles:
//                       const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                 ),
//                 borderData: FlBorderData(show: false),
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: const [
//                       FlSpot(1, 5.2),
//                       FlSpot(2, 6.5),
//                       FlSpot(3, 7.0),
//                       FlSpot(4, 6.8),
//                       FlSpot(5, 7.5),
//                       FlSpot(6, 8.1),
//                       FlSpot(7, 8.5),
//                     ],
//                     isCurved: false,
//                     color: primaryTeal,
//                     barWidth: 3,
//                     isStrokeCapRound: true,
//                     dotData: const FlDotData(show: false),
//                     belowBarData: BarAreaData(
//                       show: true,
//                       gradient: LinearGradient(
//                         colors: [
//                           primaryTeal.withOpacity(0.5),
//                           primaryTeal.withOpacity(0.0),
//                         ],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: const Center(child: Text("Profile Details here")),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: const Center(child: Text("Settings options here")),
    );
  }
}
