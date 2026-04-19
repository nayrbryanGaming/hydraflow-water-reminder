import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';

class MainLayoutScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayoutScreen({
    super.key,
    required this.navigationShell,
  });

  void _goBranch(int index) {
    if (index != navigationShell.currentIndex) {
      HapticFeedback.lightImpact();
      navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDark : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.white12 : Colors.black.withOpacity(0.05),
              width: 1,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
          backgroundColor: Colors.transparent,
          indicatorColor: AppColors.primaryBlue.withOpacity(0.2),
          elevation: 0,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.water_drop_outlined),
              selectedIcon: const Icon(Icons.water_drop_rounded, color: AppColors.primaryBlue),
              label: 'Home',
            ),
            NavigationDestination(
              icon: const Icon(Icons.show_chart_rounded),
              selectedIcon: const Icon(Icons.show_chart_rounded, color: AppColors.primaryBlue),
              label: 'Analytics',
            ),
            NavigationDestination(
              icon: const Icon(Icons.notifications_none_rounded),
              selectedIcon: const Icon(Icons.notifications_active_rounded, color: AppColors.primaryBlue),
              label: 'Reminders',
            ),
            NavigationDestination(
              icon: const Icon(Icons.emoji_events_outlined),
              selectedIcon: const Icon(Icons.emoji_events_rounded, color: AppColors.primaryBlue),
              label: 'Badges',
            ),
          ],
        ),
      ),
    );
  }
}

