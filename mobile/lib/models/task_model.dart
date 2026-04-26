import 'package:uuid/uuid.dart';

enum TaskPriority {
  low,
  medium,
  high;

  String get label {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }

  String get emoji {
    switch (this) {
      case TaskPriority.low:
        return '🟢';
      case TaskPriority.medium:
        return '🟡';
      case TaskPriority.high:
        return '🔴';
    }
  }
}

enum TaskStatus {
  pending,
  inProgress,
  completed;

  String get label {
    switch (this) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
    }
  }
}

class TaskModel {
  final String taskId;
  final String userId;
  final String title;
  final String description;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime? deadline;
  final DateTime createdAt;

  TaskModel({
    String? taskId,
    required this.userId,
    required this.title,
    this.description = '',
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending,
    this.deadline,
    DateTime? createdAt,
  })  : taskId = taskId ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  factory TaskModel.fromMap(Map<dynamic, dynamic> data) {
    return TaskModel(
      taskId: data['taskId'] as String? ?? const Uuid().v4(),
      userId: data['userId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == (data['priority'] as String?),
        orElse: () => TaskPriority.medium,
      ),
      status: TaskStatus.values.firstWhere(
        (e) => e.name == (data['status'] as String?),
        orElse: () => TaskStatus.pending,
      ),
      deadline: data['deadline'] != null ? DateTime.parse(data['deadline']) : null,
      createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'userId': userId,
      'title': title,
      'description': description,
      'priority': priority.name,
      'status': status.name,
      'deadline': deadline?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  TaskModel copyWith({
    String? taskId,
    String? userId,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? deadline,
    DateTime? createdAt,
  }) {
    return TaskModel(
      taskId: taskId ?? this.taskId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModel &&
          runtimeType == other.runtimeType &&
          taskId == other.taskId;

  @override
  int get hashCode => taskId.hashCode;
}
