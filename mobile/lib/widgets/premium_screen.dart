import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_colors.dart';
import 'glass_card.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                            letterSpacing: -1,
                          ),
                        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                        const SizedBox(height: 12),
                        Text(
                          'Unlock your hydration potential',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            color: AppColors.secondaryAqua,
                            fontWeight: FontWeight.w600,
                          ),
                        ).animate().fadeIn(delay: 400.ms),
                        const SizedBox(height: 48),

                        _buildFeatureRow(
                          icon: Icons.analytics_outlined,
                          title: 'Advanced Analytics',
                          subtitle: 'View weekly/monthly trends and deep-tier behavioral velocity.',
                        ),
                        const SizedBox(height: 24),
                        _buildFeatureRow(
                          icon: Icons.auto_awesome_outlined,
                          title: 'Smart AI Reminders',
                          subtitle: 'Adaptive intervals based on weather and your activity level.',
                        ),
                        const SizedBox(height: 24),
                        _buildFeatureRow(
                          icon: Icons.palette_outlined,
                          title: 'Premium Themes',
                          subtitle: 'Unlock exclusive glassmorphism and deep sea visual styles.',
                        ),
                        const SizedBox(height: 24),
                        _buildFeatureRow(
                          icon: Icons.cloud_done_outlined,
                          title: 'Cloud Priority',
                          subtitle: 'Instant sync across all your devices with priority storage.',
                        ),

                        const SizedBox(height: 64),
                        GlassCard(
                          padding: const EdgeInsets.all(32),
                          color: Colors.amber.withOpacity(0.1),
                          border: Border.all(color: Colors.amber.withOpacity(0.2), width: 2),
                          child: Column(
                            children: [
                              Text(
                                '\$2.99 / month',
                                style: GoogleFonts.outfit(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Cancel anytime. Billed annually.',
                                style: GoogleFonts.outfit(
                                  color: Colors.white60,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 64,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Subscription logic
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'GO PRO NOW',
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
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
                              fontWeight: FontWeight.bold,
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
            border: Border.all(color: Colors.white10),
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
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.white60,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.1);
  }
}


