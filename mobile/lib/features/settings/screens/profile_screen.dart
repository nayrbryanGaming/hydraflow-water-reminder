import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/local_db_service.dart';
import '../../../services/auth_service.dart';
import '../../../models/user_model.dart';
import '../../../widgets/glass_card.dart';
import '../../../core/utils/hydration_calculator.dart';
import '../../../core/localization/app_strings.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _weightController;
  late TextEditingController _ageController;
  int _dailyGoal = 2000;
  bool _isHotClimate = false;
  String _activityLevel = 'moderate';
  String _objective = 'general';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _weightController = TextEditingController();
    _ageController = TextEditingController();
    
    Future.microtask(_loadUserData);
  }

  void _loadUserData() async {
    final userProfile = await ref.read(localDbServiceProvider).getUserProfile().first;
    if (userProfile != null) {
      setState(() {
        _nameController.text = userProfile.displayName;
        _weightController.text = userProfile.weightKg.toInt().toString();
        _ageController.text = userProfile.age.toString();
        _dailyGoal = userProfile.dailyWaterGoalMl;
        _isHotClimate = userProfile.isHotClimate;
        _activityLevel = userProfile.activityLevel;
        _objective = userProfile.hydrationObjective;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _recalculateGoal() {
    final weight = double.tryParse(_weightController.text) ?? 70.0;
    final age = int.tryParse(_ageController.text) ?? 25;
    
    ActivityLevel act;
    if (_activityLevel == 'active') act = ActivityLevel.active;
    else if (_activityLevel == 'sedentary') act = ActivityLevel.sedentary;
    else act = ActivityLevel.moderate;

    HydrationObjective obj;
    if (_objective == 'cognitive') obj = HydrationObjective.cognitive;
    else if (_objective == 'energy') obj = HydrationObjective.energy;
    else if (_objective == 'skin') obj = HydrationObjective.skin;
    else obj = HydrationObjective.general;

    final newGoal = HydrationCalculator.calculateDailyGoal(
      weight,
      age: age,
      activityLevel: act,
      isHotClimate: _isHotClimate,
      objective: obj,
    );

    setState(() => _dailyGoal = newGoal);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final currentProfile = await ref.read(localDbServiceProvider).getUserProfile().first;
      if (currentProfile != null) {
        final updatedUser = currentProfile.copyWith(
          displayName: _nameController.text,
          weightKg: double.parse(_weightController.text),
          age: int.parse(_ageController.text),
          dailyWaterGoalMl: _dailyGoal,
          isHotClimate: _isHotClimate,
          activityLevel: _activityLevel,
          hydrationObjective: _objective,
          updatedAt: DateTime.now(),
        );

        await ref.read(localDbServiceProvider).updateUserProfile(updatedUser);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppStrings.get('profile_updated', ref)), backgroundColor: Colors.green),
          );
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppStrings.get('error_saving_profile', ref)}: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get('edit_profile', ref), style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
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
          child: _nameController.text.isEmpty 
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(AppStrings.get('basic_info', ref)),
                        GlassCard(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              _buildTextField(
                                controller: _nameController,
                                label: AppStrings.get('display_name', ref),
                                icon: Icons.person_outline,
                                validator: (v) => v!.isEmpty ? AppStrings.get('enter_name', ref) : null,
                                isDark: isDark,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                      controller: _ageController,
                                      label: AppStrings.get('age', ref),
                                      icon: Icons.calendar_today_outlined,
                                      keyboardType: TextInputType.number,
                                      onChanged: (_) => _recalculateGoal(),
                                      isDark: isDark,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildTextField(
                                      controller: _weightController,
                                      label: AppStrings.get('weight_kg', ref),
                                      icon: Icons.monitor_weight_outlined,
                                      keyboardType: TextInputType.number,
                                      onChanged: (_) => _recalculateGoal(),
                                      isDark: isDark,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        _buildSectionHeader(AppStrings.get('lifestyle_env', ref)),
                        GlassCard(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              _buildDropdownTile(
                                label: AppStrings.get('activity_level', ref),
                                icon: Icons.directions_run_outlined,
                                value: _activityLevel,
                                items: [
                                  DropdownMenuItem(value: 'sedentary', child: Text(AppStrings.get('sedentary', ref))),
                                  DropdownMenuItem(value: 'moderate', child: Text(AppStrings.get('moderate', ref))),
                                  DropdownMenuItem(value: 'active', child: Text(AppStrings.get('active_lvl', ref))),
                                ],
                                onChanged: (v) {
                                  setState(() => _activityLevel = v!);
                                  _recalculateGoal();
                                },
                              ),
                              const Divider(height: 32),
                              SwitchListTile(
                                title: Text(AppStrings.get('hot_humid_climate', ref), style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w900, color: isDark ? AppColors.textWhite : AppColors.textPrimary)),
                                subtitle: Text(AppStrings.get('hot_humid_desc', ref), style: TextStyle(fontSize: 12, color: isDark ? AppColors.textWhiteSecondary : AppColors.textSecondary, fontWeight: FontWeight.w500)),
                                secondary: const Icon(Icons.wb_sunny_outlined, color: Colors.orange),
                                value: _isHotClimate,
                                activeColor: AppColors.primaryBlue,
                                onChanged: (v) {
                                  setState(() => _isHotClimate = v);
                                  _recalculateGoal();
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                        _buildSectionHeader(AppStrings.get('calculated_daily_goal', ref)),
                        GlassCard(
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$_dailyGoal',
                                style: GoogleFonts.outfit(fontSize: 48, fontWeight: FontWeight.w900, color: AppColors.primaryBlue),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                AppStrings.get('ml_per_day', ref),
                                style: GoogleFonts.outfit(fontSize: 18, color: isDark ? AppColors.textWhiteSecondary : AppColors.textSecondary, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 48),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: _isSaving 
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(AppStrings.get('save_profile_changes', ref), style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900)),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: isDark ? AppColors.textWhiteSecondary : AppColors.textSecondary,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
    required bool isDark,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      style: GoogleFonts.outfit(color: isDark ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.outfit(color: isDark ? AppColors.textWhiteSecondary : AppColors.textSecondary, fontWeight: FontWeight.w500),
        prefixIcon: Icon(icon, color: AppColors.primaryBlue, size: 20),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        fillColor: Colors.white.withOpacity(0.02),
        filled: true,
      ),
    );
  }

  Widget _buildDropdownTile({
    required String label,
    required IconData icon,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryBlue, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: isDark ? AppColors.textWhiteSecondary : AppColors.textSecondary, fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: value,
                isExpanded: true,
                underline: const SizedBox(),
                items: items,
                onChanged: onChanged,
                dropdownColor: isDark ? AppColors.backgroundDark : Colors.white,
                style: GoogleFonts.outfit(color: isDark ? AppColors.textWhite : AppColors.textPrimary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
