import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/hydration_calculator.dart';
import '../../../widgets/glass_card.dart';
import '../providers/quiz_provider.dart';
import '../../../core/localization/app_strings.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5;

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _showCalculatingOverlay();
    }
  }

  void _showCalculatingOverlay() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _CalculatingOverlay(
        onComplete: () {
          Navigator.pop(context);
          context.go(routePermissionPriming);
        },
      ),
    );
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
          child: Column(
            children: [
              _buildAppBar(),
              _buildProgressBar(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) => setState(() => _currentStep = index),
                  children: [
                    _buildStep0Disclaimer(),
                    _buildStep1Biometrics(),
                    _buildStep2Activity(),
                    _buildStep3Climate(),
                    _buildStep4Objective(),
                  ],
                ),
              ),
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          if (_currentStep > 0)
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          const Spacer(),
          Text(
            AppStrings.get('step_of', ref)
                .replaceAll('%s', '${_currentStep + 1}')
                .replaceFirst('${_currentStep + 1}', '${_currentStep + 1}', 8) // Fix for second %s
                .replaceAll('%s', '$_totalSteps'),
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w900,
              color: AppColors.primaryBlue,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildStep0Disclaimer() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.gavel_rounded, size: 64, color: AppColors.primaryBlue),
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 32),
          Text(
            AppStrings.get('medical_transparency', ref),
            style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w900, color: isDark ? AppColors.textWhite : AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.get('medical_desc_quiz', ref),
            style: GoogleFonts.outfit(color: isDark ? AppColors.textWhiteSecondary : AppColors.textSecondary, height: 1.5, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: Colors.amber),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppStrings.get('agreement_quiz', ref),
                    style: GoogleFonts.outfit(fontSize: 12, color: isDark ? AppColors.textWhiteSecondary : AppColors.textSecondary, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Stack(
        children: [
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 6,
            width: MediaQuery.of(context).size.width * ((_currentStep + 1) / _totalSteps),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primaryBlue, AppColors.secondaryAqua]),
              borderRadius: BorderRadius.circular(3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1Biometrics() {
    final state = ref.watch(quizProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.get('biometrics_title', ref),
            style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w900, color: isDark ? AppColors.textWhite : AppColors.textPrimary),
            textAlign: TextAlign.center,
          ).animate().fadeIn().slideY(begin: 0.1),
          const SizedBox(height: 12),
          Text(
            AppStrings.get('biometrics_desc', ref),
            style: GoogleFonts.outfit(color: isDark ? AppColors.textWhiteSecondary : AppColors.textSecondary, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 48),
          _buildSlider(
            label: AppStrings.get('weight', ref),
            value: state.weightKg,
            min: 30,
            max: 150,
            unit: 'kg',
            onChanged: (val) => ref.read(quizProvider.notifier).setWeight(val),
          ),
          const SizedBox(height: 32),
          _buildSlider(
            label: AppStrings.get('age', ref),
            value: state.age.toDouble(),
            min: 10,
            max: 90,
            unit: 'yrs',
            onChanged: (val) => ref.read(quizProvider.notifier).setAge(val.toInt()),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2Activity() {
    final state = ref.watch(quizProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.get('activity_level_quiz', ref),
            style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w900, color: isDark ? AppColors.textWhite : AppColors.textPrimary),
          ),
          const SizedBox(height: 32),
          _buildOptionCard(
            title: AppStrings.get('sedentary', ref),
            subtitle: AppStrings.get('sedentary_desc', ref),
            icon: Icons.chair_outlined,
            selected: state.activityLevel == ActivityLevel.sedentary,
            onTap: () => ref.read(quizProvider.notifier).setActivity(ActivityLevel.sedentary),
          ),
          _buildOptionCard(
            title: AppStrings.get('moderate', ref),
            subtitle: AppStrings.get('moderate_desc', ref),
            icon: Icons.directions_walk_rounded,
            selected: state.activityLevel == ActivityLevel.moderate,
            onTap: () => ref.read(quizProvider.notifier).setActivity(ActivityLevel.moderate),
          ),
          _buildOptionCard(
            title: AppStrings.get('active_lvl', ref),
            subtitle: AppStrings.get('active_desc', ref),
            icon: Icons.fitness_center_rounded,
            selected: state.activityLevel == ActivityLevel.active,
            onTap: () => ref.read(quizProvider.notifier).setActivity(ActivityLevel.active),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3Climate() {
    final state = ref.watch(quizProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.get('environment_title', ref),
            style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w900, color: isDark ? AppColors.textWhite : AppColors.textPrimary),
          ),
          const SizedBox(height: 48),
          Row(
            children: [
              Expanded(
                child: _buildChoiceCard(
                  title: AppStrings.get('moderate_climate', ref),
                  icon: Icons.cloud_outlined,
                  selected: !state.isHotClimate,
                  onTap: () => ref.read(quizProvider.notifier).setClimate(false),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildChoiceCard(
                  title: AppStrings.get('hot_humid_climate_quiz', ref),
                  icon: Icons.wb_sunny_outlined,
                  selected: state.isHotClimate,
                  onTap: () => ref.read(quizProvider.notifier).setClimate(true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            AppStrings.get('climate_desc', ref),
            style: GoogleFonts.outfit(color: isDark ? AppColors.textWhiteSecondary : AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStep4Objective() {
    final state = ref.watch(quizProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.get('objective_title', ref),
            style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w900, color: isDark ? AppColors.textWhite : AppColors.textPrimary),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildObjectiveChip(
                HydrationObjective.cognitive,
                AppStrings.get('cognitive_focus', ref),
                Icons.psychology_outlined,
                state.objective == HydrationObjective.cognitive,
              ),
              _buildObjectiveChip(
                HydrationObjective.energy,
                AppStrings.get('energy_levels', ref),
                Icons.bolt_rounded,
                state.objective == HydrationObjective.energy,
              ),
              _buildObjectiveChip(
                HydrationObjective.skin,
                AppStrings.get('skin_health', ref),
                Icons.face_retouching_natural_outlined,
                state.objective == HydrationObjective.skin,
              ),
              _buildObjectiveChip(
                HydrationObjective.general,
                AppStrings.get('general_health', ref),
                Icons.favorite_outline_rounded,
                state.objective == HydrationObjective.general,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: _nextStep,
          child: Text(
            _currentStep == _totalSteps - 1 ? AppStrings.get('calculate_plan', ref) : AppStrings.get('continue', ref),
            style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required String unit,
    required ValueChanged<double> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.outfit(fontWeight: FontWeight.w800, color: isDark ? AppColors.textWhite : AppColors.textPrimary)),
            Text(
              '${value.round()}$unit',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w900,
                color: AppColors.primaryBlue,
                fontSize: 20,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
          activeColor: AppColors.primaryBlue,
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: onTap,
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: Border.all(
            color: selected ? AppColors.primaryBlue : Colors.transparent,
            width: 2,
          ),
          child: Row(
            children: [
              Icon(icon, color: selected ? AppColors.primaryBlue : (isDark ? Colors.white38 : AppColors.textSecondary)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: isDark ? AppColors.textWhite : AppColors.textPrimary)),
                    Text(subtitle, style: GoogleFonts.outfit(fontSize: 12, color: isDark ? AppColors.textWhiteSecondary : AppColors.textSecondary, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              if (selected) const Icon(Icons.check_circle, color: AppColors.primaryBlue),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceCard({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        border: Border.all(
          color: selected ? AppColors.primaryBlue : Colors.transparent,
          width: 2,
        ),
        child: Column(
          children: [
            Icon(icon, size: 48, color: selected ? AppColors.primaryBlue : (isDark ? Colors.white38 : AppColors.textSecondary)),
            const SizedBox(height: 12),
            Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: isDark ? AppColors.textWhite : AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildObjectiveChip(HydrationObjective obj, String label, IconData icon, bool selected) {
    return GestureDetector(
      onTap: () => ref.read(quizProvider.notifier).setObjective(obj),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBlue : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.primaryBlue : Colors.white12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: selected ? Colors.white : AppColors.textHint, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: selected ? Colors.white : AppColors.textHint,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalculatingOverlay extends ConsumerStatefulWidget {
  final VoidCallback onComplete;
  const _CalculatingOverlay({required this.onComplete});

  @override
  ConsumerState<_CalculatingOverlay> createState() => _CalculatingOverlayState();
}

class _CalculatingOverlayState extends ConsumerState<_CalculatingOverlay> {
  double _progress = 0;
  String _currentStepKey = 'analyzing_biometrics';
  final List<String> _stepKeys = [
    'analyzing_biometrics',
    'calibrating_env',
    'mapping_activity',
    'optimizing_targets',
    'finalizing_plan',
  ];

  @override
  void initState() {
    super.initState();
    _startSimulation();
  }

  void _startSimulation() async {
    for (int i = 0; i <= 100; i += 2) {
      if (!mounted) break;
      setState(() {
        _progress = i / 100;
        _currentStepKey = _stepKeys[(i / 21).floor().clamp(0, 4)];
      });
      await Future.delayed(Duration(milliseconds: 40 + (i % 10 * 10)));
    }
    await Future.delayed(const Duration(milliseconds: 600));
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)).animate().fadeIn(),
          ),
          Center(
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: _progress,
                          strokeWidth: 8,
                          backgroundColor: Colors.white10,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
                        ),
                      ),
                      Text(
                        '${(_progress * 100).toInt()}%',
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                  const SizedBox(height: 48),
                  Text(
                    AppStrings.get('hf_intelligence', ref),
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      letterSpacing: -0.5,
                      color: Colors.white,
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 12),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: Text(
                      AppStrings.get(_currentStepKey, ref),
                      key: ValueKey(_currentStepKey),
                      style: GoogleFonts.outfit(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: 200,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _progress,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [AppColors.primaryBlue, AppColors.secondaryAqua]),
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(color: AppColors.primaryBlue.withOpacity(0.5), blurRadius: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ).animate().slideY(begin: 0.1, duration: 600.ms, curve: Curves.easeOut),
        ],
      ),
    );
  }
}
