import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/auth_service.dart';
import '../../../services/auth_google_service.dart';
import '../../../widgets/glass_card.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your email and password', style: GoogleFonts.outfit()),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();
    try {
      await ref.read(authServiceProvider).signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', ''), style: GoogleFonts.outfit()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isGoogleLoading = true);
    HapticFeedback.mediumImpact();
    try {
      await ref.read(googleAuthServiceProvider).signInWithGoogle();
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google Sign-In failed. Please try again.', style: GoogleFonts.outfit()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () => context.go('/onboarding'),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 24),
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildEmailForm(),
                    const SizedBox(height: 16),
                    _buildForgotPassword(),
                    const SizedBox(height: 32),
                    _buildSignInButton(),
                    const SizedBox(height: 24),
                    _buildDivider(),
                    const SizedBox(height: 24),
                    _buildGoogleSignInButton(),
                    const SizedBox(height: 32),
                    _buildRegisterLink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back',
          style: GoogleFonts.outfit(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.5,
          ),
        ).animate().fadeIn().slideX(begin: -0.1),
        const SizedBox(height: 8),
        Text(
          'Sign in to continue your hydration journey.',
          style: GoogleFonts.outfit(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  Widget _buildEmailForm() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.outfit(),
            decoration: InputDecoration(
              labelText: 'Email Address',
              labelStyle: GoogleFonts.outfit(color: AppColors.textSecondary),
              prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primaryBlue, size: 20),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: GoogleFonts.outfit(),
            onSubmitted: (_) => _signIn(),
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: GoogleFonts.outfit(color: AppColors.textSecondary),
              prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primaryBlue, size: 20),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: AppColors.textHint,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1);
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () async {
          final email = _emailController.text.trim();
          if (email.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Enter your email address above first.', style: GoogleFonts.outfit()),
                backgroundColor: AppColors.error,
              ),
            );
            return;
          }
          try {
            await ref.read(authServiceProvider).sendPasswordResetEmail(email);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Password reset email sent to $email', style: GoogleFonts.outfit()),
                  backgroundColor: AppColors.accentMint,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Could not send reset email. Please try again.', style: GoogleFonts.outfit()),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          }
        },
        child: Text('Forgot Password?', style: GoogleFonts.outfit(color: AppColors.primaryBlue, fontWeight: FontWeight.w600)),
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildSignInButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _signIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          shadowColor: AppColors.primaryBlue.withOpacity(0.4),
        ),
        child: _isLoading
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
            : Text('Sign In', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('OR CONTINUE WITH', style: GoogleFonts.outfit(color: AppColors.textHint, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        ),
        const Expanded(child: Divider()),
      ],
    ).animate().fadeIn(delay: 700.ms);
  }

  Widget _buildGoogleSignInButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton(
        onPressed: _isGoogleLoading ? null : _signInWithGoogle,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          foregroundColor: AppColors.primaryBlue,
        ),
        child: _isGoogleLoading
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 3))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google 'G' icon rendered via text for universal compatibility
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Colors.white),
                    child: const Center(
                      child: Text('G', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4285F4), fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('Sign in with Google', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
      ),
    ).animate().fadeIn(delay: 800.ms);
  }

  Widget _buildRegisterLink() {
    return Center(
      child: TextButton(
        onPressed: () => context.go('/register'),
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.outfit(color: AppColors.textSecondary),
            children: [
              const TextSpan(text: "Don't have an account? "),
              TextSpan(text: 'Create One', style: GoogleFonts.outfit(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 900.ms);
  }
}

