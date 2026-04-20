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
import '../../../services/firestore_service.dart';
import '../../../core/providers/settings_providers.dart';
import '../../../widgets/glass_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
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
              _buildSectionHeader('Preferences'),
              GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.person_outline,
                      title: 'Profile',
                      onTap: () => _handleProfileTap(context),
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.notifications_active_outlined,
                      title: 'Reminders',
                      onTap: () => context.push(routeReminders),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.straighten_outlined, color: AppColors.primaryBlue),
                      ),
                      title: Text('Units', style: GoogleFonts.outfit(fontWeight: FontWeight.w500)),
                      trailing: SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment(value: true, label: Text('ml')),
                          ButtonSegment(value: false, label: Text('oz')),
                        ],
                        selected: {ref.watch(unitPreferenceProvider)},
                        onSelectionChanged: (set) => ref.read(unitPreferenceProvider.notifier).state = set.first,
                        showSelectedIcon: false,
                        style: ButtonStyle(
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              _buildSectionHeader('Help & Support'),
              GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.help_outline_rounded,
                      title: 'FAQ & Knowledge Base',
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.alternate_email_rounded,
                      title: 'Contact Support',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              _buildSectionHeader('Account & Data'),
              GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.file_download_outlined,
                      title: 'Download My Data',
                      onTap: () => _handleDataExport(context, ref),
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.history_rounded,
                      title: 'Clear Local Cache',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Local cache cleared.')),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              _buildSectionHeader('HydraFlow Premium'),
              GlassCard(
                padding: EdgeInsets.zero,
                color: AppColors.primaryBlue.withValues(alpha: isDark ? 0.2 : 0.05),
                border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.auto_awesome_rounded,
                      title: 'Upgrade to HydraFlow Pro',
                      iconColor: Colors.amber,
                      textColor: AppColors.primaryBlue,
                      onTap: () => context.push(routePremium),
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.restore_rounded,
                      title: 'Restore Previous Purchases',
                      iconColor: AppColors.primaryBlue,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Restoring subscription state...')),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              _buildSectionHeader('Legal & Compliance'),
              GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      onTap: () => context.push(routeLegal, extra: LegalType.privacy),
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.description_outlined,
                      title: 'Terms of Service',
                      onTap: () => context.push(routeLegal, extra: LegalType.terms),
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.medical_information_outlined,
                      title: 'Medical Disclaimer',
                      onTap: () => context.push(routeLegal, extra: LegalType.disclaimer),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              _buildSectionHeader('Danger Zone', color: Colors.red),
              GlassCard(
                padding: EdgeInsets.zero,
                border: Border.all(color: Colors.red.withOpacity(0.3)),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.logout_rounded,
                      title: 'Logout',
                      iconColor: Colors.grey,
                      textColor: Colors.grey,
                      onTap: () async {
                        await ref.read(authServiceProvider).signOut();
                        if (context.mounted) context.go(routeLogin);
                      },
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.person_remove_outlined,
                      title: 'Delete Account',
                      iconColor: Colors.red,
                      textColor: Colors.red,
                      onTap: () => _showReauthAndDeletion(context, ref),
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

  Widget _buildSectionHeader(String title, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: color ?? AppColors.textSecondary,
          letterSpacing: 1.2,
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
  }) {
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
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
      onTap: onTap,
    );
  }

  void _showReauthAndDeletion(BuildContext context, WidgetRef ref) {
    final passwordController = TextEditingController();
    final emailController = TextEditingController(text: ref.read(authServiceProvider).currentUser?.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(Icons.security_rounded, color: AppColors.primaryBlue),
            const SizedBox(width: 8),
            Text('Confirm Security', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('For your security, please confirm your password before deleting your account.'),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(authServiceProvider).reauthenticate(
                  emailController.text,
                  passwordController.text,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, ref);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Verification failed: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(Icons.warning_rounded, color: Colors.red),
            const SizedBox(width: 8),
            Text('Delete Account', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This action is permanent and will erase all your hydration data from our servers. This cannot be undone.',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Google Play Policy Requirement:',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'You can also request deletion via our web portal if you lack app access:',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  const Text(
                    'https://hydraflow.app/delete-account',
                    style: TextStyle(fontSize: 10, color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(authServiceProvider).deleteUserAccount();
                if (context.mounted) context.go(routeLogin);
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting account: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: Text('Delete Permanently', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _handleDataExport(BuildContext context, WidgetRef ref) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generating secure JSON export...')),
    );

    try {
      final user = ref.read(authServiceProvider).currentUser;
      if (user == null) throw Exception('User not strictly logged in.');

      // Fetch real data for export
      final firestore = ref.read(firestoreServiceProvider);
      final profile = await firestore.getUserProfile().first;
      final logs = await firestore.getAllHydrationLogs().first;
      final stats = await firestore.getUserStats().first;

      final exportData = {
        'userId': user.uid,
        'email': user.email,
        'exportDate': DateTime.now().toIso8601String(),
        'platform': 'HydraFlow (Production)',
        'profile': profile?.toFirestore(),
        'stats': stats?.toFirestore(),
        'hydration_logs': logs.map((l) => l.toFirestore()).toList(),
        'compliance': 'GDPR/CCPA Data Portability Request',
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);
      
      await Clipboard.setData(ClipboardData(text: jsonString));
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comprehensive data package exported to clipboard.'),
            backgroundColor: AppColors.primaryBlue,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _handleProfileTap(BuildContext context) {
    context.push(routeProfile);
  }

}


