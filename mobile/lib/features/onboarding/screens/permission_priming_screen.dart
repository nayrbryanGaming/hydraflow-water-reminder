import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/notification_service.dart';
import '../../../widgets/glass_card.dart';
import '../../../core/localization/app_strings.dart';

class PermissionPrimingScreen extends ConsumerWidget {
  const PermissionPrimingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isDark ? AppColors.backgroundDeepSea : const Color(0xFFE0F2FE),
              isDark ? AppColors.backgroundDark : Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                _buildIconContainer(),
                const SizedBox(height: 48),
                Text(
                  AppStrings.get('consistency_key', ref),
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn().slideY(begin: 0.2),
                const SizedBox(height: 16),
                Text(
                  AppStrings.get('reminder_desc', ref),
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: isDark ? Colors.white70 : AppColors.textSecondary,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 48),
                _buildFeatureList(ref, isDark),
                const Spacer(),
                _buildActionButtons(context, ref, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2), width: 2),
      ),
      child: const Icon(
        Icons.notifications_active_outlined,
        size: 80,
        color: AppColors.primaryBlue,
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
     .scale(duration: 2.seconds, begin: const Offset(1, 1), end: const Offset(1.1, 1.1))
     .shimmer(delay: 1.seconds, duration: 2.seconds);
  }

  Widget _buildFeatureList(WidgetRef ref, bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildFeatureItem(Icons.auto_awesome_outlined, AppStrings.get('smart_intervals', ref), isDark),
          const Divider(height: 24, color: Colors.white10),
          _buildFeatureItem(Icons.bedtime_outlined, AppStrings.get('quiet_hours_desc', ref), isDark),
          const Divider(height: 24, color: Colors.white10),
          _buildFeatureItem(Icons.insights_outlined, AppStrings.get('goal_driven', ref), isDark),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildFeatureItem(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.secondaryAqua),
        const SizedBox(width: 16),
        Text(
          text,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 14, color: isDark ? Colors.white : AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, bool isDark) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () async {
              // Request permissions via service (priming logic)
              await NotificationService.instance.requestPermissions();
              if (context.mounted) context.go(routeRegister);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 8,
              shadowColor: AppColors.primaryBlue.withOpacity(0.5),
            ),
            child: Text(
              AppStrings.get('allow_reminders', ref),
              style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 18),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => context.go(routeRegister),
          child: Text(
            AppStrings.get('maybe_later', ref),
            style: GoogleFonts.outfit(color: isDark ? Colors.white60 : AppColors.textSecondary, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 600.ms);
  }
}
