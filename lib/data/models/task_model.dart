package field_app.data.models;

import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/task_entity.dart';
import '../../core/constants/app_constants.dart';

class TaskModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String priority;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? assignedTo;
  final String? location;
  final String syncStatus;
  final int version;
  final bool isDeleted;
  final Map<String, dynamic>? metadata;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.assignedTo,
    this.location,
    required this.syncStatus,
    required this.version,
    this.isDeleted = false,
    this.metadata,
  });

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      priority: entity.priority,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      assignedTo: entity.assignedTo,
      location: entity.location,
      syncStatus: entity.syncStatus,
      version: entity.version,
      isDeleted: entity.isDeleted,
      metadata: entity.metadata,
    );
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      priority: map['priority'] as String,
      status: map['status'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      assignedTo: map['assigned_to'] as String?,
      location: map['location'] as String?,
      syncStatus: map['sync_status'] as String,
      version: map['version'] as int,
      isDeleted: (map['is_deleted'] as int) == 1,
      metadata: map['metadata'] != null
          ? jsonDecode(map['metadata'] as String) as Map<String, dynamic>
          : null,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      priority: json['priority'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      assignedTo: json['assigned_to'] as String?,
      location: json['location'] as String?,
      syncStatus: json['sync_status'] as String? ?? AppConstants.syncStatusPending,
      version: json['version'] as int? ?? 1,
      isDeleted: json['is_deleted'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  factory TaskModel.create({
    required String title,
    required String description,
    required String priority,
    String? assignedTo,
    String? location,
    Map<String, dynamic>? metadata,
  }) {
    final now = DateTime.now();
    return TaskModel(
      id: const Uuid().v4(),
      title: title,
      description: description,
      priority: priority,
      status: AppConstants.taskStatusPending,
      createdAt: now,
      updatedAt: now,
      assignedTo: assignedTo,
      location: location,
      syncStatus: AppConstants.syncStatusPending,
      version: 1,
      isDeleted: false,
      metadata: metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'assigned_to': assignedTo,
      'location': location,
      'sync_status': syncStatus,
      'version': version,
      'is_deleted': isDeleted ? 1 : 0,
      'metadata': metadata != null ? jsonEncode(metadata) : null,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'assigned_to': assignedTo,
      'location': location,
      'sync_status': syncStatus,
      'version': version,
      'is_deleted': isDeleted,
      'metadata': metadata,
    };
  }

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      priority: priority,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      assignedTo: assignedTo,
      location: location,
      syncStatus: syncStatus,
      version: version,
      isDeleted: isDeleted,
      metadata: metadata,
    );
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? priority,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? assignedTo,
    String? location,
    String? syncStatus,
    int? version,
    bool? isDeleted,
    Map<String, dynamic>? metadata,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      assignedTo: assignedTo ?? this.assignedTo,
      location: location ?? this.location,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
      metadata: metadata ?? this.metadata,
    );
  }

  TaskModel incrementVersion() {
    return copyWith(version: version + 1);
  }

  TaskModel markForDeletion() {
    return copyWith(
      isDeleted: true,
      updatedAt: DateTime.now(),
      syncStatus: AppConstants.syncStatusPending,
    );
  }

  TaskModel markSynced() {
    return copyWith(syncStatus: AppConstants.syncStatusSynced);
  }

  TaskModel markFailed() {
    return copyWith(syncStatus: AppConstants.syncStatusFailed);
  }

  TaskModel markConflict() {
    return copyWith(syncStatus: AppConstants.syncStatusConflict);
  }

  bool get isPendingSync => syncStatus == AppConstants.syncStatusPending;
  bool get isSynced => syncStatus == AppConstants.syncStatusSynced;
  bool get hasFailed => syncStatus == AppConstants.syncStatusFailed;
  bool get hasConflict => syncStatus == AppConstants.syncStatusConflict;

  bool get isValidTitle => title.isNotEmpty && title.length <= AppConstants.maxTitleLength;
  bool get isValidDescription => description.length <= AppConstants.maxDescriptionLength;
  bool get isValidPriority => [AppConstants.taskPriorityLow, AppConstants.taskPriorityMedium, AppConstants.taskPriorityHigh].contains(priority);
  bool get isValidStatus => [AppConstants.taskStatusPending, AppConstants.taskStatusInProgress, AppConstants.taskStatusCompleted, AppConstants.taskStatusCancelled].contains(status);

  bool get isValid => isValidTitle && isValidDescription && isValidPriority && isValidStatus;

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
        location,
        syncStatus,
        version,
        isDeleted,
        metadata,
      ];
}