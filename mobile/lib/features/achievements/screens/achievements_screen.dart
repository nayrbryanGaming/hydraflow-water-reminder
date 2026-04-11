import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: GridView.count(
        padding: const EdgeInsets.all(24),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildBadge('First Drop', 'Log your first water intake', '💧', true),
          _buildBadge('3 Day Streak', 'Hit your goal 3 days in a row', '🔥', true),
          _buildBadge('7 Day Streak', 'Hit your goal 7 days in a row', '🏆', false),
          _buildBadge('Ocean Master', 'Drink 50L total', '🌊', false),
          _buildBadge('Early Bird', 'Log water before 7 AM', '🌅', true),
          _buildBadge('Night Owl', 'Log water after 10 PM', '🦉', false),
        ],
      ),
    );
  }

  Widget _buildBadge(String title, String desc, String icon, bool unlocked) {
    return Card(
      color: unlocked ? Colors.white : Colors.grey[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            icon,
            style: TextStyle(
              fontSize: 48,
              color: unlocked ? null : Colors.grey.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: unlocked ? AppColors.textPrimary : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              desc,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: unlocked ? AppColors.textSecondary : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
