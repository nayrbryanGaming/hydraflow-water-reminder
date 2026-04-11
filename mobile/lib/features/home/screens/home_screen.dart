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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              isDark ? AppColors.backgroundDeepSea : const Color(0xFFE0F2FE),
              isDark ? AppColors.backgroundDark : Colors.white,
            ],
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(profile),
                        const SizedBox(height: 32),
                        _buildMainLiquidGlass(context, percent, consumedMl, goalMl),
                        const SizedBox(height: 32),
                        _buildBentoGrid(context, profile, consumedMl, percent),
                        const SizedBox(height: 32),
                        _buildQuickAddButton(context),
                        const SizedBox(height: 32),
                        _buildRecentActivity(logs),
                        const SizedBox(height: 100), // Padding for FAB
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, ${profile.displayName} 👋',
          style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold),
        ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
        const SizedBox(height: 4),
        Text(
          'Time to hydrate your body',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  Widget _buildMainLiquidGlass(BuildContext context, double percent, int consumed, int goal) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Glow
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.2),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
          // Transparent Glass Container
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
              ),
            ),
            child: ClipOval(
              child: WaveWidget(
                progress: percent,
                color: AppColors.primaryBlue,
                size: 220,
              ),
            ),
          ),
          // Progress Info
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(percent * 100).toInt()}%',
                style: GoogleFonts.outfit(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              Text(
                '${consumed} / ${goal}ml',
                style: GoogleFonts.outfit(fontSize: 16, color: Colors.white.withOpacity(0.8)),
              ),
            ],
          ),
        ],
      ).animate().scale(duration: 800.ms, curve: Curves.backOut),
    );
  }

  Widget _buildBentoGrid(BuildContext context, profile, int consumed, double percent) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Left Bento: Streak
          Expanded(
            child: GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 32),
                  const Spacer(),
                  Text('Streak', style: GoogleFonts.outfit(color: AppColors.textSecondary)),
                  Text('7 Days', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Right Bento: Reminders & Progress
          Expanded(
            child: Column(
              children: [
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_active_rounded, color: AppColors.secondaryAqua, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Next', style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary)),
                            Text('in 45m', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status', style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary)),
                            Text(percent < 1.0 ? 'Hydrating' : 'Great Job!', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.2, delay: 400.ms).fadeIn(delay: 400.ms);
  }

  Widget _buildQuickAddButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.push('$routeHome/log-water'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
        backgroundColor: AppColors.primaryBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_rounded, size: 28),
          const SizedBox(width: 12),
          Text('DRINK WATER', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1);
  }

  Widget _buildRecentActivity(List<HydrationLog> logs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Daily History', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text('View All')),
          ],
        ),
        const SizedBox(height: 12),
        logs.isEmpty
            ? _buildEmptyState()
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: logs.length.clamp(0, 3),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final log = logs[index];
                  return GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(log.drinkType.emoji, style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${log.amountMl}ml ${log.drinkType.label}',
                                style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${log.timestamp.hour}:${log.timestamp.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: (700 + (index * 100)).ms).slideX(begin: 0.1);
                },
              ),
      ],
    );
  }
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
