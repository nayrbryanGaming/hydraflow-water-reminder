import 'package:uuid/uuid.dart';

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

  factory ReminderModel.fromMap(Map<dynamic, dynamic> data) {
    return ReminderModel(
      reminderId: data['reminderId'] as String? ?? const Uuid().v4(),
      userId: data['userId'] as String? ?? '',
      intervalMinutes: data['intervalMinutes'] as int? ?? 60,
      enabled: data['enabled'] as bool? ?? true,
      startHour: data['startHour'] as int? ?? 7,
      endHour: data['endHour'] as int? ?? 22,
      days: (data['days'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [1, 2, 3, 4, 5, 6, 7],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reminderId': reminderId,
      'userId': userId,
      'intervalMinutes': intervalMinutes,
      'enabled': enabled,
      'startHour': startHour,
      'endHour': endHour,
      'days': days,
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
