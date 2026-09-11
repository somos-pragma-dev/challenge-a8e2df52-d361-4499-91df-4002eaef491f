package lib.data.models;

import 'package:lib/core/constants/app_constants.dart';
import 'package:lib/domain/entities/sync_record.dart';

class SyncRecordModel {
  final String id;
  final String entityId;
  final String entityType;
  final String operationType;
  final String? payload;
  final String? payloadHash;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime? syncedAt;
  final int retryCount;
  final String? errorMessage;
  final String? conflictData;
  final int version;

  SyncRecordModel({
    required this.id,
    required this.entityId,
    required this.entityType,
    required this.operationType,
    this.payload,
    this.payloadHash,
    required this.syncStatus,
    required this.createdAt,
    this.syncedAt,
    required this.retryCount,
    this.errorMessage,
    this.conflictData,
    required this.version,
  });

  factory SyncRecordModel.fromJson(Map<String, dynamic> json) {
    return SyncRecordModel(
      id: json[DatabaseColumns.id] as String,
      entityId: json[DatabaseColumns.uuid] as String,
      entityType: json['entity_type'] as String,
      operationType: json[DatabaseColumns.operationType] as String,
      payload: json['payload'] as String?,
      payloadHash: json[DatabaseColumns.hash] as String?,
      syncStatus: json[DatabaseColumns.syncStatus] as String,
      createdAt: DateTime.parse(json[DatabaseColumns.createdAt] as String),
      syncedAt: json['synced_at'] != null
          ? DateTime.parse(json['synced_at'] as String)
          : null,
      retryCount: json['retry_count'] as int? ?? 0,
      errorMessage: json['error_message'] as String?,
      conflictData: json[DatabaseColumns.conflictData] as String?,
      version: json[DatabaseColumns.version] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      DatabaseColumns.id: id,
      DatabaseColumns.uuid: entityId,
      'entity_type': entityType,
      DatabaseColumns.operationType: operationType,
      'payload': payload,
      DatabaseColumns.hash: payloadHash,
      DatabaseColumns.syncStatus: syncStatus,
      DatabaseColumns.createdAt: createdAt.toIso8601String(),
      'synced_at': syncedAt?.toIso8601String(),
      'retry_count': retryCount,
      'error_message': errorMessage,
      DatabaseColumns.conflictData: conflictData,
      DatabaseColumns.version: version,
    };
  }

  Map<String, dynamic> toMap() {
    return toJson();
  }

  factory SyncRecordModel.fromMap(Map<String, dynamic> map) {
    return SyncRecordModel.fromJson(map);
  }

  SyncRecord toEntity() {
    return SyncRecord(
      id: id,
      entityId: entityId,
      entityType: entityType,
      operationType: operationType,
      payload: payload,
      payloadHash: payloadHash,
      syncStatus: syncStatus,
      createdAt: createdAt,
      syncedAt: syncedAt,
      retryCount: retryCount,
      errorMessage: errorMessage,
      conflictData: conflictData != null ? _parseConflictData(conflictData!) : null,
      version: version,
    );
  }

  factory SyncRecordModel.fromEntity(SyncRecord entity) {
    return SyncRecordModel(
      id: entity.id,
      entityId: entity.entityId,
      entityType: entity.entityType,
      operationType: entity.operationType,
      payload: entity.payload,
      payloadHash: entity.payloadHash,
      syncStatus: entity.syncStatus,
      createdAt: entity.createdAt,
      syncedAt: entity.syncedAt,
      retryCount: entity.retryCount,
      errorMessage: entity.errorMessage,
      conflictData: entity.conflictData != null ? _encodeConflictData(entity.conflictData!) : null,
      version: entity.version,
    );
  }

  static Map<String, dynamic>? _parseConflictData(String data) {
    try {
      final parts = data.split('|');
      if (parts.length >= 3) {
        return {
          'local_version': parts[0],
          'server_version': parts[1],
          'local_data': parts[2],
          'server_data': parts.length > 3 ? parts[3] : '',
        };
      }
    } catch (_) {}
    return null;
  }

  static String? _encodeConflictData(Map<String, dynamic>? data) {
    if (data == null) return null;
    return '${data['local_version']}|${data['server_version']}|${data['local_data']}|${data['server_data']}';
  }

  SyncRecordModel copyWith({
    String? id,
    String? entityId,
    String? entityType,
    String? operationType,
    String? payload,
    String? payloadHash,
    String? syncStatus,
    DateTime? createdAt,
    DateTime? syncedAt,
    int? retryCount,
    String? errorMessage,
    String? conflictData,
    int? version,
  }) {
    return SyncRecordModel(
      id: id ?? this.id,
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      operationType: operationType ?? this.operationType,
      payload: payload ?? this.payload,
      payloadHash: payloadHash ?? this.payloadHash,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
      conflictData: conflictData ?? this.conflictData,
      version: version ?? this.version,
    );
  }

  bool get isPending => syncStatus == AppConstants.syncStatusPending;
  bool get isInProgress => syncStatus == AppConstants.syncStatusInProgress;
  bool get isCompleted => syncStatus == AppConstants.syncStatusCompleted;
  bool get isFailed => syncStatus == AppConstants.syncStatusFailed;
  bool get isConflict => syncStatus == AppConstants.syncStatusConflict;

  @override
  String toString() {
    return 'SyncRecordModel(id: $id, entityId: $entityId, operation: $operationType, status: $syncStatus)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SyncRecordModel &&
        other.id == id &&
        other.entityId == entityId &&
        other.operationType == operationType &&
        other.syncStatus == syncStatus;
  }

  @override
  int get hashCode {
    return Object.hash(id, entityId, operationType, syncStatus);
  }
}