package lib.domain.entities;

import 'package:equatable/equatable.dart';

enum SyncState { pending, syncing, synced, conflict, error }
enum SyncOperation { create, update, delete }

enum SyncStatusEnum { pending, synced, conflict }

class SyncStatus extends Equatable {
  final String entityId;
  final String entityType;
  final SyncState state;
  final SyncOperation operation;
  final DateTime? lastSyncAttempt;
  final String? errorMessage;
  final int retryCount;
  final int version;
  final DateTime lastModified;

  const SyncStatus({
    required this.entityId,
    required this.entityType,
    required this.state,
    required this.operation,
    this.lastSyncAttempt,
    this.errorMessage,
    required this.retryCount,
    required this.version,
    required this.lastModified,
  });

  bool get isPending => state == SyncState.pending;
  bool get isSyncing => state == SyncState.syncing;
  bool get isSynced => state == SyncState.synced;
  bool get hasConflict => state == SyncState.conflict;
  bool get hasError => state == SyncState.error;
  bool get canRetry => retryCount < 3 && (hasError || hasConflict);

  SyncStatus copyWith({
    String? entityId,
    String? entityType,
    SyncState? state,
    SyncOperation? operation,
    DateTime? lastSyncAttempt,
    String? errorMessage,
    int? retryCount,
    int? version,
    DateTime? lastModified,
  }) {
    return SyncStatus(
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      state: state ?? this.state,
      operation: operation ?? this.operation,
      lastSyncAttempt: lastSyncAttempt ?? this.lastSyncAttempt,
      errorMessage: errorMessage ?? this.errorMessage,
      retryCount: retryCount ?? this.retryCount,
      version: version ?? this.version,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  SyncStatus startSync() {
    return copyWith(
      state: SyncState.syncing,
      lastSyncAttempt: DateTime.now(),
    );
  }

  SyncStatus markSynced() {
    return copyWith(
      state: SyncState.synced,
      lastSyncAttempt: DateTime.now(),
    );
  }

  SyncStatus markConflict() {
    return copyWith(state: SyncState.conflict);
  }

  SyncStatus markError(String message) {
    return copyWith(
      state: SyncState.error,
      errorMessage: message,
    );
  }

  SyncStatus incrementRetry() {
    return copyWith(retryCount: retryCount + 1);
  }

  static SyncStatus forCreate(String entityId, String entityType) {
    return SyncStatus(
      entityId: entityId,
      entityType: entityType,
      state: SyncState.pending,
      operation: SyncOperation.create,
      retryCount: 0,
      version: 1,
      lastModified: DateTime.now(),
    );
  }

  static SyncStatus forUpdate(String entityId, String entityType, int version) {
    return SyncStatus(
      entityId: entityId,
      entityType: entityType,
      state: SyncState.pending,
      operation: SyncOperation.update,
      retryCount: 0,
      version: version,
      lastModified: DateTime.now(),
    );
  }

  static SyncStatus forDelete(String entityId, String entityType) {
    return SyncStatus(
      entityId: entityId,
      entityType: entityType,
      state: SyncState.pending,
      operation: SyncOperation.delete,
      retryCount: 0,
      version: 0,
      lastModified: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        entityId,
        entityType,
        state,
        operation,
        lastSyncAttempt,
        errorMessage,
        retryCount,
        version,
        lastModified,
      ];
}