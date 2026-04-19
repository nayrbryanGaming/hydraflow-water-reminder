import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/firestore_service.dart';
import '../../../widgets/glass_card.dart';

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
        title: Text('Achievements', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
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
              final totalMl = stats?.totalWaterMl ?? 0;
              final points = totalMl ~/ 10; // 1 point per 10ml
              final level = (totalMl ~/ 10000) + 1; // 1 level per 10L
              final progressToNextLevel = (totalMl % 10000) / 10000.0;

              return Column(
                children: [
                  _buildProgressHeader(points, level, progressToNextLevel),
                  Expanded(
                    child: GridView.count(
                      padding: const EdgeInsets.all(24),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildBadge('First Drop', 'Logged first intake', '💧', totalMl > 0, 0),
                        _buildBadge('Hydrator', 'Drank 5L total', '🔥', totalMl >= 5000, 1),
                        _buildBadge('Consistent', 'Drank 10L total', '🏆', totalMl >= 10000, 2),
                        _buildBadge('Ocean Master', 'Drank 50L total', '🌊', totalMl >= 50000, 3),
                        _buildBadge('Flow State', 'Drank 100L total', '🧘‍♂️', totalMl >= 100000, 4),
                        _buildBadge('Aquaman', 'Drank 500L total', '🔱', totalMl >= 500000, 5),
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
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[800]!,
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

  Widget _buildProgressHeader(int points, int level, double progress) {
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
                  Text('Reward Points', style: GoogleFonts.outfit(color: AppColors.textSecondary)),
                  Text('${points.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} PTS', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            _buildLevelIndicator(level, progress),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: -0.2);
  }

  Widget _buildLevelIndicator(int level, double progress) {
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
                backgroundColor: Colors.white12,
                color: AppColors.primaryBlue,
                strokeWidth: 6,
              ),
            ),
            Text('$level', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        Text('LVL', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBadge(String title, String desc, String icon, bool unlocked, int index) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      color: unlocked ? AppColors.primaryBlue.withOpacity(0.05) : Colors.white10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: unlocked ? AppColors.primaryBlue.withOpacity(0.1) : Colors.black12,
              shape: BoxShape.circle,
            ),
            child: Text(
              icon,
              style: TextStyle(
                fontSize: 32,
                color: unlocked ? null : Colors.grey.withOpacity(0.5),
              ).copyWith(shadows: unlocked ? [Shadow(color: AppColors.primaryBlue.withOpacity(0.5), blurRadius: 10)] : []),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: unlocked ? Colors.white : AppColors.textHint,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms).scale(duration: 400.ms, curve: Curves\.easeOutBack);
  }
}

