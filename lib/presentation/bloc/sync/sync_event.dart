import 'package:equatable/equatable.dart';

abstract class SyncEvent extends Equatable {
  const SyncEvent();

  @override
  List<Object?> get props => [];
}

class ConnectionChangedEvent extends SyncEvent {
  final bool isConnected;
  final String? connectionType;

  const ConnectionChangedEvent({
    required this.isConnected,
    this.connectionType,
  });

  @override
  List<Object?> get props => [isConnected, connectionType];
}

class SyncRequestedEvent extends SyncEvent {
  final bool forceFullSync;

  const SyncRequestedEvent({
    this.forceFullSync = false,
  });

  @override
  List<Object?> get props => [forceFullSync];
}

class SyncStartedEvent extends SyncEvent {
  final int pendingItemsCount;

  const SyncStartedEvent({
    required this.pendingItemsCount,
  });

  @override
  List<Object?> get props => [pendingItemsCount];
}

class SyncProgressEvent extends SyncEvent {
  final int processedItems;
  final int totalItems;
  final String? currentItemId;

  const SyncProgressEvent({
    required this.processedItems,
    required this.totalItems,
    this.currentItemId,
  });

  double get progressPercentage =>
      totalItems > 0 ? (processedItems / totalItems) * 100 : 0;

  @override
  List<Object?> get props => [processedItems, totalItems, currentItemId];
}

class SyncCompletedEvent extends SyncEvent {
  final int syncedItemsCount;
  final Duration syncDuration;
  final List<String>? conflictIds;

  const SyncCompletedEvent({
    required this.syncedItemsCount,
    required this.syncDuration,
    this.conflictIds,
  });

  @override
  List<Object?> get props => [syncedItemsCount, syncDuration, conflictIds];
}

class SyncFailedEvent extends SyncEvent {
  final String errorMessage;
  final String? errorCode;
  final int retryCount;
  final bool canRetry;

  const SyncFailedEvent({
    required this.errorMessage,
    this.errorCode,
    this.retryCount = 0,
    this.canRetry = true,
  });

  @override
  List<Object?> get props => [errorMessage, errorCode, retryCount, canRetry];
}

class ConflictDetectedEvent extends SyncEvent {
  final String entityId;
  final String entityType;
  final dynamic localVersion;
  final dynamic remoteVersion;
  final String conflictType;

  const ConflictDetectedEvent({
    required this.entityId,
    required this.entityType,
    required this.localVersion,
    required this.remoteVersion,
    required this.conflictType,
  });

  @override
  List<Object?> get props =>
      [entityId, entityType, localVersion, remoteVersion, conflictType];
}

class ConflictResolvedEvent extends SyncEvent {
  final String entityId;
  final String resolutionStrategy;
  final dynamic resolvedVersion;

  const ConflictResolvedEvent({
    required this.entityId,
    required this.resolutionStrategy,
    required this.resolvedVersion,
  });

  @override
  List<Object?> get props => [entityId, resolutionStrategy, resolvedVersion];
}

class SyncStatusCheckEvent extends SyncEvent {
  const SyncStatusCheckEvent();
}

class RetrySyncEvent extends SyncEvent {
  const RetrySyncEvent();
}