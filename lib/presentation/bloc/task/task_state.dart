import 'package:equatable/equatable.dart';
import '../../../domain/entities/task_entity.dart';

abstract class TaskState extends Equatable {
  final List<TaskEntity> tasks;
  final List<TaskEntity> filteredTasks;
  final Set<String> selectedTaskIds;
  final bool isLoading;
  final bool isSyncing;
  final String? errorMessage;
  final String? errorCode;
  final DateTime? lastSyncTime;
  final TaskFilter currentFilter;
  final bool hasReachedMax;
  final int totalCount;

  const TaskState({
    this.tasks = const [],
    this.filteredTasks = const [],
    this.selectedTaskIds = const {},
    this.isLoading = false,
    this.isSyncing = false,
    this.errorMessage,
    this.errorCode,
    this.lastSyncTime,
    this.currentFilter = const TaskFilter(),
    this.hasReachedMax = false,
    this.totalCount = 0,
  });

  @override
  List<Object?> get props => [
        tasks,
        filteredTasks,
        selectedTaskIds,
        isLoading,
        isSyncing,
        errorMessage,
        errorCode,
        lastSyncTime,
        currentFilter,
        hasReachedMax,
        totalCount,
      ];

  TaskState copyWith({
    List<TaskEntity>? tasks,
    List<TaskEntity>? filteredTasks,
    Set<String>? selectedTaskIds,
    bool? isLoading,
    bool? isSyncing,
    String? errorMessage,
    String? errorCode,
    DateTime? lastSyncTime,
    TaskFilter? currentFilter,
    bool? hasReachedMax,
    int? totalCount,
    bool clearError = false,
  });
}

class TaskInitial extends TaskState {
  const TaskInitial() : super();
}

class TaskLoading extends TaskState {
  const TaskLoading({
    super.tasks,
    super.filteredTasks,
    super.selectedTaskIds,
    super.currentFilter,
  }) : super(isLoading: true);
}

class TaskLoaded extends TaskState {
  const TaskLoaded({
    required super.tasks,
    required super.filteredTasks,
    super.selectedTaskIds,
    super.isSyncing,
    super.errorMessage,
    super.lastSyncTime,
    super.currentFilter,
    super.hasReachedMax,
    super.totalCount,
  });

