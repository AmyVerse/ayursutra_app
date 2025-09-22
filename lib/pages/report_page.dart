import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryTeal = Color(0xFF14B8A6);
    const Color secondaryDark = Color(0xFF0F172A);

    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              const Text(
                'Health Reports',
                style: TextStyle(
                  color: secondaryDark,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Track your health journey with detailed reports',
                style: TextStyle(
                  color: secondaryDark.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),

              // Recent Reports Section
              _buildSectionHeader('Recent Reports', 'View all'),
              const SizedBox(height: 16),
              _buildReportCard(
                title: 'Blood Test Results',
                date: 'Sep 20, 2025',
                status: 'Normal',
                statusColor: Colors.green,
                icon: Icons.bloodtype,
              ),
              const SizedBox(height: 12),
              _buildReportCard(
                title: 'Cholesterol Check',
                date: 'Sep 15, 2025',
                status: 'Attention Required',
                statusColor: Colors.orange,
                icon: Icons.favorite,
              ),
              const SizedBox(height: 12),
              _buildReportCard(
                title: 'Blood Pressure Monitor',
                date: 'Sep 10, 2025',
                status: 'Normal',
                statusColor: Colors.green,
                icon: Icons.monitor_heart,
              ),
              const SizedBox(height: 24),

              // Health Metrics Section
              _buildSectionHeader('Health Metrics', 'View trends'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      title: 'BMI',
                      value: '22.5',
                      unit: 'kg/m²',
                      trend: '+0.2',
                      trendUp: true,
                      icon: Icons.fitness_center,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Weight',
                      value: '68.5',
                      unit: 'kg',
                      trend: '-1.2',
                      trendUp: false,
                      icon: Icons.scale,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Heart Rate',
                      value: '72',
                      unit: 'bpm',
                      trend: '+3',
                      trendUp: true,
                      icon: Icons.favorite,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Blood Pressure',
                      value: '120/80',
                      unit: 'mmHg',
                      trend: 'Normal',
                      trendUp: null,
                      icon: Icons.monitor_heart,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Quick Actions Section
              _buildSectionHeader('Quick Actions', ''),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      title: 'Upload Report',
                      icon: Icons.cloud_upload,
                      color: primaryTeal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      title: 'Schedule Test',
                      icon: Icons.schedule,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      title: 'Share Report',
                      icon: Icons.share,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      title: 'Export PDF',
                      icon: Icons.picture_as_pdf,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100), // Extra space for floating nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionText) {
    const Color secondaryDark = Color(0xFF0F172A);
    const Color primaryTeal = Color(0xFF14B8A6);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: secondaryDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (actionText.isNotEmpty)
          TextButton(
            onPressed: () {},
            child: Text(
              actionText,
              style: const TextStyle(
                color: primaryTeal,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReportCard({
    required String title,
    required String date,
    required String status,
    required Color statusColor,
    required IconData icon,
  }) {
    const Color pureWhite = Color(0xFFFFFFFF);
    const Color secondaryDark = Color(0xFF0F172A);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: secondaryDark.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: secondaryDark.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: statusColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: secondaryDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    color: secondaryDark.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_ios,
            color: secondaryDark.withOpacity(0.4),
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String unit,
    required String trend,
    required bool? trendUp,
    required IconData icon,
  }) {
    const Color pureWhite = Color(0xFFFFFFFF);
    const Color secondaryDark = Color(0xFF0F172A);
    const Color primaryTeal = Color(0xFF14B8A6);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: secondaryDark.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: primaryTeal, size: 24),
              if (trendUp != null)
                Icon(
                  trendUp ? Icons.trending_up : Icons.trending_down,
                  color: trendUp ? Colors.green : Colors.red,
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: secondaryDark.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: secondaryDark,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  unit,
                  style: TextStyle(
                    color: secondaryDark.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            trend,
            style: TextStyle(
              color: trendUp == null
                  ? secondaryDark.withOpacity(0.6)
                  : trendUp
                  ? Colors.green
                  : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    const Color secondaryDark = Color(0xFF0F172A);

    return GestureDetector(
      onTap: () {
        // Handle action tap
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: secondaryDark,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
