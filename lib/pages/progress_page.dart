import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final Color primaryTeal = const Color(0xFF14B8A6);
  final Color secondaryDark = const Color(0xFF0F172A);

  // Example values
  final List<int> doshValues = [30, 50, 45];
  final List<String> doshLabels = ["Vata", "Pitta", "Kapha"];

  final List<FlSpot> chartData = [
    FlSpot(1, 20),
    FlSpot(2, 40),
    FlSpot(3, 35),
    FlSpot(4, 50),
    FlSpot(5, 65),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Prakriti [Tridosh]",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward_ios, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Three circular indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                return Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryTeal, width: 3),
                      ),
                      child: Center(
                        child: Text(
                          "${doshValues[index]}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      doshLabels[index],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                );
              }),
            ),

            const SizedBox(height: 20),

            // Line Chart
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: secondaryDark.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: LineChart(
                  LineChartData(
                    minX: 1,
                    maxX: 5,
                    minY: 0,
                    maxY: 100,
                    gridData: FlGridData(show: true, drawVerticalLine: true),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const style = TextStyle(
                              color: Color(0xFF0F172A),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            );
                            switch (value.toInt()) {
                              case 1:
                                return const Text("Day 1", style: style);
                              case 3:
                                return const Text("Day 3", style: style);
                              case 5:
                                return const Text("Day 5", style: style);
                              default:
                                return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value % 20 == 0) {
                              return Text(
                                "${value.toInt()}%",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
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
                        spots: chartData,
                        isCurved: false,
                        color: primaryTeal,
                        barWidth: 3,
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
            ),
            const SizedBox(height: 100), // Extra space for floating nav
          ],
        ),
      ),
    );
  }
}