  @override
  TaskLoaded copyWith({
    List<TaskEntity>? tasks,
    List<TaskEntity>? filteredTasks,
    Set<String>? selectedTaskIds,
    bool? isLoading,
    bool? isSyncing,
    String? errorMessage,
    String? errorCode,
    DateTime? lastSyncTime,
    TaskFilter? currentFilter,
    bool? hasReachedMax,
    int? totalCount,
    bool clearError = false,
  }) {
    return TaskLoaded(
      tasks: tasks ?? this.tasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      selectedTaskIds: selectedTaskIds ?? this.selectedTaskIds,
      isSyncing: isSyncing ?? this.isSyncing,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      currentFilter: currentFilter ?? this.currentFilter,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

class TaskOperationSuccess extends TaskState {
  final String operation;
  final TaskEntity? affectedTask;
  final List<String>? affectedTaskIds;

  const TaskOperationSuccess({
    required this.operation,
    super.tasks,
    super.filteredTasks,
    super.selectedTaskIds,
    super.isSyncing,
    super.lastSyncTime,
    super.currentFilter,
    this.affectedTask,
    this.affectedTaskIds,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        operation,
        affectedTask,
        affectedTaskIds,
      ];

  @override
  TaskOperationSuccess copyWith({
    List<TaskEntity>? tasks,
    List<TaskEntity>? filteredTasks,
    Set<String>? selectedTaskIds,
    bool? isLoading,
    bool? isSyncing,
    String? errorMessage,
    String? errorCode,
    DateTime? lastSyncTime,
    TaskFilter? currentFilter,
    bool? hasReachedMax,
    int? totalCount,
    bool clearError = false,
  }) {
    return TaskOperationSuccess(
      operation: operation,
      tasks: tasks ?? this.tasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      selectedTaskIds: selectedTaskIds ?? this.selectedTaskIds,
      isSyncing: isSyncing ?? this.isSyncing,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      currentFilter: currentFilter ?? this.currentFilter,
      affectedTask: affectedTask,
      affectedTaskIds: affectedTaskIds,
    );
  }
}

class TaskError extends TaskState {
  const TaskError({
    required String message,
    String? code,
    super.tasks,
    super.filteredTasks,
    super.selectedTaskIds,
    super.currentFilter,
  }) : super(
          errorMessage: message,
          errorCode: code,
          isLoading: false,
        );

  @override
  TaskError copyWith({
    List<TaskEntity>? tasks,
    List<TaskEntity>? filteredTasks,
    Set<String>? selectedTaskIds,
    bool? isLoading,
    bool? isSyncing,
    String? errorMessage,
    String? errorCode,
    DateTime? lastSyncTime,
    TaskFilter? currentFilter,
    bool? hasReachedMax,
    int? totalCount,
    bool clearError = false,
  }) {
    return TaskError(
      message: errorMessage ?? this.errorMessage ?? 'Unknown error',
      code: errorCode ?? this.errorCode,
      tasks: tasks ?? this.tasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      selectedTaskIds: selectedTaskIds ?? this.selectedTaskIds,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }
}

class TaskFilter extends Equatable {
  final String? status;
  final String? priority;
  final String? searchQuery;
  final DateTime? dueDateFrom;
  final DateTime? dueDateTo;
  final bool showCompleted;
  final bool showPending;
  final bool showInProgress;

  const TaskFilter({
    this.status,
    this.priority,
    this.searchQuery,
    this.dueDateFrom,
    this.dueDateTo,
    this.showCompleted = true,
    this.showPending = true,
    this.showInProgress = true,
  });

  bool get hasActiveFilters =>
      status != null ||
      priority != null ||
      (searchQuery != null && searchQuery!.isNotEmpty) ||
      dueDateFrom != null ||
      dueDateTo != null;

  @override
  List<Object?> get props => [
        status,
        priority,
        searchQuery,
        dueDateFrom,
        dueDateTo,
        showCompleted,
        showPending,
        showInProgress,
      ];

  TaskFilter copyWith({
    String? status,
    String? priority,
    String? searchQuery,
    DateTime? dueDateFrom,
    DateTime? dueDateTo,
    bool? showCompleted,
    bool? showPending,
    bool? showInProgress,
    bool clearStatus = false,
    bool clearPriority = false,
    bool clearSearchQuery = false,
    bool clearDueDateFrom = false,
    bool clearDueDateTo = false,
  }) {
    return TaskFilter(
      status: clearStatus ? null : (status ?? this.status),
      priority: clearPriority ? null : (priority ?? this.priority),
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      dueDateFrom: clearDueDateFrom ? null : (dueDateFrom ?? this.dueDateFrom),
      dueDateTo: clearDueDateTo ? null : (dueDateTo ?? this.dueDateTo),
      showCompleted: showCompleted ?? this.showCompleted,
      showPending: showPending ?? this.showPending,
      showInProgress: showInProgress ?? this.showInProgress,
    );
  }
}

extension TaskStateCopyWith on TaskState {
  TaskState copyWith({
    List<TaskEntity>? tasks,
    List<TaskEntity>? filteredTasks,
    Set<String>? selectedTaskIds,
    bool? isLoading,
    bool? isSyncing,
    String? errorMessage,
    String? errorCode,
    DateTime? lastSyncTime,
    TaskFilter? currentFilter,
    bool? hasReachedMax,
    int? totalCount,
    bool clearError = false,
  }) {
    if (this is TaskInitial) {
      return TaskLoaded(
        tasks: tasks ?? const [],
        filteredTasks: filteredTasks ?? const [],
        selectedTaskIds: selectedTaskIds ?? const {},
        isLoading: isLoading ?? false,
        isSyncing: isSyncing ?? false,
        lastSyncTime: lastSyncTime,
        currentFilter: currentFilter ?? const TaskFilter(),
        hasReachedMax: hasReachedMax ?? false,
        totalCount: totalCount ?? 0,
      );
    }
    if (this is TaskLoading) {
      return TaskLoading(
        tasks: tasks ?? this.tasks,
        filteredTasks: filteredTasks ?? this.filteredTasks,
        selectedTaskIds: selectedTaskIds ?? this.selectedTaskIds,
        currentFilter: currentFilter ?? this.currentFilter,
      );
    }
    if (this is TaskLoaded) {
      return TaskLoaded(
        tasks: tasks ?? this.tasks,
        filteredTasks: filteredTasks ?? this.filteredTasks,
        selectedTaskIds: selectedTaskIds ?? this.selectedTaskIds,
        isLoading: isLoading ?? this.isLoading,
        isSyncing: isSyncing ?? this.isSyncing,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
        errorCode: clearError ? null : (errorCode ?? this.errorCode),
        lastSyncTime: lastSyncTime ?? this.lastSyncTime,
        currentFilter: currentFilter ?? this.currentFilter,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        totalCount: totalCount ?? this.totalCount,
      );
    }
    if (this is TaskOperationSuccess) {
      return TaskOperationSuccess(
        operation: (this as TaskOperationSuccess).operation,
        tasks: tasks ?? this.tasks,
        filteredTasks: filteredTasks ?? this.filteredTasks,
        selectedTaskIds: selectedTaskIds ?? this.selectedTaskIds,
        isLoading: isLoading ?? this.isLoading,
        isSyncing: isSyncing ?? this.isSyncing,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
        errorCode: clearError ? null : (errorCode ?? this.errorCode),
        lastSyncTime: lastSyncTime ?? this.lastSyncTime,
        currentFilter: currentFilter ?? this.currentFilter,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        totalCount: totalCount ?? this.totalCount,
      );
    }
    return TaskError(
      message: errorMessage ?? this.errorMessage ?? 'Unknown error',
      code: errorCode ?? this.errorCode,
      tasks: tasks ?? this.tasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      selectedTaskIds: selectedTaskIds ?? this.selectedTaskIds,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }
}