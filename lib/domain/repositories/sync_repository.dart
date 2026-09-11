library;

import 'package:equatable/equatable.dart';
import '../../domain/entities/sync_record.dart';

abstract class SyncRepository {
  Future<SyncRecord> createSyncRecord(SyncRecord record);
  Future<SyncRecord> updateSyncRecord(SyncRecord record);
  Future<void> deleteSyncRecord(String id);
  Future<SyncRecord?> getSyncRecordById(String id);
  Future<List<SyncRecord>> getAllSyncRecords();
  Future<List<SyncRecord>> getSyncRecordsByStatus(String status);
  Future<List<SyncRecord>> getPendingSyncRecords();
  Future<List<SyncRecord>> getFailedSyncRecords();
  Future<List<SyncRecord>> getCompletedSyncRecords();
  Future<void> markAsPending(String id);
  Future<void> markAsInProgress(String id);
  Future<void> markAsCompleted(String id, {String? externalId});
  Future<void> markAsFailed(String id, String errorDetails);
  Future<void> markAsConflict(String id, String conflictData);
  Future<int> getPendingCount();
  Future<int> getFailedCount();
  Future<int> getCompletedCount();
  Future<void> clearCompletedRecords({DateTime? before});
  Future<void> clearFailedRecords({DateTime? before});
  Future<void> retryFailedRecords();
  Future<void> cancelPendingSync();
  Stream<List<SyncRecord>> watchSyncRecords();
  Stream<List<SyncRecord>> watchPendingSyncRecords();
  Future<Map<String, dynamic>> getSyncStatistics();
  Future<void> updateRetryCount(String id);
  Future<int> getRetryCount(String id);
  Future<void> scheduleSync(String entityType, String entityId, String operationType);
  Future<List<SyncRecord>> getSyncRecordsForEntity(String entityType, String entityId);
  Future<void> removeSyncRecordsForEntity(String entityType, String entityId);
  Future<void> updateConflictResolution(String id, String resolution, String resolvedData);
  Future<SyncRecord?> getLatestSyncRecordForEntity(String entityType, String entityId);
  Future<List<SyncRecord>> getSyncRecordsByOperationType(String operationType);
  Future<void> bulkUpdateStatus(List<String> ids, String status);
  Future<List<SyncRecord>> getConflictedRecords();
  Future<void> resolveConflict(String id, String resolution, String resolvedData);
  Future<void> cancelSync(String id);
  Future<void> pauseSync(String id);
  Future<void> resumeSync(String id);
  Future<void> prioritizeSync(String id);
  Future<void> deprioritizeSync(String id);
  Future<SyncRecord> saveSyncRecord(SyncRecord record);
}

class SyncBatchResult extends Equatable {
  final int totalRequested;
  final int successfullySynced;
  final int failed;
  final int pending;
  final Duration elapsedTime;
  final List<String> failedIds;
  final List<String> pendingIds;

  const SyncBatchResult({
    required this.totalRequested,
    required this.successfullySynced,
    required this.failed,
    required this.pending,
    required this.elapsedTime,
    this.failedIds = const [],
    this.pendingIds = const [],
  });

  bool get isFullySuccessful => failed == 0 && pending == 0;
  bool get hasFailures => failed > 0;
  bool get hasPending => pending > 0;
  double get successRate => totalRequested > 0 ? successfullySynced / totalRequested : 0.0;

  @override
  List<Object?> get props => [
        totalRequested,
        successfullySynced,
        failed,
        pending,
        elapsedTime,
        failedIds,
        pendingIds,
      ];
}

class SyncConfiguration extends Equatable {
  final int maxRetries;
  final int retryDelaySeconds;
  final int batchSize;
  final bool autoSync;
  final bool syncOnWifiOnly;
  final bool syncOnCharging;
  final String conflictStrategy;
  final Duration syncInterval;
  final Duration maxSyncDuration;

  const SyncConfiguration({
    this.maxRetries = 3,
    this.retryDelaySeconds = 5,
    this.batchSize = 50,
    this.autoSync = true,
    this.syncOnWifiOnly = false,
    this.syncOnCharging = false,
    this.conflictStrategy = 'last_write_wins',
    this.syncInterval = const Duration(minutes: 15),
    this.maxSyncDuration = const Duration(minutes: 5),
  });

  SyncConfiguration copyWith({
    int? maxRetries,
    int? retryDelaySeconds,
    int? batchSize,
    bool? autoSync,
    bool? syncOnWifiOnly,
    bool? syncOnCharging,
    String? conflictStrategy,
    Duration? syncInterval,
    Duration? maxSyncDuration,
  }) {
    return SyncConfiguration(
      maxRetries: maxRetries ?? this.maxRetries,
      retryDelaySeconds: retryDelaySeconds ?? this.retryDelaySeconds,
      batchSize: batchSize ?? this.batchSize,
      autoSync: autoSync ?? this.autoSync,
      syncOnWifiOnly: syncOnWifiOnly ?? this.syncOnWifiOnly,
      syncOnCharging: syncOnCharging ?? this.syncOnCharging,
      conflictStrategy: conflictStrategy ?? this.conflictStrategy,
      syncInterval: syncInterval ?? this.syncInterval,
      maxSyncDuration: maxSyncDuration ?? this.maxSyncDuration,
    );
  }

  @override
  List<Object?> get props => [
        maxRetries,
        retryDelaySeconds,
        batchSize,
        autoSync,
        syncOnWifiOnly,
        syncOnCharging,
        conflictStrategy,
        syncInterval,
        maxSyncDuration,
      ];
}