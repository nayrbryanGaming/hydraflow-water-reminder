import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../core/constants/firestore_constants.dart';

class ReminderModel {
  final String reminderId;
  final String userId;
  final int intervalMinutes;
  final bool enabled;
  final int startHour;
  final int endHour;
  final List<int> days; // 1=Mon, 7=Sun (ISO weekday)

  ReminderModel({
    String? reminderId,
    required this.userId,
    this.intervalMinutes = 60,
    this.enabled = true,
    this.startHour = 7,
    this.endHour = 22,
    List<int>? days,
  })  : reminderId = reminderId ?? const Uuid().v4(),
        days = days ?? [1, 2, 3, 4, 5, 6, 7];

  factory ReminderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReminderModel(
      reminderId: data[FirestoreConstants.reminderId] as String? ?? doc.id,
      userId: data[FirestoreConstants.userId] as String? ?? '',
      intervalMinutes:
          data[FirestoreConstants.intervalMinutes] as int? ?? 60,
      enabled: data[FirestoreConstants.enabled] as bool? ?? true,
      startHour: data[FirestoreConstants.startHour] as int? ?? 7,
      endHour: data[FirestoreConstants.endHour] as int? ?? 22,
      days: (data[FirestoreConstants.days] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [1, 2, 3, 4, 5, 6, 7],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      FirestoreConstants.reminderId: reminderId,
      FirestoreConstants.userId: userId,
      FirestoreConstants.intervalMinutes: intervalMinutes,
      FirestoreConstants.enabled: enabled,
      FirestoreConstants.startHour: startHour,
      FirestoreConstants.endHour: endHour,
      FirestoreConstants.days: days,
    };
  }

  ReminderModel copyWith({
    String? reminderId,
    String? userId,
    int? intervalMinutes,
    bool? enabled,
    int? startHour,
    int? endHour,
    List<int>? days,
  }) {
    return ReminderModel(
      reminderId: reminderId ?? this.reminderId,
      userId: userId ?? this.userId,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      enabled: enabled ?? this.enabled,
      startHour: startHour ?? this.startHour,
      endHour: endHour ?? this.endHour,
      days: days ?? this.days,
    );
  }
}

