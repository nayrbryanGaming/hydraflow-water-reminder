import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/hydration_calculator.dart';
import '../../../services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../onboarding/providers/quiz_provider.dart';
import '../../../widgets/glass_card.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _agreedToTerms = false;

  Future<void> _register() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || 
        _passwordController.text.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text('Please complete your profile', style: GoogleFonts.outfit()),
           backgroundColor: AppColors.error,
         ),
       );
       return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please agree to the Terms & Privacy Policy', style: GoogleFonts.outfit()),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final quizData = ref.read(quizProvider);
    setState(() => _isLoading = true);
    
    try {
      await ref.read(authServiceProvider).registerWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
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
            content: Text(e.toString(), style: GoogleFonts.outfit()),
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
                    const SizedBox(height: 24),
                    _buildSubmitButton(),
                    const SizedBox(height: 24),
                    _buildLoginLink(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Join HydraFlow',
          style: GoogleFonts.outfit(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
        ).animate().fadeIn().slideX(begin: -0.1),
        const SizedBox(height: 8),
        Text(
          'Create an account to sync your hydration progress across all your devices.',
          style: GoogleFonts.outfit(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.5,
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
            label: 'Full Name',
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _emailController,
            label: 'Email Address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _passwordController,
            label: 'Password',
            icon: Icons.lock_outline_rounded,
            obscureText: true,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildTermsCheckbox() {
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
            child: Wrap(
              children: [
                Text('I agree into ', style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textSecondary)),
                GestureDetector(
                  onTap: () => context.push(routeLegal, extra: {
                    'fileName': 'terms_of_service.md',
                    'title': 'Terms of Service',
                  }),
                  child: Text('Terms of Service', style: GoogleFonts.outfit(fontSize: 13, color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                ),
                Text(' & ', style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textSecondary)),
                GestureDetector(
                  onTap: () => context.push(routeLegal, extra: {
                    'fileName': 'privacy_policy.md',
                    'title': 'Privacy Policy',
                  }),
                  child: Text('Privacy Policy', style: GoogleFonts.outfit(fontSize: 13, color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                ),
              ],
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
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: GoogleFonts.outfit(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.outfit(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.primaryBlue, size: 20),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _register,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                'Create My Account',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
              ),
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildLoginLink() {
    return Center(
      child: TextButton(
        onPressed: () => context.go(routeLogin),
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.outfit(color: AppColors.textSecondary),
            children: [
              const TextSpan(text: 'Already have an account? '),
              TextSpan(
                text: 'Log In',
                style: GoogleFonts.outfit(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 800.ms);
  }
}


