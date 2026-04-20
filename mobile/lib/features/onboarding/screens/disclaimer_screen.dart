import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/glass_card.dart';

class DisclaimerScreen extends StatefulWidget {
  const DisclaimerScreen({super.key});

  @override
  State<DisclaimerScreen> createState() => _DisclaimerScreenState();
}

class _DisclaimerScreenState extends State<DisclaimerScreen> {
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
                  'Safety & Transparency',
                  style: GoogleFonts.outfit(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn().slideY(begin: 0.1),
                const SizedBox(height: 16),
                Text(
                  'HydraFlow is a hydration habit builder. By continuing, you acknowledge our data policies and medical disclaimers.',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    height: 1.5,
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
              'Clinical Standard Basis',
              'HydraFlow calculation models are based on population standards from the National Academies of Medicine (NAM) and WHO guidelines. These are generalized targets only.',
            ),
            const Divider(height: 32, color: Colors.white10),
            _buildTermItem(
              Icons.lock_outline_rounded,
              'Transparent Data Erasure',
              'We prioritize your privacy. You can export your data or delete your entire account permanently at any time via the "Danger Zone" in Settings.',
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2);
  }

  Widget _buildTermItem(IconData icon, String title, String desc) {
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
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                desc,
                style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textHint, height: 1.4),
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
              child: InkWell(
                onTap: () {
                  // This allows clicking the text itself to toggle the checkbox
                  setState(() => _hasAccepted = !_hasAccepted);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.outfit(
                        fontSize: 13, 
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      children: [
                        const TextSpan(text: 'I have read and agree to the '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: const TextStyle(color: AppColors.primaryBlue, decoration: TextDecoration.underline),
                        ),
                        const TextSpan(text: ' & '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: const TextStyle(color: AppColors.primaryBlue, decoration: TextDecoration.underline),
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
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
          'Continue into HydraFlow',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    ).animate().fadeIn(delay: 800.ms);
  }
}


