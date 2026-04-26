import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/router/app_router.dart';
import '../../../services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../onboarding/providers/quiz_provider.dart';
import '../../../widgets/glass_card.dart';
import '../../../core/localization/app_strings.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text(AppStrings.get('enter_name', ref), style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
           backgroundColor: AppColors.error,
         ),
       );
       return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.get('agreement_quiz', ref), style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final quizData = ref.read(quizProvider);
    setState(() => _isLoading = true);
    
    try {
      await ref.read(authServiceProvider).registerLocally(
        email: _emailController.text.trim(),
        displayName: _nameController.text.trim(),
        weightKg: quizData.weightKg,
        dailyGoalMl: quizData.calculatedGoal,
        age: quizData.age,
        hydrationObjective: quizData.objective.name,
        activityLevel: quizData.activityLevel.name,
        isHotClimate: quizData.isHotClimate,
      );
      if (mounted) context.go(routeHome);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString(), style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 24),
                    _buildHeader(),
                    const SizedBox(height: 48),
                    _buildForm(),
                    const SizedBox(height: 8),
                    _buildTermsCheckbox(),
                    const SizedBox(height: 40),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.get('almost_there', ref),
          style: GoogleFonts.outfit(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.5,
            color: isDark ? AppColors.textWhite : AppColors.textPrimary,
          ),
        ).animate().fadeIn().slideX(begin: -0.1),
        const SizedBox(height: 12),
        Text(
          AppStrings.get('complete_profile_desc', ref),
          style: GoogleFonts.outfit(
            fontSize: 16,
            color: isDark ? AppColors.textWhiteSecondary : AppColors.textSecondary,
            height: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  Widget _buildForm() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildTextField(
            controller: _nameController,
            label: AppStrings.get('display_name', ref),
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _emailController,
            label: 'Email (Local Only)',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildTermsCheckbox() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Checkbox(
            value: _agreedToTerms,
            onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
            activeColor: AppColors.primaryBlue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.outfit(
                  fontSize: 13, 
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textWhiteSecondary : AppColors.textSecondary,
                ),
                children: [
                  TextSpan(text: AppStrings.get('agree_terms_start', ref)),
                  TextSpan(
                    text: AppStrings.get('agree_terms_mid', ref),
                    style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w900),
                  ),
                  const TextSpan(text: ' & '),
                  TextSpan(
                    text: AppStrings.get('agree_terms_end', ref),
                    style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: GoogleFonts.outfit(
        color: isDark ? AppColors.textWhite : AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.outfit(
          color: isDark ? AppColors.textWhiteSecondary : AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(icon, color: AppColors.primaryBlue, size: 20),
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _register,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 8,
          shadowColor: AppColors.primaryBlue.withOpacity(0.4),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
              )
            : Text(
                AppStrings.get('finalize_setup', ref).toUpperCase(),
                style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1),
              ),
      ),
    ).animate().fadeIn(delay: 600.ms).scale(curve: Curves.easeOutBack);
  }
}
