import 'package:flutter/material.dart';

class TridoshAnalysisHistoryPage extends StatelessWidget {
  const TridoshAnalysisHistoryPage({super.key});

  // Example data for 4 weeks (each week: [Vata, Pitta, Kapha])
  final List<List<int>> tridoshWeeklyData = const [
    [28, 52, 46], // current week
    [32, 48, 42], // 1 week ago
    [35, 45, 40], // 2 weeks ago
    [30, 50, 45], // 3 weeks ago
  ];
  final List<String> weekLabels = const [
    'This week', 'Last week', '2 weeks ago', '3 weeks ago'
  ];
  final List<String> doshLabels = const ["Vata", "Pitta", "Kapha"];
  final List<Color> doshColors = const [
    Color.fromARGB(255, 255, 208, 0),
    Color(0xFFE74C3C),
    Color.fromARGB(255, 53, 126, 237),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tridosh Analysis History'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: tridoshWeeklyData.length,
          separatorBuilder: (context, idx) => const SizedBox(height: 24),
          itemBuilder: (context, weekIdx) {
            final weekData = tridoshWeeklyData[weekIdx];
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF0F172A).withOpacity(0.1)),
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
                  Text(
                    weekLabels[weekIdx],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(3, (doshIdx) {
                      return _TridoshCircleIndicator(
                        value: weekData[doshIdx],
                        color: doshColors[doshIdx],
                        label: doshLabels[doshIdx],
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TridoshCircleIndicator extends StatelessWidget {
  final int value;
  final Color color;
  final String label;

  const _TridoshCircleIndicator({required this.value, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: CircularProgressIndicator(
                value: value / 100,
                strokeWidth: 6,
                backgroundColor: color.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Text(
              "$value%",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
