import 'package:equatable/equatable.dart';
import '../../../domain/entities/task_entity.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasksEvent extends TaskEvent {
  final bool forceRefresh;
  final bool fromRemote;

  const LoadTasksEvent({
    this.forceRefresh = false,
    this.fromRemote = false,
  });

  @override
  List<Object?> get props => [forceRefresh, fromRemote];
}

class LoadTaskByIdEvent extends TaskEvent {
  final String taskId;

  const LoadTaskByIdEvent({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class AddTaskEvent extends TaskEvent {
  final TaskEntity task;

  const AddTaskEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final TaskEntity task;
  final bool syncImmediately;

  const UpdateTaskEvent({
    required this.task,
    this.syncImmediately = false,
  });

  @override
  List<Object?> get props => [task, syncImmediately];
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  final bool hardDelete;

  const DeleteTaskEvent({
    required this.taskId,
    this.hardDelete = false,
  });

  @override
  List<Object?> get props => [taskId, hardDelete];
}

class RefreshTasksEvent extends TaskEvent {
  final String? filterStatus;
  final String? filterPriority;

  const RefreshTasksEvent({
    this.filterStatus,
    this.filterPriority,
  });

  @override
  List<Object?> get props => [filterStatus, filterPriority];
}

class FilterTasksEvent extends TaskEvent {
  final String? status;
  final String? priority;
  final String? searchQuery;
  final DateTime? dueDateFrom;
  final DateTime? dueDateTo;

  const FilterTasksEvent({
    this.status,
    this.priority,
    this.searchQuery,
    this.dueDateFrom,
    this.dueDateTo,
  });

  @override
  List<Object?> get props => [status, priority, searchQuery, dueDateFrom, dueDateTo];
}

class ClearFiltersEvent extends TaskEvent {
  const ClearFiltersEvent();
}

class SyncTaskEvent extends TaskEvent {
  final String taskId;

  const SyncTaskEvent({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class SyncAllTasksEvent extends TaskEvent {
  const SyncAllTasksEvent();
}

class ResolveTaskConflictEvent extends TaskEvent {
  final String taskId;
  final String resolutionStrategy;

  const ResolveTaskConflictEvent({
    required this.taskId,
    required this.resolutionStrategy,
  });

  @override
  List<Object?> get props => [taskId, resolutionStrategy];
}

class SelectTaskEvent extends TaskEvent {
  final String taskId;

  const SelectTaskEvent({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class DeselectTaskEvent extends TaskEvent {
  final String taskId;

  const DeselectTaskEvent({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class ClearSelectionEvent extends TaskEvent {
  const ClearSelectionEvent();
}

class BulkUpdateTasksEvent extends TaskEvent {
  final List<String> taskIds;
  final Map<String, dynamic> updates;

  const BulkUpdateTasksEvent({
    required this.taskIds,
    required this.updates,
  });

  @override
  List<Object?> get props => [taskIds, updates];
}

class BulkDeleteTasksEvent extends TaskEvent {
  final List<String> taskIds;

  const BulkDeleteTasksEvent({required this.taskIds});

  @override
  List<Object?> get props => [taskIds];
}

class RetryFailedSyncEvent extends TaskEvent {
  const RetryFailedSyncEvent();
}