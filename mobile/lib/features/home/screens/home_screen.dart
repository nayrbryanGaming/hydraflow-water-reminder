import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/hydration_calculator.dart';
import '../../../services/firestore_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/hydration_log.dart';
import '../../../services/insight_service.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/wave_widget.dart';
import '../../../core/providers/settings_providers.dart';

final userProfileProvider = StreamProvider((ref) {
  return ref.watch(firestoreServiceProvider).getUserProfile();
});

final todaysLogsProvider = StreamProvider((ref) {
  return ref.watch(firestoreServiceProvider).getDailyLogs(DateTime.now());
});

final allLogsProvider = StreamProvider((ref) {
  return ref.watch(firestoreServiceProvider).getAllHydrationLogs();
});

final calculatedStatsProvider = Provider((ref) {
  final logsAsync = ref.watch(allLogsProvider);
  final profileAsync = ref.watch(userProfileProvider);
  final statsService = ref.read(hydrationStatsProvider);
  final globalStatsAsync = ref.watch(userStatsProvider);

  return logsAsync.when(
    data: (logs) => profileAsync.when(
      data: (profile) => globalStatsAsync.when(
        data: (globalStats) {
          if (profile == null) return null;
          final streak = statsService.calculateStreak(logs, profile.dailyWaterGoalMl);
          final efficiency = statsService.calculateEfficiency(logs, profile.dailyWaterGoalMl);
          final rank = statsService.calculateRank(globalStats?.totalWaterMl ?? 0, streak);
          return {
            'streak': streak,
            'efficiency': efficiency,
            'rank': rank,
          };
        },
        loading: () => null,
        error: (_, __) => null,
      ),
      loading: () => null,
      error: (_, __) => null,
    ),
    loading: () => null,
    error: (_, __) => null,
  );
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late String _dailyInsight;
  bool _celebrationDismissed = false;

  @override
  void initState() {
    super.initState();
    _dailyInsight = InsightService.instance.getRandomInsight();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final logsAsync = ref.watch(todaysLogsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('HydraFlow', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              HapticFeedback.lightImpact();
              context.push(routeSettings);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isDark ? const Color(0xFF0F172A) : const Color(0xFFF0F9FF),
              isDark ? const Color(0xFF1E293B) : const Color(0xFFE0F2FE),
              isDark ? const Color(0xFF0F172A) : Colors.white,
            ],
            stops: const [0.0, 0.5, 1.0],
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
                final isGoalReached = percent >= 1.0;

                return SafeArea(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeader(profile.displayName),
                              const SizedBox(height: 32),
                              _buildMainLiquidGlass(percent, consumedMl, goalMl),
                              const SizedBox(height: 48),
                              _buildBentoStats(percent, ref),
                              const SizedBox(height: 32),
                              _buildRecentActivity(logs),
                              const SizedBox(height: 32),
                              _buildClinicalIntegritySection(),
                              const SizedBox(height: 120),
                            ],
                          ),
                        ),
                      ),
                      if (isGoalReached && !_celebrationDismissed) _buildCelebrationOverlay(),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          HapticFeedback.mediumImpact();
          context.push(routeLogWater);
        },
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add_rounded, size: 36, color: Colors.white),
      ).animate().scale(delay: 500.ms),
    );
  }

  Widget _buildCelebrationOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background glowing effect
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryBlue.withOpacity(0.2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.5),
                    radius: 100,
                    blurRadius: 100,
                  ),
                ],
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 2.seconds),
            
            GlassCard(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.stars_rounded, color: Colors.amber, size: 100)
                      .animate()
                      .scale(duration: 600.ms, curve: Curves.elasticOut)
                      .shimmer(delay: 600.ms, duration: 2.seconds)
                      .shake(hz: 3, duration: 1.seconds),
                  const SizedBox(height: 32),
                  Text(
                    'GOAL REACHED!',
                    style: GoogleFonts.outfit(
                      fontSize: 32, 
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                      color: Colors.white,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                  const SizedBox(height: 12),
                  Text(
                    'Hydration levels are optimal.\nYour body thanks you!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                      height: 1.4,
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      setState(() => _celebrationDismissed = true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      elevation: 12,
                      shadowColor: AppColors.primaryBlue.withOpacity(0.5),
                    ),
                    child: Text(
                      'CONTINUE',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                  ).animate().fadeIn(delay: 600.ms).scale(delay: 600.ms, curve: Curves.easeOutBack),
                ],
              ),
            ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack).slideY(begin: 0.2),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, $name',
          style: GoogleFonts.outfit(
            fontSize: 28, 
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
        const SizedBox(height: 4),
        Text(
          'Time to hydrate your body',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  Widget _buildMainLiquidGlass(double percent, int consumed, int goal) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 280,
            height: 280,
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
          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
              color: Colors.white.withOpacity(0.05),
            ),
            child: ClipOval(
              child: WaveWidget(
                progress: percent.clamp(0.0, 1.0),
                color: AppColors.primaryBlue,
                size: 260,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.white, Color(0xFFBAE6FD)],
                ).createShader(bounds),
                child: Text(
                  '${(percent * 100).toInt().clamp(0, 100)}%',
                  style: GoogleFonts.outfit(
                    fontSize: 64, 
                    fontWeight: FontWeight.w900, 
                    letterSpacing: -2,
                    height: 1,
                  ),
                ),
              ).animate().scale(duration: 800.ms, curve: Curves.easeOutBack),
              const SizedBox(height: 8),
              Text(
                '${HydrationCalculator.formatMl(consumed, isMetric: ref.watch(unitPreferenceProvider))} / ${HydrationCalculator.formatMl(goal, isMetric: ref.watch(unitPreferenceProvider))}',
                style: GoogleFonts.outfit(
                  fontSize: 14, 
                  fontWeight: FontWeight.w600, 
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ).animate().fadeIn(duration: 1.seconds).scale(duration: 800.ms, curve: Curves.easeOutBack),
    );
  }

  Widget _buildBentoStats(double percent, WidgetRef ref) {
    final stats = ref.watch(calculatedStatsProvider);
    final streak = stats?['streak'] ?? 0;
    final rank = stats?['rank'] ?? 'Beginner';
    final efficiency = (stats?['efficiency'] ?? 0.0).toStringAsFixed(0);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildBentoCard(
                icon: Icons.local_fire_department_rounded,
                iconColor: Colors.orange,
                title: 'Streak',
                value: '$streak Days',
                subtitle: streak > 0 ? 'Keep it up!' : 'Start your streak!',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildBentoCard(
                icon: Icons.workspace_premium_rounded,
                iconColor: Colors.amber,
                title: 'Rank',
                value: rank,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildBentoCard(
                icon: Icons.query_stats_rounded,
                iconColor: AppColors.secondaryAqua,
                title: 'Efficiency',
                value: '$efficiency%',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: _buildInsightBento(_dailyInsight),
            ),
          ],
        ),
      ],
    ).animate().slideY(begin: 0.2, delay: 400.ms).fadeIn(delay: 400.ms);
  }

  Widget _buildBentoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    String? subtitle,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 16),
          Text(title, style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle, style: GoogleFonts.outfit(color: AppColors.textHint, fontSize: 11)),
          ],
        ],
      ),
    );
  }

  Widget _buildInsightBento(String insight) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      color: AppColors.primaryBlue.withOpacity(0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 24),
          const SizedBox(height: 12),
          Text('Bio-Tip', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            insight,
            style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(List<HydrationLog> logs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Daily History', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                context.go(routeAnalytics);
              }, 
              child: Text('View All', style: GoogleFonts.outfit(color: AppColors.primaryBlue, fontWeight: FontWeight.w600)),
            ),
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
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle),
                          child: const Icon(Icons.water_drop_rounded, color: AppColors.primaryBlue, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${HydrationCalculator.formatMl(log.amountMl, isMetric: ref.watch(unitPreferenceProvider))} Intake',
                                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                '${log.timestamp.hour}:${log.timestamp.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
                      ],
                    ),
                  ).animate().fadeIn(delay: (700 + (index * 100)).ms).slideX(begin: 0.1);
                },
              ),
      ],
    );
  }

  Widget _buildClinicalIntegritySection() {
    return GlassCard(
      padding: const EdgeInsets.all(28),
      color: AppColors.primaryBlue.withOpacity(0.03),
      border: Border.all(color: AppColors.primaryBlue.withOpacity(0.1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentMint.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shield_rounded, color: AppColors.accentMint, size: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Clinical Authority',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: -0.5),
                  ),
                  Text(
                    'Science-Backed Hydration',
                    style: GoogleFonts.outfit(fontSize: 12, color: AppColors.accentMint, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'HydraFlow\'s precision calculation engine is strictly aligned with physiological standards established by the National Academies of Medicine (NAM) and the World Health Organization (WHO).',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: AppColors.textHint, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Important: This wellness tool indicates population-based hydration targets and does not replace medical diagnosis.',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: AppColors.textHint,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, curve: Curves.easeOutBack);
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
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[800]!,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 48),
          Container(height: 32, width: 200, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
          const SizedBox(height: 48),
          Center(
            child: CircleAvatar(radius: 120, backgroundColor: Colors.white),
          ),
          const SizedBox(height: 48),
          Container(height: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24))),
          const SizedBox(height: 16),
          Container(height: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24))),
        ],
      ),
    );
  }
}


