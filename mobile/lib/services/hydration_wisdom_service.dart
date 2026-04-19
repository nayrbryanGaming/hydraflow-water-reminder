import 'dart:math';

class HydrationWisdom {
  final String title;
  final String content;
  final String category; // 'fact', 'tip', 'benefit'

  HydrationWisdom({
    required this.title,
    required this.content,
    required this.category,
  });
}

class HydrationWisdomService {
  static final List<HydrationWisdom> _wisdomList = [
    HydrationWisdom(
      title: "Brain Power",
      content: "Even 2% dehydration can cause a noticeable decrease in cognitive functions and focus.",
      category: "fact",
    ),
    HydrationWisdom(
      title: "Energy Boost",
      content: "Feeling tired? Water helps maintain blood volume, allowing your heart to pump more efficiently.",
      category: "benefit",
    ),
    HydrationWisdom(
      title: "Glowing Skin",
      content: "Proper hydration increases skin elasticity and reduces appearance of wrinkles.",
      category: "benefit",
    ),
    HydrationWisdom(
      title: "Metabolism Junkie",
      content: "Drinking cold water can slightly boost metabolism as your body spends energy to warm it up.",
      category: "tip",
    ),
    HydrationWisdom(
      title: "Hunger vs Thirst",
      content: "The brain often confuses thirst with hunger. Drink water first when you feel a craving.",
      category: "fact",
    ),
    HydrationWisdom(
      title: "Muscle Function",
      content: "Water balance is crucial for muscle contraction. Dehydration leads to cramping.",
      category: "fact",
    ),
    HydrationWisdom(
      title: "Morning Habit",
      content: "Drink a glass of water immediately after waking up to kickstart your internal organs.",
      category: "tip",
    ),
  ];

  static HydrationWisdom getRandomWisdom() {
    final random = Random();
    return _wisdomList[random.nextInt(_wisdomList.length)];
  }

  static HydrationWisdom getWisdomForProgress(double progress) {
    if (progress < 0.3) {
      return HydrationWisdom(
        title: "Starting Strong",
        content: "Consistency is key. Small sips throughout the day are better than gulping all at once.",
        category: "tip",
      );
    } else if (progress > 0.9) {
      return HydrationWisdom(
        title: "Goal Reached!",
        content: "Great job! Your body is fully hydrated and functioning at its peak potential.",
        category: "benefit",
      );
    }
    return getRandomWisdom();
  }
}

