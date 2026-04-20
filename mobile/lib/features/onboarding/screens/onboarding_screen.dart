import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      lottieUrl: 'https://assets5.lottiefiles.com/packages/lf20_ghp9oobf.json', // Water cycle
      icon: Icons.water_drop_rounded,
      emoji: '🌊',
      title: 'Science of Hydration',
      subtitle: 'Your body is 60% water',
      body:
          'Staying properly hydrated boosts energy, improves focus, and supports every cell in your body. Most people fall short — HydraFlow changes that.',
      gradientStart: const Color(0xFF0F2B5B),
      gradientEnd: const Color(0xFF1565C0),
      accentColor: const Color(0xFF56CCF2),
    ),
    _OnboardingPage(
      lottieUrl: 'https://assets10.lottiefiles.com/private_files/lf30_8ydv59.json', // Smart plan/Checklist
      icon: Icons.track_changes_rounded,
      emoji: '⚡',
      title: 'Your Personal Plan',
      subtitle: 'Calculated just for you',
      body:
          'Answer a few quick questions about your weight and activity level. HydraFlow calculates a scientifically-backed hydration target tailored to you.',
      gradientStart: const Color(0xFF0A3D2E),
      gradientEnd: const Color(0xFF1B7A56),
      accentColor: const Color(0xFF6FCF97),
    ),
    _OnboardingPage(
      lottieUrl: 'https://assets5.lottiefiles.com/packages/lf20_Tkw49O.json', // Smart AI/Robot
      icon: Icons.notifications_active_rounded,
      emoji: '🤖',
      title: 'Smart Reminders',
      subtitle: 'AI-powered nudges',
      body:
          'Our intelligent reminder engine adapts throughout the day — gentle in the morning, focused at midday, and motivating in the evening to close your goal.',
      gradientStart: const Color(0xFF2D1B69),
      gradientEnd: const Color(0xFF5B2D8E),
      accentColor: const Color(0xFFBB6BD9),
    ),
    _OnboardingPage(
      lottieUrl: 'https://assets2.lottiefiles.com/packages/lf20_m6cu96ye.json', // Privacy/Security
      icon: Icons.security_rounded,
      emoji: '🔒',
      title: 'Privacy First',
      subtitle: 'Your data, your control',
      body:
          'We use your weight only to calculate hydration goals — never shared or sold. You can delete your account and all data at any time from Settings.',
      gradientStart: const Color(0xFF1A2B4A),
      gradientEnd: const Color(0xFF0D3B72),
      accentColor: const Color(0xFFF2C94C),
      hasDisclaimer: true,
    ),
    _OnboardingPage(
      lottieUrl: 'https://assets8.lottiefiles.com/packages/lf20_mizp2wub.json', // Success/Launch
      icon: Icons.bolt_rounded,
      emoji: '🚀',
      title: 'Success Signals',
      subtitle: 'Critical for habit building',
      body:
          'To keep you on track, HydraFlow sends gentle nudges. We politely request notification access next to ensure you never miss a hydration window.',
      gradientStart: const Color(0xFF1A1A2E),
      gradientEnd: const Color(0xFF16213E),
      accentColor: const Color(0xFFE94560),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentIndex];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [page.gradientStart, page.gradientEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: TextButton(
                    onPressed: () => context.go(routeLogin),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      backgroundColor: Colors.white.withOpacity(0.05),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'Skip',
                      style: GoogleFonts.outfit(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),

              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentIndex = index),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _PageContent(page: _pages[index]);
                  },
                ),
              ),

              // Bottom controls
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: Column(
                  children: [
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: _pages.length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: page.accentColor,
                        dotColor: Colors.white24,
                        dotHeight: 8,
                        dotWidth: 8,
                        expansionFactor: 3,
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (_currentIndex == _pages.length - 1)
                      _buildGetStartedButtons(context)
                    else
                      _buildNavButtons(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGetStartedButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () => context.go(routeDisclaimer),
            style: ElevatedButton.styleFrom(
              backgroundColor: _pages.last.accentColor,
              foregroundColor: const Color(0xFF1A2B4A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Start My Scientific Assessment',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => context.go(routeLogin),
          child: Text(
            'Already have an account? Log in',
            style: GoogleFonts.outfit(color: Colors.white60, fontSize: 14),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildNavButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => context.go(routeLogin),
          child: Text(
            'Log in',
            style: GoogleFonts.outfit(color: Colors.white60, fontSize: 16),
          ),
        ),
        GestureDetector(
          onTap: () {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            decoration: BoxDecoration(
              color: _pages[_currentIndex].accentColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Next',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF1A2B4A),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded,
                    color: Color(0xFF1A2B4A), size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PageContent extends StatelessWidget {
  final _OnboardingPage page;

  const _PageContent({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: Lottie.network(
              page.lottieUrl,
              height: 120,
              width: 120,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                page.icon,
                size: 80,
                color: page.accentColor,
              ),
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 48),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.2,
              height: 1.1,
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, curve: Curves.easeOutBack),
          const SizedBox(height: 16),
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: page.accentColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 24),
          Text(
            page.body,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              height: 1.6,
            ),
          ).animate().fadeIn(delay: 600.ms),
          if (page.hasDisclaimer) ...[
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: page.accentColor, size: 20),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'HydraFlow is not a medical device. Consult a physician for specific health needs.',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 800.ms).scale(),
          ],
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final String lottieUrl;
  final IconData icon;
  final String emoji;
  final String title;
  final String subtitle;
  final String body;
  final Color gradientStart;
  final Color gradientEnd;
  final Color accentColor;
  final bool hasDisclaimer;

  _OnboardingPage({
    required this.lottieUrl,
    required this.icon,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.gradientStart,
    required this.gradientEnd,
    required this.accentColor,
    this.hasDisclaimer = false,
  });
}


