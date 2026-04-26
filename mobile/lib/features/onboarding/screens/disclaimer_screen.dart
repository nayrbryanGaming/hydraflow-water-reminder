import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/glass_card.dart';
import '../../../core/localization/app_strings.dart';

class DisclaimerScreen extends ConsumerStatefulWidget {
  const DisclaimerScreen({super.key});

  @override
  ConsumerState<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends ConsumerState<DisclaimerScreen> {
  bool _hasAccepted = false;

  Future<void> _acceptDisclaimer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_accepted_disclaimer', true);
    if (mounted) context.go(routeQuiz);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isDark ? AppColors.backgroundDeepSea : const Color(0xFFF0F9FF),
              isDark ? AppColors.backgroundDark : Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                const Spacer(),
                _buildIconContainer(),
                const SizedBox(height: 32),
                Text(
                  AppStrings.get('safety_transparency', ref),
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn().slideY(begin: 0.1),
                const SizedBox(height: 16),
                Text(
                  AppStrings.get('disclaimer_body', ref),
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: isDark ? Colors.white70 : AppColors.textSecondary,
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 40),
                _buildTermsCard(),
                const Spacer(),
                _buildAcknowledgementCheckbox(),
                const SizedBox(height: 24),
                _buildContinueButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2), width: 2),
      ),
      child: const Icon(
        Icons.balance_rounded,
        size: 72,
        color: AppColors.primaryBlue,
      ),
    ).animate().scale(curve: Curves.elasticOut, duration: 800.ms);
  }

  Widget _buildTermsCard() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildTermItem(
              Icons.health_and_safety_outlined,
              AppStrings.get('clinical_standard', ref),
              AppStrings.get('clinical_desc', ref),
            ),
            const Divider(height: 32, color: Colors.white10),
            _buildTermItem(
              Icons.lock_outline_rounded,
              AppStrings.get('transparent_erasure', ref),
              AppStrings.get('erasure_desc', ref),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2);
  }

  Widget _buildTermItem(IconData icon, String title, String desc) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: AppColors.secondaryAqua),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 16, color: isDark ? Colors.white : AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                desc,
                style: GoogleFonts.outfit(fontSize: 13, color: isDark ? Colors.white60 : AppColors.textHint, height: 1.4, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAcknowledgementCheckbox() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () => setState(() => _hasAccepted = !_hasAccepted),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Checkbox(
              value: _hasAccepted,
              onChanged: (val) => setState(() => _hasAccepted = val ?? false),
              activeColor: AppColors.primaryBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.outfit(
                    fontSize: 13, 
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  children: [
                    TextSpan(text: AppStrings.get('agree_terms_start', ref)),
                    TextSpan(
                      text: AppStrings.get('agree_terms_mid', ref),
                      style: const TextStyle(color: AppColors.primaryBlue, decoration: TextDecoration.underline),
                    ),
                    const TextSpan(text: ' & '),
                    TextSpan(
                      text: AppStrings.get('agree_terms_end', ref),
                      style: const TextStyle(color: AppColors.primaryBlue, decoration: TextDecoration.underline),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildContinueButton() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _hasAccepted ? _acceptDisclaimer : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: _hasAccepted ? 8 : 0,
          shadowColor: AppColors.primaryBlue.withOpacity(0.5),
        ),
        child: Text(
          AppStrings.get('continue_hf', ref),
          style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 18),
        ),
      ),
    ).animate().fadeIn(delay: 800.ms);
  }
}
