import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_colors.dart';
import 'glass_card.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.backgroundDeepSea,
                  AppColors.backgroundDark,
                ],
              ),
            ),
          ),

          // Animated Orbs
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryBlue.withOpacity(0.2),
              ),
            ).animate(onPlay: (controller) => controller.repeat()).scale(
                  duration: 5.seconds,
                  begin: const Offset(1, 1),
                  end: const Offset(1.5, 1.5),
                ).blur(begin: const Offset(40, 40), end: const Offset(60, 60)),
          ),

          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Icon(Icons.stars_rounded, size: 100, color: Colors.amber)
                            .animate()
                            .scale(duration: 800.ms, curve: Curves.easeOutBack)
                            .shimmer(delay: 1.seconds, duration: 2.seconds),
                        const SizedBox(height: 24),
                        Text(
                          'HydraFlow PRO',
                          style: GoogleFonts.outfit(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -1.5,
                          ),
                        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                        const SizedBox(height: 12),
                        Text(
                          'Master Your Hydration Journey',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            color: AppColors.secondaryAqua,
                            fontWeight: FontWeight.w800,
                          ),
                        ).animate().fadeIn(delay: 400.ms),
                        const SizedBox(height: 48),

                        _buildFeatureRow(
                          icon: Icons.analytics_outlined,
                          title: 'Advanced Analytics',
                          subtitle: 'Deep-tier behavioral trends and hydration velocity mapping.',
                        ),
                        const SizedBox(height: 24),
                        _buildFeatureRow(
                          icon: Icons.auto_awesome_outlined,
                          title: 'Smart Adaptive Nudges',
                          subtitle: 'Intelligent reminder intervals that adapt to your daily rhythm.',
                        ),
                        const SizedBox(height: 24),
                        _buildFeatureRow(
                          icon: Icons.palette_outlined,
                          title: 'Exclusive Themes',
                          subtitle: 'Premium visual styles including Cyber Liquid and Deep Sea Glass.',
                        ),
                        const SizedBox(height: 24),
                        _buildFeatureRow(
                          icon: Icons.offline_pin_outlined,
                          title: 'Offline Sovereignty',
                          subtitle: 'Enhanced local data encryption and priority offline processing.',
                        ),

                        const SizedBox(height: 64),
                        GlassCard(
                          padding: const EdgeInsets.all(32),
                          color: Colors.amber.withOpacity(0.15),
                          border: Border.all(color: Colors.amber.withOpacity(0.3), width: 2),
                          child: Column(
                            children: [
                              Text(
                                '\$2.99 / month',
                                style: GoogleFonts.outfit(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -1,
                                ),
                              ),
                              Text(
                                'Cancel anytime. Pro-tier features.',
                                style: GoogleFonts.outfit(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 64,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Local purchase simulation
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    elevation: 12,
                                    shadowColor: Colors.amber.withOpacity(0.3),
                                  ),
                                  child: Text(
                                    'ACTIVATE PRO',
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 800.ms).scale(delay: 800.ms, curve: Curves.easeOutBack),
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'NOT RIGHT NOW',
                            style: GoogleFonts.outfit(
                              color: Colors.white38,
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow({required IconData icon, required String title, required String subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10, width: 2),
          ),
          child: Icon(icon, color: Colors.amber, size: 28),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.1);
  }
}
