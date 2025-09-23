import 'package:ayursutra_app/theme/colors.dart';
import 'package:flutter/material.dart';

class FloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const FloatingNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    const Color secondaryDark = Color(0xFF0F172A);
    const Color pureWhite = Color(0xFFFFFFFF);

    return Positioned(
      bottom: 30,
      left: 17,
      right: 17,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: pureWhite,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: secondaryDark, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: secondaryDark.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFloatingNavItem(
              context,
              icon: Icons.home_rounded,
              label: 'Home',
              index: 0,
              isSelected: selectedIndex == 0,
            ),
            _buildFloatingNavItem(
              context,
              icon: Icons.trending_up_rounded,
              label: 'Progress',
              index: 1,
              isSelected: selectedIndex == 1,
            ),
            _buildFloatingNavItem(
              context,
              icon: Icons.calendar_today_rounded,
              label: 'Bookings',
              index: 2,
              isSelected: selectedIndex == 2,
            ),
            _buildFloatingNavItem(
              context,
              icon: Icons.data_usage_rounded,
              label: 'Report',
              index: 3,
              isSelected: selectedIndex == 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    const Color pureWhite = Color(0xFFFFFFFF);
    const Color secondaryDark = Color(0xFF0F172A);
    return Expanded(
      child: GestureDetector(
        onTap: () => onItemTapped(index),
        behavior: HitTestBehavior.translucent,
        child: Container(
          height: 70,
          margin: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            color: isSelected ? primaryTeal : pureWhite,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? pureWhite
                    : secondaryDark.withValues(alpha: 0.6),
                size: isSelected ? 28 : 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? pureWhite
                      : secondaryDark.withValues(alpha: 0.6),
                  fontSize: isSelected ? 12 : 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
