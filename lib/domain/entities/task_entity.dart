package field_app.domain.entities;

import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String priority;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? assignedTo;
  final DateTime? dueDate;
  final String syncStatus;
  final int version;
  final Map<String, dynamic>? metadata;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.assignedTo,
    this.dueDate,
    required this.syncStatus,
    required this.version,
    this.metadata,
  });

  bool get isPendingSync => syncStatus == 'pending';
  bool get isSynced => syncStatus == 'synced';
  bool get hasFailed => syncStatus == 'failed';
  bool get hasConflict => syncStatus == 'conflict';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get isInProgress => status == 'in_progress';
  bool get isPending => status == 'pending';

  bool get isHighPriority => priority == 'high';
  bool get isMediumPriority => priority == 'medium';
  bool get isLowPriority => priority == 'low';

  bool get isOverdue {
    if (dueDate == null) return false;
    return DateTime.now().isAfter(dueDate!) && !isCompleted && !isCancelled;
  }

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? priority,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? assignedTo,
    DateTime? dueDate,
    String? syncStatus,
    int? version,
    Map<String, dynamic>? metadata,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      assignedTo: assignedTo ?? this.assignedTo,
      dueDate: dueDate ?? this.dueDate,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        priority,
        status,
        createdAt,
        updatedAt,
        assignedTo,
        dueDate,
        syncStatus,
        version,
        metadata,
      ];

  @override
  bool get stringify => true;
}