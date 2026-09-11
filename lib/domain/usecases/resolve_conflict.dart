package field_app.domain.usecases;

import 'package:equatable/equatable.dart';
import 'package:field_app/core/errors/failures.dart';
import 'package:field_app/domain/entities/task_entity.dart';
import 'package:field_app/domain/repositories/task_repository.dart';

enum ResolutionStrategy {
  useLocal,
  useServer,
  merge,
  lastWriteWins,
}

class ResolveConflictParams extends Equatable {
  final String taskId;
  final ResolutionStrategy strategy;
  final TaskEntity? mergedData;

  const ResolveConflictParams({
    required this.taskId,
    required this.strategy,
    this.mergedData,
  });

  @override
  List<Object?> get props => [taskId, strategy, mergedData];
}

class ConflictData extends Equatable {
  final String taskId;
  final TaskEntity localVersion;
  final TaskEntity serverVersion;
  final DateTime localModifiedAt;
  final DateTime serverModifiedAt;
  final List<String> conflictingFields;

  const ConflictData({
    required this.taskId,
    required this.localVersion,
    required this.serverVersion,
    required this.localModifiedAt,
    required this.serverModifiedAt,
    required this.conflictingFields,
  });

  Duration get timeDifference => localModifiedAt.difference(serverModifiedAt);
  bool get localIsNewer => localModifiedAt.isAfter(serverModifiedAt);
  bool get serverIsNewer => serverModifiedAt.isAfter(localModifiedAt);

  @override
  List<Object?> get props => [
        taskId,
        localVersion,
        serverVersion,
        localModifiedAt,
        serverModifiedAt,
        conflictingFields,
      ];
}

class ResolveConflictResult extends Equatable {
  final bool success;
  final TaskEntity? resolvedTask;
  final String? errorMessage;
  final ResolutionStrategy appliedStrategy;

  const ResolveConflictResult({
    required this.success,
    this.resolvedTask,
    this.errorMessage,
    required this.appliedStrategy,
  });

  @override
  List<Object?> get props => [success, resolvedTask, errorMessage, appliedStrategy];
}

abstract class ResolveConflict {
  Future<({ResolveConflictResult result, Failure? failure})> call(ResolveConflictParams params);
  Future<ConflictData?> getConflictData(String taskId);
  Future<List<ConflictData>> getAllConflicts();
}

class ResolveConflictImpl implements ResolveConflict {
  final TaskRepository taskRepository;

  ResolveConflictImpl({required this.taskRepository});

  @override
  Future<({ResolveConflictResult result, Failure? failure})> call(ResolveConflictParams params) async {
    if (params.taskId.isEmpty) {
      return (
        result: ResolveConflictResult(
          success: false,
          errorMessage: 'Task ID cannot be empty',
          appliedStrategy: params.strategy,
        ),
        failure: const ValidationFailure(
          message: 'Invalid task ID for conflict resolution',
          fieldErrors: {'taskId': ['Task ID is required']},
        ),
      );
    }

    try {
      final conflictData = await getConflictData(params.taskId);
      
      if (conflictData == null) {
        return (
          result: ResolveConflictResult(
            success: false,
            errorMessage: 'No conflict found for task ${params.taskId}',
            appliedStrategy: params.strategy,
          ),
          failure: ConflictFailure(
            entityId: params.taskId,
            localVersion: null,
            remoteVersion: null,
            conflictType: 'not_found',
          ),
        );
      }

      TaskEntity resolvedTask;
      
      switch (params.strategy) {
        case ResolutionStrategy.useLocal:
          resolvedTask = await _resolveWithLocal(conflictData);
          break;
        case ResolutionStrategy.useServer:
          resolvedTask = await _resolveWithServer(conflictData);
          break;
        case ResolutionStrategy.merge:
          resolvedTask = await _resolveWithMerge(conflictData, params.mergedData);
          break;
        case ResolutionStrategy.lastWriteWins:
          resolvedTask = await _resolveWithLastWriteWins(conflictData);
          break;
      }

      await taskRepository.updateTask(resolvedTask);
      await taskRepository.markTaskAsSynced(resolvedTask.id);

      return (
        result: ResolveConflictResult(
          success: true,
          resolvedTask: resolvedTask,
          appliedStrategy: params.strategy,
        ),
        failure: null,
      );
    } catch (e) {
      return (
        result: ResolveConflictResult(
          success: false,
          errorMessage: 'Failed to resolve conflict: ${e.toString()}',
          appliedStrategy: params.strategy,
        ),
        failure: ConflictFailure(
          entityId: params.taskId,
          localVersion: null,
          remoteVersion: null,
          conflictType: 'resolution_failed',
        ),
      );
    }
  }

