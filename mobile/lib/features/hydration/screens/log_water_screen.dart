import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/hydration_log.dart';
import '../../../services/firestore_service.dart';
import '../../../core/theme/app_colors.dart';

class LogWaterScreen extends ConsumerStatefulWidget {
  const LogWaterScreen({super.key});

  @override
  ConsumerState<LogWaterScreen> createState() => _LogWaterScreenState();
}

class _LogWaterScreenState extends ConsumerState<LogWaterScreen> {
  int _selectedAmount = 250;
  DrinkType _selectedType = DrinkType.water;

  Future<void> _saveLog() async {
    final log = HydrationLog(
      userId: '', // service sets this
      amountMl: _selectedAmount,
      timestamp: DateTime.now(),
      drinkType: _selectedType,
    );
    await ref.read(firestoreServiceProvider).addHydrationLog(log);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Drink')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Select Amount', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: AppConstants.quickAddAmounts.map((amount) {
                  final isSelected = amount == _selectedAmount;
                  return ChoiceChip(
                    label: Text('${amount}ml'),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedAmount = amount);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              Text('Drink Type', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: DrinkType.values.map((type) {
                  final isSelected = type == _selectedType;
                  return ChoiceChip(
                    label: Text('${type.emoji} ${type.label}'),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedType = type);
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
