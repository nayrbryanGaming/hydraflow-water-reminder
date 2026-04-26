import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/notification_service.dart';
import '../../../services/local_db_service.dart';
import '../../../widgets/glass_card.dart';
import '../../../core/localization/app_strings.dart';

class RemindersScreen extends ConsumerStatefulWidget {
  const RemindersScreen({super.key});

  @override
  ConsumerState<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends ConsumerState<RemindersScreen> {
  bool _remindersEnabled = true;
  int _interval = 60;
  var _startTime = const TimeOfDay(hour: 8, minute: 0);
  var _endTime = const TimeOfDay(hour: 22, minute: 0);
  bool _isLoading = false;

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    try {
      if (_remindersEnabled) {
        final profile = await ref.read(localDbServiceProvider).getUserProfile().first;
        final logs = await ref.read(localDbServiceProvider).getTodaysHydrationLogs().first;
        final consumedMl = logs.fold<int>(0, (sum, item) => sum + item.amountMl);
        final goalMl = profile?.dailyWaterGoalMl ?? 2000;

        await NotificationService.instance.scheduleSmartReminders(
          consumedMl: consumedMl, 
          goalMl: goalMl,
          startHour: _startTime.hour,
          endHour: _endTime.hour,
        );
      } else {
        await NotificationService.instance.cancelAllReminders();
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.get('reminders_sync_success', ref), style: GoogleFonts.outfit()),
            backgroundColor: AppColors.primaryBlue,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppStrings.get('reminders', ref), style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
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
                _buildHeader(),
                const SizedBox(height: 32),
                
                // Master Toggle
                GlassCard(
                  padding: const EdgeInsets.all(8),
                  child: SwitchListTile(
                    title: Text(AppStrings.get('smart_reminders', ref), style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 18, color: isDark ? Colors.white : AppColors.textPrimary)),
                    subtitle: Text(AppStrings.get('adaptive_nudges', ref), style: GoogleFonts.outfit(color: isDark ? AppColors.textWhiteSecondary : AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
                    value: _remindersEnabled,
                    onChanged: (val) {
                      HapticFeedback.lightImpact();
                      setState(() => _remindersEnabled = val);
                    },
                    activeColor: AppColors.primaryBlue,
                    secondary: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _remindersEnabled ? AppColors.primaryBlue.withOpacity(0.2) : Colors.white10,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _remindersEnabled ? Icons.notifications_active_rounded : Icons.notifications_off_rounded,
                        color: _remindersEnabled ? AppColors.primaryBlue : AppColors.textHint,
                      ),
                    ),
                  ),
                ).animate().fadeIn().slideY(begin: 0.1),

                if (_remindersEnabled) ...[
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.tune_rounded, color: AppColors.secondaryAqua, size: 20),
                      const SizedBox(width: 8),
                      Text(AppStrings.get('interval_tuning', ref), style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 16, color: isDark ? Colors.white : AppColors.textPrimary)),
                    ],
                  ).animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: 16),
                  
                  // Interval Grid Options
                  _buildIntervalGrid(isDark).animate().fadeIn(delay: 200.ms),
                  
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      const Icon(Icons.wb_sunny_outlined, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text(AppStrings.get('active_window', ref), style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 16, color: isDark ? Colors.white : AppColors.textPrimary)),
                    ],
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 16),

                  // Time Pickers
                  Row(
                    children: [
                      Expanded(child: _buildTimePickerCard(AppStrings.get('wake', ref), _startTime, true)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTimePickerCard(AppStrings.get('sleep', ref), _endTime, false)),
                    ],
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 48),
                  
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 8,
                        shadowColor: AppColors.primaryBlue.withOpacity(0.4),
                      ),
                      child: _isLoading
                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                          : Text(AppStrings.get('sync_intervals', ref), style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 18)),
                    ),
                  ).animate().fadeIn(delay: 500.ms),
                ] else ...[
                  const SizedBox(height: 64),
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.bedtime_outlined, size: 64, color: AppColors.textHint.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        Text(AppStrings.get('reminders_paused', ref), style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w900, color: isDark ? AppColors.textWhiteSecondary : AppColors.textSecondary)),
                        const SizedBox(height: 8),
                        Text(AppStrings.get('no_nudges_desc', ref), style: GoogleFonts.outfit(color: isDark ? AppColors.textHint : AppColors.textHint, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                ],
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Smart Reminders',
          style: GoogleFonts.outfit(
            fontSize: 28, 
            fontWeight: FontWeight.w900, 
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ).animate().fadeIn().slideX(begin: -0.1),
        const SizedBox(height: 4),
        Text(
          AppStrings.get('notification_settings', ref),
          style: GoogleFonts.outfit(
            fontSize: 16, 
            color: isDark ? Colors.white70 : AppColors.textSecondary, 
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(delay: 150.ms),
      ],
    );
  }

  Widget _buildIntervalGrid(bool isDark) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: AppConstants.reminderIntervals.map((mins) {
        final isSelected = _interval == mins;
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _interval = mins);
          },
          child: AnimatedContainer(
            duration: 200.ms,
            width: (MediaQuery.of(context).size.width - 48 - 24) / 3, // 3 columns
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryBlue : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isSelected ? AppColors.primaryBlue.withValues(alpha: 0.5) : Colors.white12),
              boxShadow: isSelected ? [BoxShadow(color: AppColors.primaryBlue.withValues(alpha: 0.3), blurRadius: 12, spreadRadius: -2)] : [],
            ),
            child: Column(
              children: [
                Text(
                  '$mins',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: isSelected ? Colors.white : (isDark ? AppColors.textWhiteSecondary : AppColors.textPrimary),
                  ),
                ),
                Text(
                  'mins',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white70 : AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTimePickerCard(String title, TimeOfDay time, bool isStart) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.dark(
                  primary: AppColors.primaryBlue,
                  onPrimary: Colors.white,
                  surface: AppColors.backgroundCardDark,
                  onSurface: Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          HapticFeedback.lightImpact();
          setState(() {
            if (isStart) _startTime = picked;
            else _endTime = picked;
          });
        }
      },
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(title, style: GoogleFonts.outfit(color: isDark ? AppColors.textWhiteSecondary : AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              time.format(context),
              style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w900, color: isDark ? AppColors.textWhite : AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}


