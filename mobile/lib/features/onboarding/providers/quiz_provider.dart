import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/hydration_calculator.dart';

class QuizState {
  final double weightKg;
  final int age;
  final ActivityLevel activityLevel;
  final bool isHotClimate;
  final HydrationObjective objective;

  QuizState({
    this.weightKg = 70,
    this.age = 25,
    this.activityLevel = ActivityLevel.moderate,
    this.isHotClimate = false,
    this.objective = HydrationObjective.general,
  });

  QuizState copyWith({
    double? weightKg,
    int? age,
    ActivityLevel? activityLevel,
    bool? isHotClimate,
    HydrationObjective? objective,
  }) {
    return QuizState(
      weightKg: weightKg ?? this.weightKg,
      age: age ?? this.age,
      activityLevel: activityLevel ?? this.activityLevel,
      isHotClimate: isHotClimate ?? this.isHotClimate,
      objective: objective ?? this.objective,
    );
  }

  int get calculatedGoal => HydrationCalculator.calculateDailyGoal(
        weightKg,
        age: age,
        activityLevel: activityLevel,
        isHotClimate: isHotClimate,
        objective: objective,
      );
}

class QuizNotifier extends StateNotifier<QuizState> {
  QuizNotifier() : super(QuizState());

  void setWeight(double weight) => state = state.copyWith(weightKg: weight);
  void setAge(int age) => state = state.copyWith(age: age);
  void setActivity(ActivityLevel level) => state = state.copyWith(activityLevel: level);
  void setClimate(bool isHot) => state = state.copyWith(isHotClimate: isHot);
  void setObjective(HydrationObjective obj) => state = state.copyWith(objective: obj);
}

final quizProvider = StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  return QuizNotifier();
});

