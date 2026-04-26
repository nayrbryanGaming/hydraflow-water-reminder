import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/localization/app_strings.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  List<_OnboardingPage> get _pages => [
    _OnboardingPage(
      icon: Icons.water_drop_rounded,
      emoji: '🌊',
      titleKey: 'onboarding_1_title',
      subtitleKey: 'onboarding_1_sub',
      bodyKey: 'onboarding_1_body',
      gradientStart: const Color(0xFF0F2B5B),
      gradientEnd: const Color(0xFF1565C0),
      accentColor: const Color(0xFF56CCF2),
    ),
    _OnboardingPage(
      icon: Icons.track_changes_rounded,
      emoji: '⚡',
      titleKey: 'onboarding_2_title',
      subtitleKey: 'onboarding_2_sub',
      bodyKey: 'onboarding_2_body',
      gradientStart: const Color(0xFF0A3D2E),
      gradientEnd: const Color(0xFF1B7A56),
      accentColor: const Color(0xFF6FCF97),
    ),
    _OnboardingPage(
      icon: Icons.notifications_active_rounded,
      emoji: '🤖',
      titleKey: 'onboarding_3_title',
      subtitleKey: 'onboarding_3_sub',
      bodyKey: 'onboarding_3_body',
      gradientStart: const Color(0xFF2D1B69),
      gradientEnd: const Color(0xFF5B2D8E),
      accentColor: const Color(0xFFBB6BD9),
    ),
    _OnboardingPage(
      icon: Icons.security_rounded,
      emoji: '🔒',
      titleKey: 'onboarding_4_title',
      subtitleKey: 'onboarding_4_sub',
      bodyKey: 'onboarding_4_body',
      gradientStart: const Color(0xFF1A2B4A),
      gradientEnd: const Color(0xFF0D3B72),
      accentColor: const Color(0xFFF2C94C),
      hasDisclaimer: true,
    ),
    _OnboardingPage(
      icon: Icons.bolt_rounded,
      emoji: '🚀',
      titleKey: 'onboarding_5_title',
      subtitleKey: 'onboarding_5_sub',
      bodyKey: 'onboarding_5_body',
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
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: TextButton(
                    onPressed: () => context.go(routeDisclaimer),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      backgroundColor: Colors.white.withOpacity(0.1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      AppStrings.get('skip', ref).toUpperCase(),
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ),

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
          height: 64,
          child: ElevatedButton(
            onPressed: () => context.go(routeDisclaimer),
            style: ElevatedButton.styleFrom(
              backgroundColor: _pages.last.accentColor,
              foregroundColor: const Color(0xFF1A1A2E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 12,
              shadowColor: _pages.last.accentColor.withOpacity(0.4),
            ),
            child: Text(
              AppStrings.get('start_assessment', ref).toUpperCase(),
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildNavButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
            decoration: BoxDecoration(
              color: _pages[_currentIndex].accentColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: _pages[_currentIndex].accentColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.get('next', ref).toUpperCase(),
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF1A2B4A),
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(width: 12),
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

class _PageContent extends ConsumerWidget {
  final _OnboardingPage page;

  const _PageContent({required this.page});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 2),
              boxShadow: [
                BoxShadow(
                  color: page.accentColor.withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              page.icon,
              size: 100,
              color: page.accentColor,
            ),
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 56),
          Text(
            AppStrings.get(page.titleKey, ref),
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.5,
              height: 1.1,
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, curve: Curves.easeOutBack),
          const SizedBox(height: 16),
          Text(
            AppStrings.get(page.subtitleKey, ref),
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: page.accentColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 24),
          Text(
            AppStrings.get(page.bodyKey, ref),
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ).animate().fadeIn(delay: 600.ms),
          if (page.hasDisclaimer) ...[
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                children: [
                  Icon(Icons.shield_rounded, color: page.accentColor, size: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      AppStrings.get('medical_desc', ref),
                      style: GoogleFonts.outfit(
                        color: Colors.white70, 
                        fontSize: 13, 
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 800.ms).scale(begin: const Offset(0.9, 0.9)),
          ],
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String emoji;
  final String titleKey;
  final String subtitleKey;
  final String bodyKey;
  final Color gradientStart;
  final Color gradientEnd;
  final Color accentColor;
  final bool hasDisclaimer;

  _OnboardingPage({
    required this.icon,
    required this.emoji,
    required this.titleKey,
    required this.subtitleKey,
    required this.bodyKey,
    required this.gradientStart,
    required this.gradientEnd,
    required this.accentColor,
    this.hasDisclaimer = false,
  });
}
