import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_colors.dart';

class HealthDisclaimer extends StatelessWidget {
  final VoidCallback onAccept;

  const HealthDisclaimer({super.key, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Icon(Icons.info_outline_rounded, size: 48, color: AppColors.primaryBlue),
          const SizedBox(height: 16),
          Text(
            'Health Disclaimer',
            style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'HydraFlow is a hydration tracking tool and is NOT a medical device. '
            'The daily targets and recommendations provided are general estimates based on your input '
            'and should not replace professional medical advice.\n\n'
            'Always consult with a healthcare professional before making significant changes to your '
            'hydration or dietary habits, especially if you have underlying health conditions.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], height: 1.5),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAccept,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                backgroundColor: AppColors.primaryBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text(
                'I UNDERSTAND & AGREE',
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

