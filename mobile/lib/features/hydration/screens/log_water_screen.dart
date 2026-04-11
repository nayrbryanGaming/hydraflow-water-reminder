import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/hydration_log.dart';
import '../../../services/firestore_service.dart';
import '../../../widgets/wave_widget.dart';
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

  final List<int> _quickPresets = [100, 250, 500, 750];

  Future<void> _submitLog() async {
    setState(() => _isLoading = true);
    HapticFeedback.heavyImpact(); // Premium feel

    try {
      final firestore = ref.read(firestoreServiceProvider);
      await firestore.addHydrationLog(
        HydrationLog(
          userId: '',
          amountMl: _amount,
          timestamp: DateTime.now(),
          drinkType: _selectedType,
        ),
      );
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
                    },
                  );
                }).toList(),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _saveLog,
                child: const Text('Save Record'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
