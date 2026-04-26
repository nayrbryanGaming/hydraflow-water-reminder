import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/local_db_service.dart';
import '../../../widgets/glass_card.dart';

import '../../../core/constants/local_db_constants.dart';
import '../../../core/localization/app_strings.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statsAsync = ref.watch(userStatsProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppStrings.get('achievements', ref), style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
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
          child: statsAsync.when(
            loading: () => _buildShimmer(context),
            error: (e, st) => Center(child: Text('Error: $e')),
            data: (stats) {
              final totalMl = stats?[LocalDbConstants.totalWaterMl] as int? ?? 0;

              final points = totalMl ~/ 10; // 1 point per 10ml
              final level = (totalMl ~/ 10000) + 1; // 1 level per 10L
              final progressToNextLevel = (totalMl % 10000) / 10000.0;

              return Column(
                children: [
                  _buildProgressHeader(context, ref, points, level, progressToNextLevel),
                  Expanded(
                    child: GridView.count(
                      padding: const EdgeInsets.all(24),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildBadge(context, ref, AppStrings.get('first_drop', ref), AppStrings.get('logged_first', ref), '💧', totalMl > 0, 0),
                        _buildBadge(context, ref, AppStrings.get('hydrator', ref), AppStrings.get('drank_5l', ref), '🔥', totalMl >= 5000, 1),
                        _buildBadge(context, ref, AppStrings.get('consistent', ref), AppStrings.get('drank_10l', ref), '🏆', totalMl >= 10000, 2),
                        _buildBadge(context, ref, AppStrings.get('ocean_master', ref), AppStrings.get('drank_50l', ref), '🌊', totalMl >= 50000, 3),
                        _buildBadge(context, ref, AppStrings.get('flow_state', ref), AppStrings.get('drank_100l', ref), '🧘‍♂️', totalMl >= 100000, 4),
                        _buildBadge(context, ref, AppStrings.get('aquaman', ref), AppStrings.get('drank_500l', ref), '🔱', totalMl >= 500000, 5),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900]! : Colors.grey[300]!,
      highlightColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800]! : Colors.grey[100]!,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(height: 120, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24))),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(6, (index) => Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)))),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader(BuildContext context, WidgetRef ref, int points, int level, double progress) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: GlassCard(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.stars_rounded, color: Colors.amber, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.get('reward_points', ref), style: GoogleFonts.outfit(color: isDark ? AppColors.textWhiteSecondary : AppColors.textSecondary, fontWeight: FontWeight.bold)),
                  Text('${points.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} ${AppStrings.get('pts', ref)}', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w900, color: isDark ? AppColors.textWhite : AppColors.textPrimary)),
                ],
              ),
            ),
            _buildLevelIndicator(context, ref, level, progress),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: -0.2);
  }

  Widget _buildLevelIndicator(BuildContext context, WidgetRef ref, int level, double progress) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 48,
              width: 48,
              child: CircularProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05),
                color: AppColors.primaryBlue,
                strokeWidth: 6,
              ),
            ),
            Text('$level', style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: isDark ? AppColors.textWhite : AppColors.textPrimary)),
          ],
        ),
        const SizedBox(height: 4),
        Text(AppStrings.get('lvl', ref), style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.primaryBlue)),
      ],
    );
  }

  Widget _buildBadge(BuildContext context, WidgetRef ref, String title, String desc, String icon, bool unlocked, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      padding: const EdgeInsets.all(16),
      color: unlocked ? AppColors.primaryBlue.withValues(alpha: 0.08) : (isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.03)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: unlocked ? AppColors.primaryBlue.withValues(alpha: 0.1) : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
              shape: BoxShape.circle,
            ),
            child: Text(
              icon,
              style: TextStyle(
                fontSize: 32,
                color: unlocked ? null : Colors.grey.withValues(alpha: 0.5),
              ).copyWith(shadows: unlocked ? [Shadow(color: AppColors.primaryBlue.withValues(alpha: 0.5), blurRadius: 10)] : []),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w900,
              color: unlocked ? (isDark ? AppColors.textWhite : AppColors.textPrimary) : AppColors.textHint,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 10,
              color: isDark ? AppColors.textWhiteSecondary : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms).scale(duration: 400.ms, curve: Curves.easeOutBack);
  }
}


