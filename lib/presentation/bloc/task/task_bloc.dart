import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/task_entity.dart';
import '../../../domain/repositories/task_repository.dart';
import '../../../domain/usecases/get_local_tasks.dart';
import '../../../domain/usecases/save_task_local.dart';
import '../../../domain/usecases/sync_tasks.dart';
import '../../../domain/usecases/resolve_conflict.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/network_info.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetLocalTasks getLocalTasks;
  final SaveTaskLocal saveTaskLocal;
  final SyncTasks syncTasks;
  final ResolveConflict resolveConflict;
  final TaskRepository taskRepository;
  final NetworkInfo networkInfo;

  static const int _pageSize = 20;
  int _currentPage = 0;

  TaskBloc({
    required this.getLocalTasks,
    required this.saveTaskLocal,
    required this.syncTasks,
    required this.resolveConflict,
    required this.taskRepository,
    required this.networkInfo,
  }) : super(const TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<LoadTaskByIdEvent>(_onLoadTaskById);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<RefreshTasksEvent>(_onRefreshTasks);
    on<FilterTasksEvent>(_onFilterTasks);
    on<ClearFiltersEvent>(_onClearFilters);
    on<SyncTaskEvent>(_onSyncTask);
    on<SyncAllTasksEvent>(_onSyncAllTasks);
    on<ResolveTaskConflictEvent>(_onResolveConflict);
    on<SelectTaskEvent>(_onSelectTask);
    on<DeselectTaskEvent>(_onDeselectTask);
    on<ClearSelectionEvent>(_onClearSelection);
    on<BulkUpdateTasksEvent>(_onBulkUpdateTasks);
    on<BulkDeleteTasksEvent>(_onBulkDeleteTasks);
    on<RetryFailedSyncEvent>(_onRetryFailedSync);
  }

  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading(
      tasks: state.tasks,
      filteredTasks: state.filteredTasks,
      selectedTaskIds: state.selectedTaskIds,
      currentFilter: state.currentFilter,
    ));

    try {
      final isConnected = await networkInfo.isConnected;
      final List<TaskEntity> tasks;

      if (event.fromRemote && isConnected) {
        tasks = await taskRepository.getRemoteTasks();
      } else {
        tasks = await getLocalTasks(
          page: _currentPage,
          pageSize: _pageSize,
        );
      }

      final allTasks = event.forceRefresh ? tasks : [...state.tasks, ...tasks];
      final hasReachedMax = tasks.length < _pageSize;

      final filteredTasks = _applyFilters(allTasks, state.currentFilter);

      emit(TaskLoaded(
        tasks: allTasks,
        filteredTasks: filteredTasks,
        selectedTaskIds: state.selectedTaskIds,
        hasReachedMax: hasReachedMax,
        totalCount: allTasks.length,
        lastSyncTime: isConnected ? DateTime.now() : state.lastSyncTime,
        currentFilter: state.currentFilter,
      ));
    } on Failure catch (e) {
      emit(TaskError(
        message: e.userFriendlyMessage,
        code: e.failureType,
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    } catch (e) {
      emit(TaskError(
        message: 'Error al cargar las tareas: ${e.toString()}',
        code: 'LOAD_ERROR',
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    }
  }

  Future<void> _onLoadTaskById(
    LoadTaskByIdEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading(
      tasks: state.tasks,
      filteredTasks: state.filteredTasks,
      selectedTaskIds: state.selectedTaskIds,
      currentFilter: state.currentFilter,
    ));

    try {
      final task = await taskRepository.getTaskById(event.taskId);
      if (task != null) {
        emit(TaskOperationSuccess(
          operation: 'LOADED',
          affectedTask: task,
          tasks: state.tasks,
          filteredTasks: state.filteredTasks,
          selectedTaskIds: state.selectedTaskIds,
          currentFilter: state.currentFilter,
        ));
      } else {
        emit(TaskError(
          message: 'Tarea no encontrada',
          code: 'NOT_FOUND',
          tasks: state.tasks,
          filteredTasks: state.filteredTasks,
          currentFilter: state.currentFilter,
        ));
      }
    } on Failure catch (e) {
      emit(TaskError(
        message: e.userFriendlyMessage,
        code: e.failureType,
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    } catch (e) {
      emit(TaskError(
        message: 'Error al cargar la tarea: ${e.toString()}',
        code: 'LOAD_ERROR',
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    }
  }

  Future<void> _onAddTask(
    AddTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading(
      tasks: state.tasks,
      filteredTasks: state.filteredTasks,
      selectedTaskIds: state.selectedTaskIds,
      currentFilter: state.currentFilter,
    ));

    try {
      await saveTaskLocal(task: event.task);

      final updatedTasks = [event.task, ...state.tasks];
      final filteredTasks = _applyFilters(updatedTasks, state.currentFilter);

      emit(TaskOperationSuccess(
        operation: 'CREATED',
        affectedTask: event.task,
        tasks: updatedTasks,
        filteredTasks: filteredTasks,
        selectedTaskIds: state.selectedTaskIds,
        currentFilter: state.currentFilter,
      ));

      final isConnected = await networkInfo.isConnected;
      if (isConnected) {
        add(const SyncAllTasksEvent());
      }
    } on Failure catch (e) {
      emit(TaskError(
        message: e.userFriendlyMessage,
        code: e.failureType,
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    } catch (e) {
      emit(TaskError(
        message: 'Error al crear la tarea: ${e.toString()}',
        code: 'CREATE_ERROR',
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    }
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading(
      tasks: state.tasks,
      filteredTasks: state.filteredTasks,
      selectedTaskIds: state.selectedTaskIds,
      currentFilter: state.currentFilter,
    ));

    try {
      await saveTaskLocal(task: event.task);

      final updatedTasks = state.tasks.map((task) {
        return task.id == event.task.id ? event.task : task;
      }).toList();

      final filteredTasks = _applyFilters(updatedTasks, state.currentFilter);

      emit(TaskOperationSuccess(
        operation: 'UPDATED',
        affectedTask: event.task,
        tasks: updatedTasks,
        filteredTasks: filteredTasks,
        selectedTaskIds: state.selectedTaskIds,
        currentFilter: state.currentFilter,
      ));

      final isConnected = await networkInfo.isConnected;
      if (event.syncImmediately && isConnected) {
        add(SyncTaskEvent(taskId: event.task.id));
      } else if (!isConnected) {
        add(const SyncAllTasksEvent());
      }
    } on Failure catch (e) {
      emit(TaskError(
        message: e.userFriendlyMessage,
        code: e.failureType,
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    } catch (e) {
      emit(TaskError(
        message: 'Error al actualizar la tarea: ${e.toString()}',
        code: 'UPDATE_ERROR',
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading(
      tasks: state.tasks,
      filteredTasks: state.filteredTasks,
      selectedTaskIds: state.selectedTaskIds,
      currentFilter: state.currentFilter,
    ));

    try {
      await taskRepository.deleteTask(event.taskId, hard: event.hardDelete);

      final updatedTasks = state.tasks
          .where((task) => task.id != event.taskId)
          .toList();

      final filteredTasks = _applyFilters(updatedTasks, state.currentFilter);
      final updatedSelection = Set<String>.from(state.selectedTaskIds)
        ..remove(event.taskId);

      emit(TaskOperationSuccess(
        operation: 'DELETED',
        affectedTaskIds: [event.taskId],
        tasks: updatedTasks,
        filteredTasks: filteredTasks,
        selectedTaskIds: updatedSelection,
        currentFilter: state.currentFilter,
      ));
    } on Failure catch (e) {
      emit(TaskError(
        message: e.userFriendlyMessage,
        code: e.failureType,
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    } catch (e) {
      emit(TaskError(
        message: 'Error al eliminar la tarea: ${e.toString()}',
        code: 'DELETE_ERROR',
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    }
  }

  Future<void> _onRefreshTasks(
    RefreshTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    _currentPage = 0;
    add(LoadTasksEvent(
      forceRefresh: true,
      fromRemote: false,
    ));

    if (event.filterStatus != null || event.filterPriority != null) {
      add(FilterTasksEvent(
        status: event.filterStatus,
        priority: event.filterPriority,
      ));
    }
  }

  Future<void> _onFilterTasks(
    FilterTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    final newFilter = TaskFilter(
      status: event.status,
      priority: event.priority,
      searchQuery: event.searchQuery,
      dueDateFrom: event.dueDateFrom,
      dueDateTo: event.dueDateTo,
    );

    final filteredTasks = _applyFilters(state.tasks, newFilter);

    emit(TaskLoaded(
      tasks: state.tasks,
      filteredTasks: filteredTasks,
      selectedTaskIds: state.selectedTaskIds,
      lastSyncTime: state.lastSyncTime,
      currentFilter: newFilter,
      totalCount: state.totalCount,
    ));
  }

  Future<void> _onClearFilters(
    ClearFiltersEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoaded(
      tasks: state.tasks,
      filteredTasks: state.tasks,
      selectedTaskIds: state.selectedTaskIds,
      lastSyncTime: state.lastSyncTime,
      currentFilter: const TaskFilter(),
      totalCount: state.totalCount,
    ));
  }

  Future<void> _onSyncTask(
    SyncTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final currentState = state;
    if (currentState is TaskLoaded) {
      emit(currentState.copyWith(isSyncing: true));
    }

    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        emit(TaskError(
          message: 'No hay conexión a internet para sincronizar',
          code: 'NO_CONNECTION',
          tasks: state.tasks,
          filteredTasks: state.filteredTasks,
          currentFilter: state.currentFilter,
        ));
        return;
      }

      final result = await syncTasks(taskIds: [event.taskId]);

      if (result.isSuccess) {
        final updatedTasks = await getLocalTasks(
          page: 0,
          pageSize: state.totalCount,
        );
        final filteredTasks = _applyFilters(updatedTasks, state.currentFilter);

        emit(TaskLoaded(
          tasks: updatedTasks,
          filteredTasks: filteredTasks,
          selectedTaskIds: state.selectedTaskIds,
          isSyncing: false,
          lastSyncTime: DateTime.now(),
          currentFilter: state.currentFilter,
          totalCount: updatedTasks.length,
        ));
      } else {
        emit(TaskError(
          message: result.error?.userFriendlyMessage ?? 'Error de sincronización',
          code: result.error?.failureType ?? 'SYNC_ERROR',
          tasks: state.tasks,
          filteredTasks: state.filteredTasks,
          currentFilter: state.currentFilter,
        ));
      }
    } on Failure catch (e) {
      emit(TaskError(
        message: e.userFriendlyMessage,
        code: e.failureType,
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    } catch (e) {
      emit(TaskError(
        message: 'Error al sincronizar la tarea: ${e.toString()}',
        code: 'SYNC_ERROR',
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    }
  }

  Future<void> _onSyncAllTasks(
    SyncAllTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    final currentState = state;
    if (currentState is TaskLoaded) {
      emit(currentState.copyWith(isSyncing: true));
    }

    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        emit(TaskError(
          message: 'No hay conexión a internet para sincronizar',
          code: 'NO_CONNECTION',
          tasks: state.tasks,
          filteredTasks: state.filteredTasks,
          currentFilter: state.currentFilter,
        ));
        return;
      }

      final taskIds = state.tasks.map((t) => t.id).toList();
      final result = await syncTasks(taskIds: taskIds);

      if (result.isSuccess) {
        final updatedTasks = await getLocalTasks(
          page: 0,
          pageSize: state.totalCount,
        );
        final filteredTasks = _applyFilters(updatedTasks, state.currentFilter);

        emit(TaskLoaded(
          tasks: updatedTasks,
          filteredTasks: filteredTasks,
          selectedTaskIds: state.selectedTaskIds,
          isSyncing: false,
          lastSyncTime: DateTime.now(),
          currentFilter: state.currentFilter,
          totalCount: updatedTasks.length,
        ));
      } else {
        emit(TaskError(
          message: result.error?.userFriendlyMessage ?? 'Error de sincronización',
          code: result.error?.failureType ?? 'SYNC_ERROR',
          tasks: state.tasks,
          filteredTasks: state.filteredTasks,
          currentFilter: state.currentFilter,
        ));
      }
    } on Failure catch (e) {
      emit(TaskError(
        message: e.userFriendlyMessage,
        code: e.failureType,
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    } catch (e) {
      emit(TaskError(
        message: 'Error al sincronizar las tareas: ${e.toString()}',
        code: 'SYNC_ERROR',
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    }
  }

  Future<void> _onResolveConflict(
    ResolveTaskConflictEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading(
      tasks: state.tasks,
      filteredTasks: state.filteredTasks,
      selectedTaskIds: state.selectedTaskIds,
      currentFilter: state.currentFilter,
    ));

    try {
      final result = await resolveConflict(
        entityId: event.taskId,
        strategy: event.resolutionStrategy,
      );

      if (result.isSuccess) {
        final updatedTasks = await getLocalTasks(
          page: 0,
          pageSize: state.totalCount,
        );
        final filteredTasks = _applyFilters(updatedTasks, state.currentFilter);

        emit(TaskOperationSuccess(
          operation: 'CONFLICT_RESOLVED',
          tasks: updatedTasks,
          filteredTasks: filteredTasks,
          selectedTaskIds: state.selectedTaskIds,
          currentFilter: state.currentFilter,
        ));
      } else {
        emit(TaskError(
          message: result.error?.userFriendlyMessage ?? 'Error al resolver conflicto',
          code: result.error?.failureType ?? 'CONFLICT_ERROR',
          tasks: state.tasks,
          filteredTasks: state.filteredTasks,
          currentFilter: state.currentFilter,
        ));
      }
    } on Failure catch (e) {
      emit(TaskError(
        message: e.userFriendlyMessage,
        code: e.failureType,
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    } catch (e) {
      emit(TaskError(
        message: 'Error al resolver el conflicto: ${e.toString()}',
        code: 'CONFLICT_ERROR',
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    }
  }

  Future<void> _onSelectTask(
    SelectTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final updatedSelection = Set<String>.from(state.selectedTaskIds)
      ..add(event.taskId);

    emit(TaskLoaded(
      tasks: state.tasks,
      filteredTasks: state.filteredTasks,
      selectedTaskIds: updatedSelection,
      lastSyncTime: state.lastSyncTime,
      currentFilter: state.currentFilter,
      totalCount: state.totalCount,
    ));
  }

  Future<void> _onDeselectTask(
    DeselectTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final updatedSelection = Set<String>.from(state.selectedTaskIds)
      ..remove(event.taskId);

    emit(TaskLoaded(
      tasks: state.tasks,
      filteredTasks: state.filteredTasks,
      selectedTaskIds: updatedSelection,
      lastSyncTime: state.lastSyncTime,
      currentFilter: state.currentFilter,
      totalCount: state.totalCount,
    ));
  }

  Future<void> _onClearSelection(
    ClearSelectionEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoaded(
      tasks: state.tasks,
      filteredTasks: state.filteredTasks,
      selectedTaskIds: const {},
      lastSyncTime: state.lastSyncTime,
      currentFilter: state.currentFilter,
      totalCount: state.totalCount,
    ));
  }

  Future<void> _onBulkUpdateTasks(
    BulkUpdateTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading(
      tasks: state.tasks,
      filteredTasks: state.filteredTasks,
      selectedTaskIds: state.selectedTaskIds,
      currentFilter: state.currentFilter,
    ));

    try {
      for (final taskId in event.taskIds) {
        final task = state.tasks.firstWhere((t) => t.id == taskId);
        final updatedTask = task.copyWith(
          ...event.updates.map((key, value) => MapEntry(
            key == 'status' ? 'status' : key,
            value,
          )),
        );
        await saveTaskLocal(task: updatedTask);
      }

      final updatedTasks = state.tasks.map((task) {
        if (event.taskIds.contains(task.id)) {
          return task.copyWith(
            ...event.updates.map((key, value) => MapEntry(key, value)),
          );
        }
        return task;
      }).toList();

      final filteredTasks = _applyFilters(updatedTasks, state.currentFilter);

      emit(TaskOperationSuccess(
        operation: 'BULK_UPDATED',
        affectedTaskIds: event.taskIds,
        tasks: updatedTasks,
        filteredTasks: filteredTasks,
        selectedTaskIds: state.selectedTaskIds,
        currentFilter: state.currentFilter,
      ));

      final isConnected = await networkInfo.isConnected;
      if (isConnected) {
        add(const SyncAllTasksEvent());
      }
    } on Failure catch (e) {
      emit(TaskError(
        message: e.userFriendlyMessage,
        code: e.failureType,
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    } catch (e) {
      emit(TaskError(
        message: 'Error en actualización masiva: ${e.toString()}',
        code: 'BULK_UPDATE_ERROR',
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    }
  }

  Future<void> _onBulkDeleteTasks(
    BulkDeleteTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading(
      tasks: state.tasks,
      filteredTasks: state.filteredTasks,
      selectedTaskIds: state.selectedTaskIds,
      currentFilter: state.currentFilter,
    ));

    try {
      for (final taskId in event.taskIds) {
        await taskRepository.deleteTask(taskId, hard: true);
      }

      final updatedTasks = state.tasks
          .where((task) => !event.taskIds.contains(task.id))
          .toList();

      final filteredTasks = _applyFilters(updatedTasks, state.currentFilter);

      emit(TaskOperationSuccess(
        operation: 'BULK_DELETED',
        affectedTaskIds: event.taskIds,
        tasks: updatedTasks,
        filteredTasks: filteredTasks,
        selectedTaskIds: const {},
        currentFilter: state.currentFilter,
      ));
    } on Failure catch (e) {
      emit(TaskError(
        message: e.userFriendlyMessage,
        code: e.failureType,
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    } catch (e) {
      emit(TaskError(
        message: 'Error en eliminación masiva: ${e.toString()}',
        code: 'BULK_DELETE_ERROR',
        tasks: state.tasks,
        filteredTasks: state.filteredTasks,
        currentFilter: state.currentFilter,
      ));
    }
  }

  Future<void> _onRetryFailedSync(
    RetryFailedSyncEvent event,
    Emitter<TaskState> emit,
  ) async {
    final failedTasks = state.tasks
        .where((task) => task.syncStatus == 'failed')
        .map((task) => task.id)
        .toList();

    if (failedTasks.isEmpty) {
      return;
    }

    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      final result = await syncTasks(taskIds: failedTasks);
      if (result.isSuccess) {
        add(const LoadTasksEvent(forceRefresh: true));
      }
    }
  }

  List<TaskEntity> _applyFilters(
    List<TaskEntity> tasks,
    TaskFilter filter,
  ) {
    var filtered = tasks;

    if (filter.status != null) {
      filtered = filtered.where((t) => t.status == filter.status).toList();
    }

    if (filter.priority != null) {
      filtered = filtered.where((t) => t.priority == filter.priority).toList();
    }

    if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
      final query = filter.searchQuery!.toLowerCase();
      filtered = filtered.where((t) {
        return t.title.toLowerCase().contains(query) ||
            (t.description?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    if (filter.dueDateFrom != null) {
      filtered = filtered.where((t) {
        return t.dueDate != null && t.dueDate!.isAfter(filter.dueDateFrom!);
      }).toList();
    }

    if (filter.dueDateTo != null) {
      filtered = filtered.where((t) {
        return t.dueDate != null && t.dueDate!.isBefore(filter.dueDateTo!);
      }).toList();
    }

    if (!filter.showCompleted) {
      filtered = filtered.where((t) => t.status != 'completed').toList();
    }

    if (!filter.showPending) {
      filtered = filtered.where((t) => t.status != 'pending').toList();
    }

    if (!filter.showInProgress) {
      filtered = filtered.where((t) => t.status != 'in_progress').toList();
    }

    return filtered;
  }
}