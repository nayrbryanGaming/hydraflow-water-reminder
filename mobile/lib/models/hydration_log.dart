import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../core/constants/firestore_constants.dart';

enum DrinkType {
  water,
  tea,
  coffee,
  juice,
  sports,
  other;

  String get label {
    switch (this) {
      case DrinkType.water:
        return 'Water';
      case DrinkType.tea:
        return 'Tea';
      case DrinkType.coffee:
        return 'Coffee';
      case DrinkType.juice:
        return 'Juice';
      case DrinkType.sports:
        return 'Sports Drink';
      case DrinkType.other:
        return 'Other';
    }
  }

  String get emoji {
    switch (this) {
      case DrinkType.water:
        return '💧';
      case DrinkType.tea:
        return '🍵';
      case DrinkType.coffee:
        return '☕';
      case DrinkType.juice:
        return '🧃';
      case DrinkType.sports:
        return '⚡';
      case DrinkType.other:
        return '🥤';
    }
  }
}

class HydrationLog {
  final String logId;
  final String userId;
  final int amountMl;
  final DateTime timestamp;
  final String? note;
  final DrinkType drinkType;

  HydrationLog({
    String? logId,
    required this.userId,
    required this.amountMl,
    required this.timestamp,
    this.note,
    this.drinkType = DrinkType.water,
  }) : logId = logId ?? const Uuid().v4();

  factory HydrationLog.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HydrationLog(
      logId: data[FirestoreConstants.logId] as String? ?? doc.id,
      userId: data[FirestoreConstants.userId] as String? ?? '',
      amountMl: data[FirestoreConstants.amountMl] as int? ?? 0,
      timestamp:
          (data[FirestoreConstants.timestamp] as Timestamp?)?.toDate() ??
              DateTime.now(),
      note: data[FirestoreConstants.note] as String?,
      drinkType: DrinkType.values.firstWhere(
        (e) => e.name == (data[FirestoreConstants.drinkType] as String?),
        orElse: () => DrinkType.water,
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      FirestoreConstants.logId: logId,
      FirestoreConstants.userId: userId,
      FirestoreConstants.amountMl: amountMl,
      FirestoreConstants.timestamp: Timestamp.fromDate(timestamp),
      FirestoreConstants.note: note,
      FirestoreConstants.drinkType: drinkType.name,
    };
  }

  HydrationLog copyWith({
    String? logId,
    String? userId,
    int? amountMl,
    DateTime? timestamp,
    String? note,
    DrinkType? drinkType,
  }) {
    return HydrationLog(
      logId: logId ?? this.logId,
      userId: userId ?? this.userId,
      amountMl: amountMl ?? this.amountMl,
      timestamp: timestamp ?? this.timestamp,
      note: note ?? this.note,
      drinkType: drinkType ?? this.drinkType,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HydrationLog &&
          runtimeType == other.runtimeType &&
          logId == other.logId;

  @override
  int get hashCode => logId.hashCode;
}

