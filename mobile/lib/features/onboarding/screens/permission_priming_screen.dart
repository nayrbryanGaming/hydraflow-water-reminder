import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/notification_service.dart';
import '../../../widgets/glass_card.dart';

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
                  'Consistency is Key',
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn().slideY(begin: 0.2),
                const SizedBox(height: 16),
                Text(
                  'To help you build a lasting habit, HydraFlow sends gentle, smart reminders based on your activity and goal progress.',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 48),
                _buildFeatureList(),
                const Spacer(),
                _buildActionButtons(context),
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

  Widget _buildFeatureList() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildFeatureItem(Icons.auto_awesome_outlined, 'Smart Intervals (AI Spacing)'),
          const Divider(height: 24, color: Colors.white10),
          _buildFeatureItem(Icons.bedtime_outlined, 'Quiet Hours (No night pings)'),
          const Divider(height: 24, color: Colors.white10),
          _buildFeatureItem(Icons.insights_outlined, 'Goal-Driven (Adaptive nudges)'),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.secondaryAqua),
        const SizedBox(width: 16),
        Text(
          text,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
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
              'Allow Smart Reminders',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => context.go(routeRegister),
          child: Text(
            'Maybe later',
            style: GoogleFonts.outfit(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 600.ms);
  }
}

