import 'package:ayursutra_app/pages/tridosh_analysis_history_page.dart';
import 'package:ayursutra_app/theme/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final Color secondaryDark = const Color(0xFF0F172A);

  // Example values
  final List<int> doshValues = [30, 50, 45];
  final List<String> doshLabels = ["Vata", "Pitta", "Kapha"];

  final List<FlSpot> wellnessData = [
    const FlSpot(1, 20),
    const FlSpot(2, 40),
    const FlSpot(3, 35),
    const FlSpot(4, 50),
    const FlSpot(5, 65),
  ];

  final List<FlSpot> healthStatusData = [
    const FlSpot(1, 60),
    const FlSpot(2, 65),
    const FlSpot(3, 70),
    const FlSpot(4, 75),
    const FlSpot(5, 85),
    const FlSpot(6, 80),
    const FlSpot(7, 88),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            Row(
              children: [
                const Text(
                  "Progress",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Monitor your Prakriti and Vikriti balance",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF0F172A).withOpacity(0.7),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 24),

            // Tridosha Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFF0F172A).withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF0F172A).withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const TridoshAnalysisHistoryPage(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Tridosha Analysis",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Icon(Icons.chevron_right, size: 28, color: Color(0xFF0F172A)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Three circular indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(3, (index) {
                      Color doshColors = [
                        const Color.fromARGB(255, 255, 208, 0),
                        const Color(0xFFE74C3C),
                        const Color.fromARGB(255, 53, 126, 237),
                      ][index];

                      return Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: doshColors.withOpacity(0.3),
                                    width: 6,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: CircularProgressIndicator(
                                  value: doshValues[index] / 100,
                                  strokeWidth: 6,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    doshColors,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: Center(
                                  child: Text(
                                    "${doshValues[index]}%",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: doshColors,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            doshLabels[index],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F172A),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getDoshDescription(index),
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF0F172A).withOpacity(0.6),
                              fontFamily: 'Poppins',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Progress Chart Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFF0F172A).withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF0F172A).withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Weekly Wellness Trend",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Track your overall health improvement",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0F172A).withOpacity(0.6),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        minX: 1,
                        maxX: 5,
                        minY: 0,
                        maxY: 100,
                        gridData: const FlGridData(
                          show: true,
                          drawVerticalLine: true,
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const style = TextStyle(
                                  color: Color(0xFF0F172A),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                );
                                Widget label;
                                if (value == 1) {
                                  label = const Text("Mon", style: style);
                                } else if (value == 3) label = const Text("Wed", style: style);
                                else if (value == 5) label = const Text("Fri", style: style);
                                else label = const SizedBox.shrink();
                                // Add vertical offset to x-axis labels
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: label,
                                );
                              },
                              reservedSize: 40,
                              interval: 1,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value % 20 == 0) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "${value.toInt()}%",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F172A),
                                        fontFamily: 'Poppins',
                                        height: 1.0, // Prevents line breaks
                                        overflow: TextOverflow.visible,
                                      ),
                                      maxLines: 1,
                                      softWrap: false,
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                              reservedSize: 40,
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: wellnessData,
                            isCurved: true,
                            color: primaryTeal,
                            barWidth: 4,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  primaryTeal.withOpacity(0.3),
                                  primaryTeal.withOpacity(0.0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Health Status Chart Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF0F172A).withOpacity(0.1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Overall Health Status",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Your health progress over the past week",
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF0F172A).withOpacity(0.6),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    height: 220,
                    child: LineChart(
                      LineChartData(
                        minX: 1,
                        maxX: 7,
                        minY: 0,
                        maxY: 100,
                        gridData: const FlGridData(
                          show: true,
                          drawVerticalLine: false,
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const style = TextStyle(
                                  color: Color(0xFF0F172A),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                );
                                Widget label;
                                if (value == 1) {
                                  label = const Text("Mon", style: style);
                                } else if (value == 4) label = const Text("Thu", style: style);
                                else if (value == 7) label = const Text("Sun", style: style);
                                else label = const SizedBox.shrink();
                                // Add vertical offset to x-axis labels
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: label,
                                );
                              },
                              reservedSize: 40,
                              interval: 1,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value % 10 == 0) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "${value.toInt()}%",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F172A),
                                        fontFamily: 'Poppins',
                                        height: 1.0, // Prevents line breaks
                                        overflow: TextOverflow.visible,
                                      ),
                                      maxLines: 1,
                                      softWrap: false,
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                              reservedSize: 40,
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: healthStatusData,
                            isCurved: true,
                            color: const Color(0xFF27AE60), // Green for health
                            barWidth: 5,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 6,
                                  color: const Color(0xFF27AE60),
                                  strokeWidth: 3,
                                  strokeColor: Colors.white,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF27AE60).withOpacity(0.3),
                                  const Color(0xFF27AE60).withOpacity(0.0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Health Status Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildHealthIndicator(
                        "Energy Level",
                        "88%",
                        const Color(0xFF27AE60),
                        Icons.battery_charging_full,
                      ),
                      _buildHealthIndicator(
                        "Sleep Quality",
                        "75%",
                        const Color(0xFF3498DB),
                        Icons.bedtime,
                      ),
                      _buildHealthIndicator(
                        "Stress Level",
                        "Low",
                        const Color(0xFFE67E22),
                        Icons.psychology,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100), // Extra space for floating nav
          ],
        ),
      ),
    );
  }

  Widget _buildHealthIndicator(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: const Color(0xFF0F172A).withOpacity(0.7),
            fontFamily: 'Poppins',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  String _getDoshDescription(int index) {
    switch (index) {
      case 0:
        return "Movement\n& Energy";
      case 1:
        return "Metabolism\n& Fire";
      case 2:
        return "Structure\n& Stability";
      default:
        return "";
    }
  }
}
