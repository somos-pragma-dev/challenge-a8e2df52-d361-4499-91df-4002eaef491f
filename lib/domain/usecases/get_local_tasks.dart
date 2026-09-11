import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../entities/task_entity.dart';

abstract class GetLocalTasks extends Equatable {
  const GetLocalTasks();

  Future<Either<Failure, List<TaskEntity>>> call({
    GetLocalTasksParams? params,
  });
}

class GetLocalTasksParams extends Equatable {
  final TaskFilter? filter;
  final TaskSortOptions? sortBy;
  final bool ascending;
  final int? limit;
  final int? offset;

  const GetLocalTasksParams({
    this.filter,
    this.sortBy,
    this.ascending = true,
    this.limit,
    this.offset,
  });

  @override
  List<Object?> get props => [filter, sortBy, ascending, limit, offset];
}

enum TaskFilter {
  all,
  pending,
  inProgress,
  completed,
  cancelled,
  failed,
  synced,
  notSynced,
  hasConflict,
}

enum TaskSortOptions {
  createdAt,
  updatedAt,
  priority,
  status,
  dueDate,
  title,
}

class GetLocalTasksImpl implements GetLocalTasks {
  final TaskRepository _taskRepository;

  const GetLocalTasksImpl(this._taskRepository);

  @override
  Future<Either<Failure, List<TaskEntity>>> call({
    GetLocalTasksParams? params,
  }) async {
    final effectiveParams = params ?? const GetLocalTasksParams();

    final result = await _taskRepository.getLocalTasks(
      filter: effectiveParams.filter,
      sortBy: effectiveParams.sortBy,
      ascending: effectiveParams.ascending,
      limit: effectiveParams.limit,
      offset: effectiveParams.offset,
    );

    return result.fold(
      (failure) => Left(failure),
      (tasks) {
        if (tasks.isEmpty) {
          return const Right<Failure, List<TaskEntity>>([]);
        }
        return Right<Failure, List<TaskEntity>>(tasks);
      },
    );
  }
}

abstract class TaskRepository extends Equatable {
  const TaskRepository();

  Future<Either<Failure, List<TaskEntity>>> getLocalTasks({
    TaskFilter? filter,
    TaskSortOptions? sortBy,
    bool ascending = true,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, TaskEntity>> getLocalTaskById(String id);

  Future<Either<Failure, void>> saveLocalTask(TaskEntity task);

  Future<Either<Failure, void>> updateLocalTask(TaskEntity task);

  Future<Either<Failure, void>> deleteLocalTask(String id);

  Future<Either<Failure, List<TaskEntity>>> getUnsyncedTasks();

  Future<Either<Failure, void>> markTaskAsSynced(String id);

  Future<Either<Failure, void>> markTaskAsFailed(String id, String error);

  Future<Either<Failure, int>> getPendingSyncCount();

  Future<Either<Failure, void>> clearAllLocalTasks();
}