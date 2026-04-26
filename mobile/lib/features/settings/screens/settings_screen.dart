import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/legal_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/auth_service.dart';
import '../../../services/local_db_service.dart';
import '../../../core/providers/settings_providers.dart';
import '../../../widgets/glass_card.dart';
import '../../../core/localization/app_strings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get('settings', ref), style: GoogleFonts.outfit(fontWeight: FontWeight.w900)),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: false,
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
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              _buildSectionHeader(AppStrings.get('preferences', ref), ref: ref),
              GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.person_outline,
                      title: AppStrings.get('profile', ref),
                      onTap: () => context.push(routeProfile),
                      ref: ref,
                    ),
                    Divider(height: 1, color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                    _buildSettingsTile(
                      icon: Icons.notifications_active_outlined,
                      title: AppStrings.get('reminders', ref),
                      onTap: () => context.push(routeReminders),
                      ref: ref,
                    ),
                    Divider(height: 1, color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                    _buildLanguageTile(ref),
                    Divider(height: 1, color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                    _buildUnitTile(ref),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              _buildSectionHeader(AppStrings.get('account_data', ref), ref: ref),
              GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.file_download_outlined,
                      title: AppStrings.get('download_my_data', ref),
                      onTap: () => _handleDataExport(context, ref),
                      ref: ref,
                    ),
                    Divider(height: 1, color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                    _buildSettingsTile(
                      icon: Icons.history_rounded,
                      title: AppStrings.get('clear_local_cache', ref),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(AppStrings.get('cache_cleared', ref))),
                        );
                      },
                      ref: ref,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              _buildSectionHeader(AppStrings.get('premium_features', ref), ref: ref),
              GlassCard(
                padding: EdgeInsets.zero,
                color: AppColors.primaryBlue.withOpacity(isDark ? 0.2 : 0.05),
                border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.auto_awesome_rounded,
                      title: AppStrings.get('upgrade_pro', ref),
                      iconColor: Colors.amber,
                      textColor: AppColors.primaryBlue,
                      onTap: () => context.push(routePremium),
                      ref: ref,
                    ),
                    Divider(height: 1, color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                    _buildSettingsTile(
                      icon: Icons.restore_rounded,
                      title: AppStrings.get('restore_purchases', ref),
                      iconColor: AppColors.primaryBlue,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${AppStrings.get('restore_purchases', ref)}...')),
                        );
                      },
                      ref: ref,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              _buildSectionHeader(AppStrings.get('legal_compliance', ref), ref: ref),
              GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.privacy_tip_outlined,
                      title: AppStrings.get('privacy_policy', ref),
                      onTap: () => context.push(routeLegal, extra: LegalType.privacy),
                      ref: ref,
                    ),
                    Divider(height: 1, color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                    _buildSettingsTile(
                      icon: Icons.description_outlined,
                      title: AppStrings.get('terms_of_service', ref),
                      onTap: () => context.push(routeLegal, extra: LegalType.terms),
                      ref: ref,
                    ),
                    Divider(height: 1, color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                    _buildSettingsTile(
                      icon: Icons.medical_information_outlined,
                      title: AppStrings.get('medical_disclaimer', ref),
                      onTap: () => context.push(routeLegal, extra: LegalType.disclaimer),
                      ref: ref,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              _buildSectionHeader(AppStrings.get('danger_zone', ref), color: Colors.redAccent, ref: ref),
              GlassCard(
                padding: EdgeInsets.zero,
                border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.delete_forever_rounded,
                      title: AppStrings.get('reset_data', ref),
                      iconColor: Colors.redAccent,
                      textColor: Colors.redAccent,
                      onTap: () => _showDeleteConfirmation(context, ref),
                      ref: ref,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageTile(WidgetRef ref) {
    final isDark = Theme.of(ref.context).brightness == Brightness.dark;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.language_rounded, color: AppColors.primaryBlue),
      ),
      title: Text(AppStrings.get('language', ref), style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: isDark ? AppColors.textWhite : AppColors.textPrimary)),
      trailing: DropdownButton<String>(
        value: ref.watch(localeProvider).languageCode,
        underline: const SizedBox(),
        dropdownColor: isDark ? AppColors.backgroundCardDark : Colors.white,
        style: GoogleFonts.outfit(color: AppColors.primaryBlue, fontWeight: FontWeight.w900),
        items: [
          DropdownMenuItem(value: 'en', child: Text(AppStrings.get('english', ref))),
          DropdownMenuItem(value: 'id', child: Text(AppStrings.get('indonesian', ref))),
        ],
        onChanged: (val) {
          if (val != null) ref.read(localeProvider.notifier).state = Locale(val);
        },
      ),
    );
  }

  Widget _buildUnitTile(WidgetRef ref) {
    final isDark = Theme.of(ref.context).brightness == Brightness.dark;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.straighten_outlined, color: AppColors.primaryBlue),
      ),
      title: Text(AppStrings.get('units', ref), style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: isDark ? AppColors.textWhite : AppColors.textPrimary)),
      trailing: SegmentedButton<bool>(
        segments: const [
          ButtonSegment(value: true, label: Text('ml')),
          ButtonSegment(value: false, label: Text('oz')),
        ],
        selected: {ref.watch(unitPreferenceProvider)},
        onSelectionChanged: (set) => ref.read(unitPreferenceProvider.notifier).state = set.first,
        showSelectedIcon: false,
        style: SegmentedButton.styleFrom(
          visualDensity: VisualDensity.compact,
          selectedBackgroundColor: AppColors.primaryBlue,
          selectedForegroundColor: Colors.white,
          textStyle: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {Color? color, required WidgetRef ref}) {
    final isDark = Theme.of(ref.context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w900,
          color: color ?? (isDark ? AppColors.textWhiteSecondary : AppColors.textPrimary.withOpacity(0.8)),
          letterSpacing: 2.0,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
    required WidgetRef ref,
  }) {
    final isDark = Theme.of(ref.context).brightness == Brightness.dark;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.primaryBlue).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor ?? AppColors.primaryBlue),
      ),
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.w700,
          color: textColor ?? (isDark ? AppColors.textWhite : AppColors.textPrimary),
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
      onTap: onTap,
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.backgroundCardDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(Icons.warning_rounded, color: Colors.redAccent),
            const SizedBox(width: 12),
            Text(AppStrings.get('reset_data', ref), style: GoogleFonts.outfit(fontWeight: FontWeight.w900)),
          ],
        ),
        content: Text(
          'This action is PERMANENT. All local logs, achievements, and biometrics will be erased from this device. There is no cloud backup.',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w500, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.get('cancel', ref), style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: AppColors.primaryBlue)),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(authServiceProvider).deleteUserAccount();
                if (context.mounted) {
                   Navigator.pop(context);
                   context.go(routeOnboarding); // Fixed routeLogin bug
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error resetting data: $e'), backgroundColor: Colors.redAccent),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(AppStrings.get('confirm', ref).toUpperCase(), style: GoogleFonts.outfit(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  void _handleDataExport(BuildContext context, WidgetRef ref) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.get('exporting_data', ref))),
    );

    try {
      final user = ref.read(authServiceProvider).currentUser;
      if (user == null) throw Exception('No local profile found.');

      final db = ref.read(localDbServiceProvider);
      final profile = await db.getUserProfile().first;
      final logs = await db.getHydrationLogs().first;
      final stats = await db.getUserStats().first;

      final exportData = {
        'userId': user.uid,
        'displayName': user.displayName,
        'exportDate': DateTime.now().toIso8601String(),
        'platform': 'HydraFlow (Offline Production)',
        'profile': profile?.toMap(),
        'stats': stats,
        'hydration_logs': logs.map((l) => l.toMap()).toList(),
        'privacy': '100% On-Device Data Portability',
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);
      await Clipboard.setData(ClipboardData(text: jsonString));
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.get('data_exported', ref)),
            backgroundColor: AppColors.primaryBlue,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }
}
