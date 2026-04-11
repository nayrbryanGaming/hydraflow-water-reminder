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
      appBar: AppBar(
        title: const Text('HydraFlow'),
        actions: [
          IconButton(icon: const Icon(Icons.insert_chart_outlined), onPressed: () => context.push(routeAnalytics)),
          IconButton(icon: const Icon(Icons.emoji_events_outlined), onPressed: () => context.push(routeAchievements)),
          IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () => context.push(routeSettings)),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (profile) {
          if (profile == null) return const Center(child: Text('No profile data'));

          return logsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
            data: (logs) {
              final consumedMl = logs.fold<int>(0, (sum, item) => sum + item.amountMl);
              final goalMl = profile.dailyWaterGoalMl;
              final percent = HydrationCalculator.calculatePercentage(consumedMl, goalMl);
              final status = HydrationCalculator.getStatus(percent);

              return SafeArea(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text('Hello, ${profile.displayName} 👋', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(HydrationCalculator.getMotivationalMessage(status), style: TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 48),
                    Center(
                      child: CircularPercentIndicator(
                        radius: 120.0,
                        lineWidth: 24.0,
                        percent: percent,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.water_drop, color: AppColors.primaryBlue, size: 40),
                            const SizedBox(height: 8),
                            Text('${HydrationCalculator.formatMl(consumedMl)}', style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold)),
                            Text('/ ${HydrationCalculator.formatMl(goalMl)}', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                          ],
                        ),
                        progressColor: AppColors.primaryBlue,
                        backgroundColor: AppColors.divider,
                        circularStrokeCap: CircularStrokeCap.round,
                        animation: true,
                        animationDuration: 1000,
                      ),
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton.icon(
                      onPressed: () => context.push('$routeHome/log-water'),
                      icon: const Icon(Icons.add),
                      label: const Text('Log Water Intake'),
                    ),
                    const SizedBox(height: 32),
                    Text('Today\'s Logs', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    logs.isEmpty
                        ? const Center(child: Text('No logs yet today. Drink up!'))
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: logs.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final log = logs[index];
                              return ListTile(
                                tileColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.divider,
                                  child: Text(log.drinkType.emoji, style: const TextStyle(fontSize: 20)),
                                ),
                                title: Text('${log.amountMl} ml ${log.drinkType.label}'),
                                subtitle: Text('${log.timestamp.hour}:${log.timestamp.minute.toString().padLeft(2, '0')}'),
                              );
                            },
                          ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
