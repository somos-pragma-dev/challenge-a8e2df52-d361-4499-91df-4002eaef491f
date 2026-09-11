import 'package:equatable/equatable.dart';
import '../../../domain/entities/sync_status_entity.dart';

abstract class SyncState extends Equatable {
  final bool isConnected;
  final String? connectionType;
  final DateTime? lastSyncTime;
  final int pendingChangesCount;

  const SyncState({
    required this.isConnected,
    this.connectionType,
    this.lastSyncTime,
    this.pendingChangesCount = 0,
  });

  @override
  List<Object?> get props => [
        isConnected,
        connectionType,
        lastSyncTime,
        pendingChangesCount,
      ];
}

class SyncInitial extends SyncState {
  const SyncInitial()
      : super(
          isConnected: false,
          pendingChangesCount: 0,
        );
}

class SyncOffline extends SyncState {
  const SyncOffline({
    super.lastSyncTime,
    super.pendingChangesCount,
  }) : super(isConnected: false, connectionType: null);

  @override
  List<Object?> get props => [
        ...super.props,
        'offline',
      ];
}

class SyncOnline extends SyncState {
  const SyncOnline({
    super.connectionType,
    super.lastSyncTime,
    super.pendingChangesCount,
  }) : super(isConnected: true);

  bool get hasPendingChanges => pendingChangesCount > 0;

  @override
  List<Object?> get props => [
        ...super.props,
        'online',
      ];
}

class SyncInProgress extends SyncState {
  final int totalItems;
  final int processedItems;
  final String? currentItemId;
  final String? currentOperation;
  final DateTime startTime;

  const SyncInProgress({
    required super.isConnected,
    super.connectionType,
    required this.totalItems,
    required this.processedItems,
    this.currentItemId,
    this.currentOperation,
    required this.startTime,
    super.lastSyncTime,
    super.pendingChangesCount,
  });

  double get progressPercentage =>
      totalItems > 0 ? (processedItems / totalItems) * 100 : 0;

  Duration get elapsedTime => DateTime.now().difference(startTime);

  @override
  List<Object?> get props => [
        ...super.props,
        totalItems,
        processedItems,
        currentItemId,
        currentOperation,
        startTime,
      ];
}

class SyncCompleted extends SyncState {
  final int syncedItemsCount;
  final Duration syncDuration;
  final List<String>? conflictIds;
  final bool hasConflicts;

  const SyncCompleted({
    required this.syncedItemsCount,
    required this.syncDuration,
    this.conflictIds,
    super.lastSyncTime,
    super.pendingChangesCount = 0,
  })  : hasConflicts = conflictIds != null && conflictIds.isNotEmpty,
        super(isConnected: true);

  @override
  List<Object?> get props => [
        ...super.props,
        syncedItemsCount,
        syncDuration,
        conflictIds,
        hasConflicts,
      ];
}

class SyncFailure extends SyncState {
  final String errorMessage;
  final String? errorCode;
  final int retryCount;
  final bool canRetry;
  final List<SyncStatusEntity>? failedItems;

  const SyncFailure({
    required this.errorMessage,
    this.errorCode,
    this.retryCount = 0,
    this.canRetry = true,
    this.failedItems,
    super.isConnected,
    super.connectionType,
    super.lastSyncTime,
    super.pendingChangesCount,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        errorMessage,
        errorCode,
        retryCount,
        canRetry,
        failedItems,
      ];
}

class SyncConflict extends SyncState {
  final String entityId;
  final String entityType;
  final dynamic localVersion;
  final dynamic remoteVersion;
  final String conflictType;
  final List<SyncStatusEntity> pendingSyncItems;

  const SyncConflict({
    required this.entityId,
    required this.entityType,
    required this.localVersion,
    required this.remoteVersion,
    required this.conflictType,
    required this.pendingSyncItems,
    super.isConnected,
    super.connectionType,
    super.lastSyncTime,
    super.pendingChangesCount,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        entityId,
        entityType,
        localVersion,
        remoteVersion,
        conflictType,
        pendingSyncItems,
      ];
}

class SyncWaitingForRetry extends SyncState {
  final DateTime? nextRetryAt;
  final int currentRetryCount;
  final String lastError;

  const SyncWaitingForRetry({
    this.nextRetryAt,
    this.currentRetryCount = 0,
    required this.lastError,
    super.isConnected,
    super.connectionType,
    super.lastSyncTime,
    super.pendingChangesCount,
  });

  Duration? get timeUntilRetry =>
      nextRetryAt != null ? nextRetryAt!.difference(DateTime.now()) : null;

  bool get canRetryNow =>
      nextRetryAt == null || DateTime.now().isAfter(nextRetryAt!);

  @override
  List<Object?> get props => [
        ...super.props,
        nextRetryAt,
        currentRetryCount,
        lastError,
      ];
}