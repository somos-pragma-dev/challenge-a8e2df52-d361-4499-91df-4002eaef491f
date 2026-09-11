package field_app.data.models;

import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/sync_status_entity.dart';
import '../../core/constants/app_constants.dart';

class SyncStatusModel extends Equatable {
  final String id;
  final String entityType;
  final String entityId;
  final String status;
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSyncAt;
  final int retryCount;
  final String? errorMessage;
  final String? errorCode;
  final Map<String, dynamic>? metadata;

  const SyncStatusModel({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.status,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    this.lastSyncAt,
    this.retryCount = 0,
    this.errorMessage,
    this.errorCode,
    this.metadata,
  });

  factory SyncStatusModel.fromEntity(SyncStatusEntity entity) {
    return SyncStatusModel(
      id: entity.id,
      entityType: entity.entityType,
      entityId: entity.entityId,
      status: entity.status,
      version: entity.version,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      lastSyncAt: entity.lastSyncAt,
      retryCount: entity.retryCount,
      errorMessage: entity.errorMessage,
      errorCode: entity.errorCode,
      metadata: entity.metadata,
    );
  }

  factory SyncStatusModel.fromMap(Map<String, dynamic> map) {
    return SyncStatusModel(
      id: map['id'] as String,
      entityType: map['entity_type'] as String,
      entityId: map['entity_id'] as String,
      status: map['status'] as String,
      version: map['version'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      lastSyncAt: map['last_sync_at'] != null
          ? DateTime.parse(map['last_sync_at'] as String)
          : null,
      retryCount: map['retry_count'] as int? ?? 0,
      errorMessage: map['error_message'] as String?,
      errorCode: map['error_code'] as String?,
      metadata: map['metadata'] != null
          ? jsonDecode(map['metadata'] as String) as Map<String, dynamic>
          : null,
    );
  }

  factory SyncStatusModel.fromJson(Map<String, dynamic> json) {
    return SyncStatusModel(
      id: json['id'] as String,
      entityType: json['entity_type'] as String,
      entityId: json['entity_id'] as String,
      status: json['status'] as String,
      version: json['version'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastSyncAt: json['last_sync_at'] != null
          ? DateTime.parse(json['last_sync_at'] as String)
          : null,
      retryCount: json['retry_count'] as int? ?? 0,
      errorMessage: json['error_message'] as String?,
      errorCode: json['error_code'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  factory SyncStatusModel.create({
    required String entityType,
    required String entityId,
    Map<String, dynamic>? metadata,
  }) {
    final now = DateTime.now();
    return SyncStatusModel(
      id: const Uuid().v4(),
      entityType: entityType,
      entityId: entityId,
      status: AppConstants.syncStatusPending,
      version: 1,
      createdAt: now,
      updatedAt: now,
      lastSyncAt: null,
      retryCount: 0,
      errorMessage: null,
      errorCode: null,
      metadata: metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'entity_type': entityType,
      'entity_id': entityId,
      'status': status,
      'version': version,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'last_sync_at': lastSyncAt?.toIso8601String(),
      'retry_count': retryCount,
      'error_message': errorMessage,
      'error_code': errorCode,
      'metadata': metadata != null ? jsonEncode(metadata) : null,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entity_type': entityType,
      'entity_id': entityId,
      'status': status,
      'version': version,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'last_sync_at': lastSyncAt?.toIso8601String(),
      'retry_count': retryCount,
      'error_message': errorMessage,
      'error_code': errorCode,
      'metadata': metadata,
    };
  }

  SyncStatusEntity toEntity() {
    return SyncStatusEntity(
      id: id,
      entityType: entityType,
      entityId: entityId,
      status: status,
      version: version,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastSyncAt: lastSyncAt,
      retryCount: retryCount,
      errorMessage: errorMessage,
      errorCode: errorCode,
      metadata: metadata,
    );
  }

  SyncStatusModel copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? status,
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncAt,
    int? retryCount,
    String? errorMessage,
    String? errorCode,
    Map<String, dynamic>? metadata,
  }) {
    return SyncStatusModel(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      status: status ?? this.status,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
      errorCode: errorCode ?? this.errorCode,
      metadata: metadata ?? this.metadata,
    );
  }

  SyncStatusModel markAsSynced() {
    return copyWith(
      status: AppConstants.syncStatusSynced,
      updatedAt: DateTime.now(),
      lastSyncAt: DateTime.now(),
      retryCount: 0,
      errorMessage: null,
      errorCode: null,
    );
  }

  SyncStatusModel markAsFailed({String? errorMessage, String? errorCode}) {
    return copyWith(
      status: AppConstants.syncStatusFailed,
      updatedAt: DateTime.now(),
      retryCount: retryCount + 1,
      errorMessage: errorMessage,
      errorCode: errorCode,
    );
  }

  SyncStatusModel markAsConflict() {
    return copyWith(
      status: AppConstants.syncStatusConflict,
      updatedAt: DateTime.now(),
    );
  }

  SyncStatusModel incrementVersion() {
    return copyWith(
      version: version + 1,
      updatedAt: DateTime.now(),
    );
  }

  SyncStatusModel resetRetry() {
    return copyWith(
      retryCount: 0,
      errorMessage: null,
      errorCode: null,
    );
  }

  bool get isPending => status == AppConstants.syncStatusPending;
  bool get isSynced => status == AppConstants.syncStatusSynced;
  bool get isFailed => status == AppConstants.syncStatusFailed;
  bool get isConflict => status == AppConstants.syncStatusConflict;
  bool get canRetry => retryCount < AppConstants.maxRetryAttempts;
  bool get hasError => errorMessage != null;

  @override
  List<Object?> get props => [
        id,
        entityType,
        entityId,
        status,
        version,
        createdAt,
        updatedAt,
        lastSyncAt,
        retryCount,
        errorMessage,
        errorCode,
        metadata,
      ];
}