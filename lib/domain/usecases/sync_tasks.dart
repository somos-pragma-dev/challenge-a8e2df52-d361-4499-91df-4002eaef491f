package field_app.domain.usecases;

import 'package:equatable/equatable.dart';
import 'package:field_app/core/errors/failures.dart';
import 'package:field_app/core/network/network_info.dart';
import 'package:field_app/domain/entities/task_entity.dart';
import 'package:field_app/domain/repositories/task_repository.dart';
import 'package:field_app/domain/repositories/sync_repository.dart';

class SyncTasksParams extends Equatable {
  final bool forceFullSync;
  final int? batchSize;
  final bool resolveConflictsAutomatically;

  const SyncTasksParams({
    this.forceFullSync = false,
    this.batchSize,
    this.resolveConflictsAutomatically = false,
  });

  @override
  List<Object?> get props => [forceFullSync, batchSize, resolveConflictsAutomatically];
}

class SyncTasksResult extends Equatable {
  final int syncedCount;
  final int failedCount;
  final int conflictCount;
  final Duration duration;
  final List<String> errorMessages;

  const SyncTasksResult({
    required this.syncedCount,
    required this.failedCount,
    required this.conflictCount,
    required this.duration,
    this.errorMessages = const [],
  });

  bool get hasConflicts => conflictCount > 0;
  bool get hasErrors => failedCount > 0;
  bool get isPartialSuccess => syncedCount > 0 && (failedCount > 0 || conflictCount > 0);
  bool get isFullSuccess => syncedCount > 0 && failedCount == 0 && conflictCount == 0;

  @override
  List<Object?> get props => [syncedCount, failedCount, conflictCount, duration, errorMessages];
}

abstract class SyncTasks {
  Future<({SyncTasksResult result, Failure? failure})> call(SyncTasksParams params);
}

class SyncTasksImpl implements SyncTasks {
  final TaskRepository taskRepository;
  final SyncRepository syncRepository;
  final NetworkInfo networkInfo;

  static const int defaultBatchSize = 50;
  static const int maxRetryAttempts = 3;

  SyncTasksImpl({
    required this.taskRepository,
    required this.syncRepository,
    required this.networkInfo,
  });

  @override
  Future<({SyncTasksResult result, Failure? failure})> call(SyncTasksParams params) async {
    final stopwatch = Stopwatch()..start();
    
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      stopwatch.stop();
      return (
        result: SyncTasksResult(
          syncedCount: 0,
          failedCount: 0,
          conflictCount: 0,
          duration: stopwatch.elapsed,
          errorMessages: ['No network connection available'],
        ),
        failure: const NetworkFailure(
          message: 'No network connection available for sync',
          isConnectionError: true,
          isTimeout: false,
        ),
      );
    }

    try {
      final pendingTasks = await taskRepository.getPendingSyncTasks();
      
      if (pendingTasks.isEmpty) {
        stopwatch.stop();
        return (
          result: SyncTasksResult(
            syncedCount: 0,
            failedCount: 0,
            conflictCount: 0,
            duration: stopwatch.elapsed,
            errorMessages: [],
          ),
          failure: null,
        );
      }

      final batchSize = params.batchSize ?? defaultBatchSize;
      final batches = _createBatches(pendingTasks, batchSize);
      
      int syncedCount = 0;
      int failedCount = 0;
      int conflictCount = 0;
      final List<String> errorMessages = [];

      for (final batch in batches) {
        final batchResult = await _processBatch(
          batch,
          params.resolveConflictsAutomatically,
        );
        
        syncedCount += batchResult.synced;
        failedCount += batchResult.failed;
        conflictCount += batchResult.conflicts;
        errorMessages.addAll(batchResult.errors);
      }

      stopwatch.stop();
      
      await syncRepository.recordSyncOperation(
        entityType: 'tasks',
        totalCount: pendingTasks.length,
        successCount: syncedCount,
        failedCount: failedCount,
        conflictCount: conflictCount,
      );

      return (
        result: SyncTasksResult(
          syncedCount: syncedCount,
          failedCount: failedCount,
          conflictCount: conflictCount,
          duration: stopwatch.elapsed,
          errorMessages: errorMessages,
        ),
        failure: failedCount > 0 || conflictCount > 0
            ? SyncFailure(
                message: 'Sync completed with errors',
                retryCount: failedCount,
              )
            : null,
      );
    } catch (e) {
      stopwatch.stop();
      return (
        result: SyncTasksResult(
          syncedCount: 0,
          failedCount: 0,
          conflictCount: 0,
          duration: stopwatch.elapsed,
          errorMessages: [e.toString()],
        ),
        failure: SyncFailure(
          message: 'Sync operation failed: ${e.toString()}',
          retryCount: 0,
        ),
      );
    }
  }

  List<List<TaskEntity>> _createBatches(List<TaskEntity> tasks, int batchSize) {
    final batches = <List<TaskEntity>>[];
    for (var i = 0; i < tasks.length; i += batchSize) {
      final end = (i + batchSize < tasks.length) ? i + batchSize : tasks.length;
      batches.add(tasks.sublist(i, end));
    }
    return batches;
  }

  Future<({int synced, int failed, int conflicts, List<String> errors})> _processBatch(
    List<TaskEntity> batch,
    bool resolveAutomatically,
  ) async {
    int synced = 0;
    int failed = 0;
    int conflicts = 0;
    final errors = <String>[];

    for (final task in batch) {
      try {
        final syncResult = await taskRepository.syncTask(task);
        
        if (syncResult.isConflict) {
          conflicts++;
          if (resolveAutomatically) {
            await _autoResolveConflict(task, syncResult);
          } else {
            await taskRepository.markTaskAsConflict(task.id);
          }
        } else if (syncResult.isSuccess) {
          synced++;
        } else {
          failed++;
          errors.add('Failed to sync task ${task.id}: ${syncResult.errorMessage}');
        }
      } catch (e) {
        failed++;
        errors.add('Exception syncing task ${task.id}: $e');
      }
    }

    return (synced: synced, failed: failed, conflicts: conflicts, errors: errors);
  }

  Future<void> _autoResolveConflict(TaskEntity task, SyncResult result) async {
    final resolutionStrategy = result.serverVersion != null 
        ? ConflictResolutionStrategy.serverWins 
        : ConflictResolutionStrategy.keepLocal;
    
    await taskRepository.resolveConflict(
      taskId: task.id,
      resolution: resolutionStrategy,
      winningVersion: resolutionStrategy == ConflictResolutionStrategy.serverWins
          ? result.serverVersion
          : task,
    );
  }
}

enum ConflictResolutionStrategy {
  serverWins,
  clientWins,
  keepLocal,
  merge,
}

class SyncResult {
  final bool isSuccess;
  final bool isConflict;
  final String? errorMessage;
  final TaskEntity? serverVersion;

  const SyncResult({
    required this.isSuccess,
    this.isConflict = false,
    this.errorMessage,
    this.serverVersion,
  });
}