package field_app.domain.repositories;

import 'package:field_app/domain/entities/task_entity.dart';

abstract class TaskRepository {
  Future<List<TaskEntity>> getTasks();
  Future<TaskEntity?> getTaskById(String id);
  Future<List<TaskEntity>> getTasksByStatus(String status);
  Future<List<TaskEntity>> getTasksByPriority(String priority);
  Future<List<TaskEntity>> getPendingSyncTasks();
  Future<TaskEntity> saveTask(TaskEntity task);
  Future<void> deleteTask(String id);
  Future<void> deleteAllTasks();
  Future<int> getTaskCount();
  Future<int> getPendingSyncCount();
  Future<List<TaskEntity>> searchTasks(String query);
  Future<void> updateTaskSyncStatus(String id, String syncStatus);
  Future<void> incrementTaskVersion(String id);
  Future<List<TaskEntity>> getTasksDueSoon(Duration within);
  Future<List<TaskEntity>> getOverdueTasks();
  Future<void> batchSaveTasks(List<TaskEntity> tasks);
  Stream<List<TaskEntity>> watchTasks();
  Stream<TaskEntity?> watchTask(String id);
  Future<List<TaskEntity>> getRemoteTasks();
}