import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/localization/app_strings.dart';

class MainLayoutScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDeepSea : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? Colors.white24 : Colors.black.withOpacity(0.1),
              width: 1.5,
            ),
          ),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              final color = isDark ? Colors.white : AppColors.textPrimary;
              if (states.contains(WidgetState.selected)) {
                return GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryBlue,
                );
              }
              return GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color.withOpacity(0.7),
              );
            }),
          ),
          child: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _goBranch,
            backgroundColor: Colors.transparent,
            indicatorColor: AppColors.primaryBlue.withOpacity(0.15),
            elevation: 0,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.water_drop_outlined, color: isDark ? Colors.white70 : AppColors.textSecondary),
                selectedIcon: const Icon(Icons.water_drop_rounded, color: AppColors.primaryBlue),
                label: AppStrings.get('app_name', ref),
              ),
              NavigationDestination(
                icon: Icon(Icons.show_chart_rounded, color: isDark ? Colors.white70 : AppColors.textSecondary),
                selectedIcon: const Icon(Icons.show_chart_rounded, color: AppColors.primaryBlue),
                label: AppStrings.get('analytics', ref),
              ),
              NavigationDestination(
                icon: Icon(Icons.notifications_none_rounded, color: isDark ? Colors.white70 : AppColors.textSecondary),
                selectedIcon: const Icon(Icons.notifications_active_rounded, color: AppColors.primaryBlue),
                label: AppStrings.get('reminders', ref),
              ),
              NavigationDestination(
                icon: Icon(Icons.emoji_events_outlined, color: isDark ? Colors.white70 : AppColors.textSecondary),
                selectedIcon: const Icon(Icons.emoji_events_rounded, color: AppColors.primaryBlue),
                label: AppStrings.get('achievements', ref),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
