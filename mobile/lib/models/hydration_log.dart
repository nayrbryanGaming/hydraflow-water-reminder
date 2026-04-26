enum DrinkType {
  water('Water', '💧'),
  coffee('Coffee', '☕'),
  tea('Tea', '🍵'),
  juice('Juice', '🧃'),
  soda('Soda', '🥤'),
  milk('Milk', '🥛');

  final String label;
  final String emoji;
  const DrinkType(this.label, this.emoji);
}

class HydrationLog {
  final String? logId;
  final String userId;
  final int amountMl;
  final DateTime timestamp;
  final DrinkType drinkType;
  final String? note;

  const HydrationLog({
    this.logId,
    required this.userId,
    required this.amountMl,
    required this.timestamp,
    this.drinkType = DrinkType.water,
    this.note,
  });

  factory HydrationLog.fromMap(Map<dynamic, dynamic> data, String id) {
    return HydrationLog(
      logId: id,
      userId: data['userId'] as String? ?? '',
      amountMl: data['amountMl'] as int? ?? 0,
      timestamp: data['timestamp'] != null ? DateTime.parse(data['timestamp']) : DateTime.now(),
      drinkType: DrinkType.values.firstWhere(
        (e) => e.name == (data['drinkType'] as String?),
        orElse: () => DrinkType.water,
      ),
      note: data['note'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'amountMl': amountMl,
      'timestamp': timestamp.toIso8601String(),
      'drinkType': drinkType.name,
      if (note != null) 'note': note,
    };
  }

  HydrationLog copyWith({
    String? logId,
    String? userId,
    int? amountMl,
    DateTime? timestamp,
    DrinkType? drinkType,
    String? note,
  }) {
    return HydrationLog(
      logId: logId ?? this.logId,
      userId: userId ?? this.userId,
      amountMl: amountMl ?? this.amountMl,
      timestamp: timestamp ?? this.timestamp,
      drinkType: drinkType ?? this.drinkType,
      note: note ?? this.note,
    );
  }
}