  @override
  Future<ConflictData?> getConflictData(String taskId) async {
    final localTask = await taskRepository.getTaskById(taskId);
    if (localTask == null) return null;

    if (localTask.syncStatus != 'conflict') return null;

    final serverTask = await taskRepository.getServerTaskById(taskId);
    if (serverTask == null) return null;

    final conflictingFields = _identifyConflictingFields(localTask, serverTask);
    
    return ConflictData(
      taskId: taskId,
      localVersion: localTask,
      serverVersion: serverTask,
      localModifiedAt: localTask.updatedAt,
      serverModifiedAt: serverTask.updatedAt,
      conflictingFields: conflictingFields,
    );
  }

  @override
  Future<List<ConflictData>> getAllConflicts() async {
    final conflictingTasks = await taskRepository.getConflictingTasks();
    final conflicts = <ConflictData>[];

    for (final task in conflictingTasks) {
      final conflictData = await getConflictData(task.id);
      if (conflictData != null) {
        conflicts.add(conflictData);
      }
    }

    return conflicts;
  }

  List<String> _identifyConflictingFields(TaskEntity local, TaskEntity server) {
    final conflictingFields = <String>[];

    if (local.title != server.title) conflictingFields.add('title');
    if (local.description != server.description) conflictingFields.add('description');
    if (local.status != server.status) conflictingFields.add('status');
    if (local.priority != server.priority) conflictingFields.add('priority');
    if (local.dueDate != server.dueDate) conflictingFields.add('dueDate');
    if (local.assignedTo != server.assignedTo) conflictingFields.add('assignedTo');
    if (local.location != server.location) conflictingFields.add('location');
    if (local.notes != server.notes) conflictingFields.add('notes');

    return conflictingFields;
  }

  Future<TaskEntity> _resolveWithLocal(ConflictData conflictData) async {
    return conflictData.localVersion;
  }

  Future<TaskEntity> _resolveWithServer(ConflictData conflictData) async {
    return conflictData.serverVersion;
  }

  Future<TaskEntity> _resolveWithMerge(
    ConflictData conflictData,
    TaskEntity? mergedData,
  ) async {
    if (mergedData != null) return mergedData;

    final local = conflictData.localVersion;
    return TaskEntity(
      id: local.id,
      title: local.title,
      description: local.description.isNotEmpty ? local.description : conflictData.serverVersion.description,
      status: local.status,
      priority: local.priority,
      dueDate: local.dueDate ?? conflictData.serverVersion.dueDate,
      assignedTo: local.assignedTo,
      location: local.location,
      notes: local.notes.isNotEmpty ? local.notes : conflictData.serverVersion.notes,
      createdAt: local.createdAt,
      updatedAt: DateTime.now(),
      syncStatus: 'synced',
      version: conflictData.serverVersion.version + 1,
    );
  }

  Future<TaskEntity> _resolveWithLastWriteWins(ConflictData conflictData) async {
    if (conflictData.localIsNewer) {
      return conflictData.localVersion;
    } else {
      return conflictData.serverVersion;
    }
  }
}