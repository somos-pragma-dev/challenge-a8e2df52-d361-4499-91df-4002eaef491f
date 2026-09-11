package lib.data.repositories;

import 'package:field_app/data/datasources/local/task_local_datasource.dart';
import 'package:field_app/data/datasources/remote/task_remote_datasource.dart';
import 'package:field_app/domain/repositories/sync_repository.dart';
import 'package:field_app/domain/entities/task_entity.dart';
import 'package:field_app/core/network/network_info.dart';
import 'package:uuid/uuid.dart';
import 'package:either_dart/either.dart';
import 'package:field_app/core/errors/failures.dart';

class SyncRepositoryImpl implements SyncRepository {
  final TaskLocalDataSource localDataSource;
  final TaskRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final Uuid uuid;

  SyncRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
    required this.uuid,
  });

  @override
  Future<Either<Failure, void>> syncPendingTasks() async {
    try {
      await syncAll();
      return const Right(null);
    } catch (e) {
      return Left(SyncFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SyncResult>> syncAllData() async {
    try {
      final result = await syncAll();
      return Right(result);
    } catch (e) {
      return Left(SyncFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ConflictResolutionResult>> resolveConflict(
    String entityId,
    ConflictResolutionStrategy strategy,
  ) async {
    return const Right(ConflictResolutionResult(
      success: true,
      entityId: '',
      usedStrategy: ConflictResolutionStrategy.values,
    ));
  }

  @override
  Future<Either<Failure, List<SyncStatusSummary>>> getSyncStatusSummary() async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, void>> retryFailedSync(String entityId) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> cancelSync(String syncId) async {
    return const Right(null);
  }

  @override
  Stream<SyncProgress> get syncProgressStream => const Stream.empty();

  @override
  Future<void> recordSyncOperation({
    required String entityType,
    required int totalCount,
    required int successCount,
    required int failedCount,
    required int conflictCount,
  }) async {
    // Record sync operation in local database
    final status = SyncStatusModel.create(
      id: uuid.v4(),
      entityType: entityType,
      entityId: uuid.v4(),
      status: failedCount > 0 ? 'failed' : (conflictCount > 0 ? 'conflict' : 'synced'),
      version: 1,
    );
    await localDataSource.saveSyncStatus(status);
  }

  Future<SyncResult> syncAll() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return const SyncResult(
        totalSynced: 0,
        totalFailed: 0,
        totalConflicts: 0,
        syncDuration: Duration.zero,
      );
    }

    final pendingTasks = await localDataSource.getPendingSyncTasks();
    if (pendingTasks.isEmpty) {
      return const SyncResult(
        totalSynced: 0,
        totalFailed: 0,
        totalConflicts: 0,
        syncDuration: Duration.zero,
      );
    }

    int synced = 0;
    int failed = 0;
    int conflicts = 0;

    for (final task in pendingTasks) {
      try {
        await remoteDataSource.updateTask(task);
        await localDataSource.markTaskAsSynced(task.id);
        synced++;
      } catch (e) {
        failed++;
      }
    }

    return SyncResult(
      totalSynced: synced,
      totalFailed: failed,
      totalConflicts: conflicts,
      syncDuration: Duration.zero,
    );
  }

  Future<SyncResult> syncTask(String taskId) async {
    return syncAll();
  }

  Future<List<TaskEntity>> getPendingSyncItems() async {
    final tasks = await localDataSource.getPendingSyncTasks();
    return tasks.map((m) => m.toEntity()).toList();
  }

  Future<DateTime?> getLastSyncTime() async {
    return null;
  }

  Future<void> clearSyncQueue() async {
    // Implementation
  }
}

class SyncConflict extends Equatable {
  final String taskId;
  final TaskEntity localVersion;
  final TaskEntity? remoteVersion;
  final String conflictType;

  const SyncConflict({
    required this.taskId,
    required this.localVersion,
    this.remoteVersion,
    required this.conflictType,
  });

  @override
  List<Object?> get props => [taskId, localVersion, remoteVersion, conflictType];
}