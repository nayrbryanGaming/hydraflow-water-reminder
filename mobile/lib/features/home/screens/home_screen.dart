import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/hydration_calculator.dart';
import '../../../services/firestore_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/hydration_log.dart';
import 'package:google_fonts/google_fonts.dart';

final userProfileProvider = StreamProvider((ref) {
  return ref.watch(firestoreServiceProvider).getUserProfile();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final logsAsync = ref.watch(dailyHydrationProvider(DateTime.now()));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('HydraFlow', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.insert_chart_outlined), onPressed: () => context.push(routeAnalytics)),
          IconButton(icon: const Icon(Icons.emoji_events_outlined), onPressed: () => context.push(routeAchievements)),
          IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () => context.push(routeSettings)),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F2FE), Colors.white],
          ),
        ),
        child: profileAsync.when(
          loading: () => _buildShimmer(context),
          error: (e, st) => Center(child: Text('Error: $e')),
          data: (profile) {
            if (profile == null) return const Center(child: Text('No profile data'));

            return logsAsync.when(
              loading: () => _buildShimmer(context),
              error: (e, st) => Center(child: Text('Error: $e')),
              data: (logs) {
                final consumedMl = logs.fold<int>(0, (sum, item) => sum + item.amountMl);
                final goalMl = profile.dailyWaterGoalMl;
                final percent = HydrationCalculator.calculatePercentage(consumedMl, goalMl);
                final status = HydrationCalculator.getStatus(percent);

                return SafeArea(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    children: [
                      Text(
                        'Hello, ${profile.displayName} 👋',
                        style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold),
                      ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
                      const SizedBox(height: 8),
                      Text(
                        HydrationCalculator.getMotivationalMessage(status),
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                      ).animate().fadeIn(delay: 200.ms),
                      const SizedBox(height: 40),
                      Center(
                        child: GlassCard(
                          blur: 20,
                          color: Colors.white.withOpacity(0.4),
                          child: CircularPercentIndicator(
                            radius: 130.0,
                            lineWidth: 18.0,
                            percent: percent,
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.water_drop, color: AppColors.primaryBlue, size: 48)
                                    .animate(onPlay: (controller) => controller.repeat(reverse: true))
                                    .scale(duration: 1.seconds, begin: const Offset(1, 1), end: const Offset(1.1, 1.1)),
                                const SizedBox(height: 8),
                                Text(
                                  HydrationCalculator.formatMl(consumedMl),
                                  style: GoogleFonts.outfit(fontSize: 40, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'of ${HydrationCalculator.formatMl(goalMl)}',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
                                ),
                              ],
                            ),
                            progressColor: AppColors.primaryBlue,
                            backgroundColor: Colors.white.withOpacity(0.5),
                            circularStrokeCap: CircularStrokeCap.round,
                            animation: true,
                            animationDuration: 1500,
                            curve: Curves.easeOutCirc,
                          ),
                        ).animate().scale(delay: 400.ms, curve: Curves.backOut),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton.icon(
                        onPressed: () => context.push('$routeHome/log-water'),
                        icon: const Icon(Icons.add_rounded, size: 28),
                        label: const Text('LOG WATER'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          backgroundColor: AppColors.primaryBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                      ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
                      const SizedBox(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Recent Activity', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
                          TextButton(onPressed: () {}, child: const Text('View All')),
                        ],
                      ).animate().fadeIn(delay: 800.ms),
                      const SizedBox(height: 16),
                      logs.isEmpty
                          ? _buildEmptyState()
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: logs.length.clamp(0, 5),
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final log = logs[index];
                                return GlassCard(
                                  padding: const EdgeInsets.all(16),
                                  borderRadius: 20,
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryBlue.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Text(log.drinkType.emoji, style: const TextStyle(fontSize: 24)),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${log.amountMl}ml ${log.drinkType.label}',
                                              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                            Text(
                                              '${log.timestamp.hour}:${log.timestamp.minute.toString().padLeft(2, '0')}',
                                              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right, color: AppColors.textHint),
                                    ],
                                  ),
                                ).animate().fadeIn(delay: (800 + (index * 100)).ms).slideX(begin: 0.1);
                              },
                            ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return GlassCard(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Icon(Icons.opacity_rounded, size: 64, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text(
            'No logs yet today',
            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          const Text('Every drop counts! Start your hydration journey now.', textAlign: TextAlign.center),
        ],
      ),
    ).animate().fadeIn(delay: 1.seconds);
  }

  Widget _buildShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(height: 32, width: 200, color: Colors.white),
          const SizedBox(height: 48),
          Center(
            child: CircleAvatar(radius: 120, backgroundColor: Colors.white),
          ),
          const SizedBox(height: 48),
          Container(height: 56, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))),
        ],
      ),
    );
  }
}
