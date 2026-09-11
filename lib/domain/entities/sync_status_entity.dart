package field_app.domain.entities;

import 'package:equatable/equatable.dart';

class SyncStatusEntity extends Equatable {
  final String id;
  final String entityId;
  final String entityType;
  final String status;
  final DateTime? lastSyncAttempt;
  final DateTime? lastSuccessfulSync;
  final int retryCount;
  final String? errorMessage;
  final String? errorCode;
  final Map<String, dynamic>? conflictDetails;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SyncStatusEntity({
    required this.id,
    required this.entityId,
    required this.entityType,
    required this.status,
    this.lastSyncAttempt,
    this.lastSuccessfulSync,
    required this.retryCount,
    this.errorMessage,
    this.errorCode,
    this.conflictDetails,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isPending => status == 'pending';
  bool get isSynced => status == 'synced';
  bool get isFailed => status == 'failed';
  bool get hasConflict => status == 'conflict';
  bool get canRetry => retryCount < 3 && (isFailed || isPending);
  bool get isRecoverable => errorCode != 'FATAL';

  Duration? get timeSinceLastAttempt {
    if (lastSyncAttempt == null) return null;
    return DateTime.now().difference(lastSyncAttempt!);
  }

  Duration? get timeSinceLastSuccess {
    if (lastSuccessfulSync == null) return null;
    return DateTime.now().difference(lastSuccessfulSync!);
  }

  SyncStatusEntity copyWith({
    String? id,
    String? entityId,
    String? entityType,
    String? status,
    DateTime? lastSyncAttempt,
    DateTime? lastSuccessfulSync,
    int? retryCount,
    String? errorMessage,
    String? errorCode,
    Map<String, dynamic>? conflictDetails,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SyncStatusEntity(
      id: id ?? this.id,
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      status: status ?? this.status,
      lastSyncAttempt: lastSyncAttempt ?? this.lastSyncAttempt,
      lastSuccessfulSync: lastSuccessfulSync ?? this.lastSuccessfulSync,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
      errorCode: errorCode ?? this.errorCode,
      conflictDetails: conflictDetails ?? this.conflictDetails,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        entityId,
        entityType,
        status,
        lastSyncAttempt,
        lastSuccessfulSync,
        retryCount,
        errorMessage,
        errorCode,
        conflictDetails,
        createdAt,
        updatedAt,
      ];

  @override
  bool get stringify => true;
}