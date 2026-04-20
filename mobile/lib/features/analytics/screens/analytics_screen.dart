import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/hydration_calculator.dart';
import '../../../core/providers/settings_providers.dart';
import '../../../services/firestore_service.dart';
import '../../../models/hydration_log.dart';
import '../../../widgets/glass_card.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allLogsAsync = ref.watch(allLogsProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final isMetric = ref.watch(unitPreferenceProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Analytics', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Your Hydration Story',
                  style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold),
                ).animate().fadeIn().slideX(begin: -0.1),
                const SizedBox(height: 4),
                Text(
                  'Detailed breakdown of your habits',
                  style: GoogleFonts.outfit(fontSize: 16, color: AppColors.textSecondary),
                ).animate().fadeIn(delay: 150.ms),
                const SizedBox(height: 32),

                allLogsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(child: Text('Error loading data', style: GoogleFonts.outfit())),
                  data: (allLogs) {
                    return profileAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (profile) {
                        if (profile == null) return const SizedBox.shrink();

                        final dailyGoal = profile.dailyWaterGoalMl;

                        final weeklyAvg = _calculateWeeklyAverage(allLogs);
                        final bestDay = _calculateBestDay(allLogs);
                        final hitRate = _calculateHitRate(allLogs, dailyGoal);
                        final monthlyTotal = _calculateMonthlyTotal(allLogs);
                        final barGroupsData = _buildRealBarGroups(allLogs, dailyGoal);

                        return Column(
                          children: [
                            // 7-Day Bar Chart
                            GlassCard(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Hydration Velocity', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18)),
                                          Text(
                                            'Last 7 calendar days',
                                            style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary),
                                          ),
                                        ],
                                      ),
                                      const Icon(Icons.show_chart_rounded, color: AppColors.primaryBlue),
                                    ],
                                  ),
                                  const SizedBox(height: 32),
                                  SizedBox(
                                    height: 180,
                                    child: BarChart(
                                      BarChartData(
                                        alignment: BarChartAlignment.spaceAround,
                                        maxY: (dailyGoal * 1.5).toDouble().clamp(3000, 10000),
                                        barTouchData: BarTouchData(
                                          touchTooltipData: BarTouchTooltipData(
                                            getTooltipColor: (_) => AppColors.backgroundDark.withAlpha(230),
                                            tooltipBorder: const BorderSide(color: AppColors.primaryBlue, width: 1),
                                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                              final amount = rod.toY.round();
                                              return BarTooltipItem(
                                                '${HydrationCalculator.formatMl(amount, isMetric: isMetric)}\n',
                                                GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
                                                children: [
                                                  TextSpan(
                                                    text: amount >= dailyGoal ? 'Goal Met' : 'Incomplete',
                                                    style: GoogleFonts.outfit(
                                                      color: amount >= dailyGoal ? AppColors.accentMint : Colors.white60,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                        titlesData: FlTitlesData(
                                          show: true,
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              getTitlesWidget: (value, meta) {
                                                final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                                                final date = DateTime.now().subtract(Duration(days: 6 - value.toInt()));
                                                return Padding(
                                                  padding: const EdgeInsets.only(top: 8.0),
                                                  child: Text(
                                                    days[date.weekday - 1],
                                                    style: GoogleFonts.outfit(
                                                      fontSize: 12, 
                                                      fontWeight: FontWeight.bold,
                                                      color: DateTime.now().day == date.day ? AppColors.primaryBlue : AppColors.textSecondary,
                                                    ),
                                                  ),
                                                );
                                              },
                                              reservedSize: 30,
                                            ),
                                          ),
                                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        ),
                                        gridData: const FlGridData(show: false),
                                        borderData: FlBorderData(show: false),
                                        barGroups: barGroupsData,
                                      ),
                                    ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                                  ),
                                ],
                              ),
                            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

                            const SizedBox(height: 24),

                            // Stats Row 1
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    label: 'Weekly Average',
                                    value: HydrationCalculator.formatMl(weeklyAvg, isMetric: isMetric),
                                    icon: Icons.analytics_outlined,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildStatCard(
                                    label: 'Best Day',
                                    value: HydrationCalculator.formatMl(bestDay, isMetric: isMetric),
                                    icon: Icons.emoji_events_outlined,
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.1),

                            const SizedBox(height: 16),

                            // Stats Row 2
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    label: 'Goal Hit Rate',
                                    value: '${hitRate.toStringAsFixed(0)}%',
                                    icon: Icons.track_changes_rounded,
                                    color: AppColors.accentMint,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildStatCard(
                                    label: 'This Month',
                                    value: HydrationCalculator.formatMl(monthlyTotal, isMetric: isMetric),
                                    icon: Icons.water_drop_outlined,
                                    color: AppColors.secondaryAqua,
                                  ),
                                ),
                              ],
                            ).animate().fadeIn(delay: 550.ms).slideY(begin: 0.1),
                          ],
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Clinical References Card
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  color: AppColors.accentMint.withOpacity(0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.science_outlined, color: AppColors.accentMint, size: 22),
                        const SizedBox(width: 10),
                        Text('Science & References', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
                      ]),
                      const SizedBox(height: 12),
                      _buildReference(
                        'National Academies of Medicine',
                        'Adequate intake is 3.7L/day for men and 2.7L/day for women (total beverages).',
                      ),
                      const Divider(height: 20, color: Colors.white10),
                      _buildReference(
                        'World Health Organization',
                        'Hydration needs vary by physical activity, climate, and individual health status.',
                      ),
                      const Divider(height: 20, color: Colors.white10),
                      Text(
                        '⚠️ HydraFlow recommendations are general wellness guidelines. Consult a healthcare professional for personalized medical advice.',
                        style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textHint, height: 1.4),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 650.ms),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReference(String source, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(source, style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.accentMint)),
        const SizedBox(height: 4),
        Text(description, style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(label, style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
        ],
      ),
    );
  }

  int _calculateWeeklyAverage(List<HydrationLog> logs) {
    if (logs.isEmpty) return 0;
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final weeklyLogs = logs.where((l) => l.timestamp.isAfter(sevenDaysAgo)).toList();
    if (weeklyLogs.isEmpty) return 0;
    final total = weeklyLogs.fold(0, (sum, l) => sum + l.amountMl);
    return total ~/ 7;
  }

  int _calculateBestDay(List<HydrationLog> logs) {
    if (logs.isEmpty) return 0;
    final map = <String, int>{};
    for (var log in logs) {
      final key = '${log.timestamp.year}-${log.timestamp.month}-${log.timestamp.day}';
      map[key] = (map[key] ?? 0) + log.amountMl;
    }
    return map.values.fold(0, (max, v) => v > max ? v : max);
  }

  double _calculateHitRate(List<HydrationLog> logs, int dailyGoal) {
    if (logs.isEmpty) return 0;
    final map = <String, int>{};
    for (var log in logs) {
      final key = '${log.timestamp.year}-${log.timestamp.month}-${log.timestamp.day}';
      map[key] = (map[key] ?? 0) + log.amountMl;
    }
    if (map.isEmpty) return 0;
    final daysMet = map.values.where((v) => v >= dailyGoal).length;
    return (daysMet / map.length) * 100;
  }

  int _calculateMonthlyTotal(List<HydrationLog> logs) {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    return logs
        .where((l) => l.timestamp.isAfter(startOfMonth))
        .fold(0, (sum, l) => sum + l.amountMl);
  }

  List<BarChartGroupData> _buildRealBarGroups(List<HydrationLog> logs, int dailyGoal) {
    final now = DateTime.now();
    final last7Days = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));

    return List.generate(7, (i) {
      final date = last7Days[i];
      final dayTotal = logs
          .where((l) =>
              l.timestamp.year == date.year &&
              l.timestamp.month == date.month &&
              l.timestamp.day == date.day)
          .fold(0, (sum, l) => sum + l.amountMl);

      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: dayTotal.toDouble(),
            color: dayTotal >= dailyGoal ? AppColors.accentMint : AppColors.primaryBlue,
            width: 18,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: (dailyGoal * 1.2).toDouble(),
              color: Colors.white.withOpacity(0.04),
            ),
          ),
        ],
      );
    });
  }
}


