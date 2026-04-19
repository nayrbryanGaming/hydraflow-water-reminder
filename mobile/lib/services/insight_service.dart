import 'dart:math';

class InsightService {
  InsightService._();
  static final InsightService instance = InsightService._();

  final List<String> _insights = [
    "Drinking water can boost your metabolic rate by up to 30% for over an hour.",
    "The brain is about 75% water. Even mild dehydration can impair cognitive focus.",
    "Drinking a glass of water before meals can help with weight management and digestion.",
    "Water helps maintain skin elasticity and can reduce the appearance of fine lines.",
    "Chronic dehydration is a common cause of midday fatigue and afternoon slumps.",
    "Proper hydration helps your kidneys flush out waste products more efficiently.",
    "Staying hydrated helps regulate body temperature during exercise and hot weather.",
    "Water is essential for the production of lymph, a fluid that carries immune cells.",
    "Even 2% dehydration can lead to a significant drop in athletic and mental performance.",
    "Drinking water helps prevent headaches caused by muscle tension and dehydration.",
  ];

  String getRandomInsight() {
    final random = Random();
    return _insights[random.nextInt(_insights.length)];
  }

  /// Returns an insight tailored to a specific objective
  String getObjectiveInsight(String objective) {
    switch (objective.toLowerCase()) {
      case 'cognitive':
        return "75% of your brain is water. Stay hydrated to maintain peak mental clarity.";
      case 'energy':
        return "Fatigue is often the first sign of dehydration. Drink up to power through.";
      case 'skin':
        return "Hydration is the ultimate beauty secret. It keeps your skin supple and glowing.";
      default:
        return getRandomInsight();
    }
  }
}

