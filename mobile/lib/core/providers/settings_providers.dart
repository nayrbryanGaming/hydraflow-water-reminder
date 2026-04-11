import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final unitPreferenceProvider = StateProvider<bool>((ref) {
  final box = Hive.box('hydraflow_prefs');
  final isMetric = box.get('isMetric', defaultValue: true) as bool;
  
  // Update Hive when state changes
  ref.listenSelf((previous, next) {
    box.put('isMetric', next);
  });

  return isMetric;
});
