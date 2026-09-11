import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/local/task_local_datasource.dart';
import '../datasources/remote/task_remote_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;
  final TaskRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final Uuid uuid;

  TaskRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
    required this.uuid,
  });

  @override
  Future<List<TaskEntity>> getTasks() async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final remoteTasks = await remoteDataSource.getTasks();
        await localDataSource.cacheTasks(remoteTasks);
        return remoteTasks.map((model) => model.toEntity()).toList();
      } on ServerException {
        return await _getLocalTasks();
      } on NetworkException {
        return await _getLocalTasks();
      }
    } else {
      return await _getLocalTasks();
    }
  }

  Future<List<TaskEntity>> _getLocalTasks() async {
    final localTasks = await localDataSource.getTasks();
    return localTasks.map((model) => model.toEntity()).toList();
  }

  @override
  Future<TaskEntity?> getTaskById(String id) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final remoteTask = await remoteDataSource.getTaskById(id);
        await localDataSource.cacheTask(remoteTask);
        return remoteTask.toEntity();
      } on ServerException {
        return await _getLocalTaskById(id);
      } on NetworkException {
        return await _getLocalTaskById(id);
      }
    } else {
      return await _getLocalTaskById(id);
    }
  }

  Future<TaskEntity?> _getLocalTaskById(String id) async {
    final localTask = await localDataSource.getTaskById(id);
    return localTask?.toEntity();
  }

  @override
  Future<TaskEntity> createTask(TaskEntity task) async {
    final isConnected = await networkInfo.isConnected;
    final now = DateTime.now();
    final taskId = task.id ?? uuid.v4();

    final taskModel = TaskModel(
      id: taskId,
      title: task.title,
      description: task.description,
      priority: task.priority,
      status: task.status,
      dueDate: task.dueDate,
      assignedTo: task.assignedTo,
      createdAt: now,
      updatedAt: now,
      syncStatus: isConnected ? AppConstants.syncStatusSynced : AppConstants.syncStatusPending,
      localModified: !isConnected,
      serverVersion: 1,
      isDeleted: false,
    );

    await localDataSource.saveTask(taskModel);

    if (isConnected) {
      try {
        final createdTask = await remoteDataSource.createTask(taskModel);
        await localDataSource.updateTaskSyncStatus(
          taskId,
          AppConstants.syncStatusSynced,
        );
        return createdTask.toEntity();
      } on ServerException {
        await localDataSource.updateTaskSyncStatus(
          taskId,
          AppConstants.syncStatusPending,
        );
        return taskModel.toEntity();
      }
    }

    return taskModel.toEntity();
  }

  @override
  Future<TaskEntity> updateTask(TaskEntity task) async {
    final isConnected = await networkInfo.isConnected;
    final now = DateTime.now();

    final taskModel = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      priority: task.priority,
      status: task.status,
      dueDate: task.dueDate,
      assignedTo: task.assignedTo,
      createdAt: task.createdAt,
      updatedAt: now,
      syncStatus: isConnected ? AppConstants.syncStatusSynced : AppConstants.syncStatusPending,
      localModified: !isConnected,
      serverVersion: task.serverVersion,
      isDeleted: task.isDeleted,
    );

    await localDataSource.updateTask(taskModel);

    if (isConnected) {
      try {
        final updatedTask = await remoteDataSource.updateTask(taskModel);
        await localDataSource.updateTaskSyncStatus(
          task.id!,
          AppConstants.syncStatusSynced,
        );
        return updatedTask.toEntity();
      } on ServerException catch (e) {
        if (e.statusCode == 409) {
          throw ConflictException(
            message: 'Conflict detected during update',
            entityId: task.id!,
            localData: taskModel.toJson(),
            remoteData: null,
            conflictType: 'update',
          );
        }
        await localDataSource.updateTaskSyncStatus(
          task.id!,
          AppConstants.syncStatusPending,
        );
        return taskModel.toEntity();
      }
    }

    return taskModel.toEntity();
  }

  @override
  Future<void> deleteTask(String id) async {
    final isConnected = await networkInfo.isConnected;
    final now = DateTime.now();

    final existingTask = await localDataSource.getTaskById(id);
    if (existingTask == null) {
      throw DatabaseException(
        message: 'Task not found for deletion',
        sql: 'DELETE FROM tasks WHERE id = ?',
      );
    }

    final deletedTask = TaskModel(
      id: existingTask.id,
      title: existingTask.title,
      description: existingTask.description,
      priority: existingTask.priority,
      status: existingTask.status,
      dueDate: existingTask.dueDate,
      assignedTo: existingTask.assignedTo,
      createdAt: existingTask.createdAt,
      updatedAt: now,
      syncStatus: isConnected ? AppConstants.syncStatusSynced : AppConstants.syncStatusPending,
      localModified: !isConnected,
      serverVersion: existingTask.serverVersion,
      isDeleted: true,
    );

    await localDataSource.updateTask(deletedTask);

    if (isConnected) {
      try {
        await remoteDataSource.deleteTask(id);
        await localDataSource.deleteTask(id);
      } on ServerException {
        await localDataSource.updateTaskSyncStatus(
          id,
          AppConstants.syncStatusPending,
        );
      }
    }
  }

  @override
  Future<List<TaskEntity>> getPendingSyncTasks() async {
    final pendingTasks = await localDataSource.getPendingTasks();
    return pendingTasks.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> syncTasks() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      throw NetworkException(
        message: 'No internet connection for sync',
        url: '/sync',
        isConnectionError: true,
        isTimeout: false,
        isSslError: false,
      );
    }

    final pendingTasks = await localDataSource.getPendingTasks();
    if (pendingTasks.isEmpty) return;

    try {
      final syncedTasks = await remoteDataSource.syncTasks(pendingTasks);

      for (final syncedTask in syncedTasks) {
        await localDataSource.updateTaskSyncStatus(
          syncedTask.id,
          AppConstants.syncStatusSynced,
        );
      }
    } on ServerException catch (e) {
      if (e.statusCode == 409) {
        throw ConflictException(
          message: 'Conflict during batch sync',
          entityId: 'batch',
          localData: pendingTasks.map((t) => t.toJson()).toList(),
          remoteData: null,
          conflictType: 'batch_sync',
        );
      }
      for (final task in pendingTasks) {
        await localDataSource.updateTaskSyncStatus(
          task.id,
          AppConstants.syncStatusFailed,
        );
      }
      rethrow;
    }
  }

  @override
  Future<List<TaskEntity>> searchTasks(String query) async {
    final localTasks = await localDataSource.searchTasks(query);
    return localTasks.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<TaskEntity>> getTasksByStatus(String status) async {
    final localTasks = await localDataSource.getTasksByStatus(status);
    return localTasks.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<TaskEntity>> getTasksByPriority(String priority) async {
    final localTasks = await localDataSource.getTasksByPriority(priority);
    return localTasks.map((model) => model.toEntity()).toList();
  }
}