import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/hydration_log.dart';
import '../../../services/firestore_service.dart';
import '../../../core/providers/settings_providers.dart';
import '../../../core/utils/hydration_calculator.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/glass_card.dart';

class LogWaterScreen extends ConsumerStatefulWidget {
  const LogWaterScreen({super.key});

  @override
  ConsumerState<LogWaterScreen> createState() => _LogWaterScreenState();
}

class _LogWaterScreenState extends ConsumerState<LogWaterScreen> {
  int _amount = 250;
  DrinkType _selectedType = DrinkType.water;
  bool _isLoading = false;
  bool _showSuccessAnimation = false;

  final List<int> _quickPresets = [100, 250, 500, 750];

  Future<void> _submitLog() async {
    setState(() => _isLoading = true);
    
    // Differentiated Haptics based on volume
    if (_amount >= 750) {
      await HapticFeedback.vibrate(); // Heavy pattern for large volume
    } else if (_amount >= 500) {
      await HapticFeedback.heavyImpact();
    } else if (_amount >= 250) {
      await HapticFeedback.mediumImpact();
    } else {
      await HapticFeedback.lightImpact();
    }

    try {
      final firestore = ref.read(firestoreServiceProvider);
      await firestore.addHydrationLog(
        HydrationLog(
          userId: ref.read(authServiceProvider).currentUser?.uid ?? '',
          amountMl: _amount,
          timestamp: DateTime.now(),
          drinkType: _selectedType,
        ),
      );
      
      setState(() {
        _isLoading = false;
        _showSuccessAnimation = true;
      });

      // Wait for animation
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _buildSuccessAnimation() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background ambient glow
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  AppColors.primaryBlue.withOpacity(0.15),
                  Colors.black,
                ],
              ),
            ),
          ).animate().fadeIn(duration: 1.seconds),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Procedural Success Checkmark with glowing ring
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.success.withOpacity(0.2), width: 2),
                    ),
                  ).animate().scale(duration: 800.ms, curve: Curves.easeOut).fadeOut(delay: 500.ms),
                  
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.success, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.success.withOpacity(0.3),
                          blurRadius: 40,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.check_rounded, color: AppColors.success, size: 85),
                  ).animate()
                   .scale(duration: 600.ms, curve: Curves.elasticOut)
                   .shimmer(delay: 500.ms, duration: 2.seconds),
                ],
              ),
              
              // Lottie Water Splash (High Fidelity Event)
              Animate(
                effects: [FadeEffect(delay: 400.ms)],
                child: Lottie.network(
                  'https://assets2.lottiefiles.com/packages/lf20_5njp9vzv.json',
                  height: 180,
                  repeat: false,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(height: 180),
                ),
              ),
              
              const SizedBox(height: 12),
              
              Text(
                'Hydration Logged!',
                style: GoogleFonts.outfit(
                  fontSize: 32, 
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
              
              const SizedBox(height: 8),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
                ),
                child: Text(
                  '+${HydrationCalculator.formatMl(_amount, isMetric: ref.watch(unitPreferenceProvider))} recorded',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryAqua,
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms).scale(delay: 500.ms, curve: Curves.easeOutBack),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showSuccessAnimation) {
      return _buildSuccessAnimation();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Add Water', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Animated Liquid Fill Container (Visual Background)
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white10,
                            border: Border.all(color: Colors.white12, width: 2),
                          ),
                          child: ClipOval(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: AnimatedContainer(
                                duration: 300.ms,
                                width: 200,
                                height: 200 * (_amount / 1000).clamp(0.0, 1.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      AppColors.secondaryAqua.withOpacity(0.4),
                                      AppColors.primaryBlue.withOpacity(0.6),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ).animate(target: _amount.toDouble()).shake(hz: 2, curve: Curves.easeInOut),
                        
                        GlassCard(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _selectedType.emoji,
                                style: const TextStyle(fontSize: 64),
                              ).animate(target: _amount.toDouble()).scale(begin: const Offset(1,1), end: const Offset(1.1, 1.1), duration: 200.ms),
                              const SizedBox(height: 16),
                              Text(
                                HydrationCalculator.formatMl(_amount, isMetric: ref.read(unitPreferenceProvider)),
                                style: GoogleFonts.outfit(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                _selectedType.label.toUpperCase(),
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color: AppColors.secondaryAqua,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Slider with custom theme
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: AppColors.secondaryAqua,
                    inactiveTrackColor: Colors.white12,
                    thumbColor: Colors.white,
                    overlayColor: AppColors.secondaryAqua.withOpacity(0.2),
                    trackHeight: 12,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 18),
                  ),
                  child: Slider(
                    value: _amount.toDouble(),
                    min: 50,
                    max: 1000,
                    divisions: 19,
                    onChanged: (value) {
                      setState(() => _amount = value.toInt());
                      if (_amount % 100 == 0) HapticFeedback.mediumImpact();
                      else HapticFeedback.selectionClick();
                    },
                  ),
                ).animate().slideY(begin: 0.5),
                const SizedBox(height: 24),
                // Quick presets
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _quickPresets.map((preset) {
                    final isSelected = _amount == preset;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _amount = preset);
                        HapticFeedback.lightImpact();
                      },
                      child: AnimatedContainer(
                        duration: 200.ms,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryBlue : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isSelected ? Colors.white30 : Colors.transparent),
                        ),
                        child: Text(
                          HydrationCalculator.formatMl(preset, isMetric: ref.watch(unitPreferenceProvider)),
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ).animate().slideY(begin: 0.5, delay: 100.ms),
                const SizedBox(height: 32),
                // Drink types list
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: DrinkType.values.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final type = DrinkType.values[index];
                      final isSelected = type == _selectedType;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedType = type),
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: 300.ms,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? AppColors.secondaryAqua : Colors.white10,
                                border: Border.all(color: isSelected ? Colors.white : Colors.transparent, width: 2),
                              ),
                              child: Text(type.emoji, style: const TextStyle(fontSize: 24)),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              type.label,
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? Colors.white : AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ).animate().slideY(begin: 0.5, delay: 200.ms),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitLog,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      elevation: 8,
                      shadowColor: AppColors.primaryBlue.withOpacity(0.5),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            'SAVE LOG',
                            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                  ),
                ).animate().slideY(begin: 0.5, delay: 300.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

