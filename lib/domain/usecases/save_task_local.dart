import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../entities/task_entity.dart';

abstract class SaveTaskLocal extends Equatable {
  const SaveTaskLocal();

  Future<Either<Failure, SaveTaskResult>> call(SaveTaskParams params);
}

class SaveTaskParams extends Equatable {
  final TaskEntity task;
  final bool markForSync;
  final bool validateBeforeSave;

  const SaveTaskParams({
    required this.task,
    this.markForSync = true,
    this.validateBeforeSave = true,
  });

  @override
  List<Object?> get props => [task, markForSync, validateBeforeSave];
}

class SaveTaskResult extends Equatable {
  final bool success;
  final String taskId;
  final bool wasCreated;
  final bool wasUpdated;
  final bool markedForSync;
  final DateTime savedAt;
  final String? errorMessage;

  const SaveTaskResult({
    required this.success,
    required this.taskId,
    required this.wasCreated,
    required this.wasUpdated,
    required this.markedForSync,
    required this.savedAt,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        success,
        taskId,
        wasCreated,
        wasUpdated,
        markedForSync,
        savedAt,
        errorMessage,
      ];
}

class SaveTaskLocalImpl implements SaveTaskLocal {
  final TaskRepository _taskRepository;

  const SaveTaskLocalImpl(this._taskRepository);

  @override
  Future<Either<Failure, SaveTaskResult>> call(
    SaveTaskParams params,
  ) async {
    if (params.validateBeforeSave) {
      final validationResult = _validateTask(params.task);
      if (validationResult != null) {
        return Left(validationResult);
      }
    }

    final existingTaskResult = await _taskRepository.getLocalTaskById(
      params.task.id,
    );

    final isUpdate = existingTaskResult.isRight() &&
        existingTaskResult.fold((_) => false, (_) => true);

    final saveResult = isUpdate
        ? await _taskRepository.updateLocalTask(params.task)
        : await _taskRepository.saveLocalTask(params.task);

    return saveResult.fold(
      (failure) => Left(failure),
      (_) async {
        if (params.markForSync && !params.task.isSynced) {
          return Right<Failure, SaveTaskResult>(SaveTaskResult(
            success: true,
            taskId: params.task.id,
            wasCreated: !isUpdate,
            wasUpdated: isUpdate,
            markedForSync: true,
            savedAt: DateTime.now(),
          ));
        }

        return Right<Failure, SaveTaskResult>(SaveTaskResult(
          success: true,
          taskId: params.task.id,
          wasCreated: !isUpdate,
          wasUpdated: isUpdate,
          markedForSync: false,
          savedAt: DateTime.now(),
        ));
      },
    );
  }

  Failure? _validateTask(TaskEntity task) {
    if (task.title.isEmpty) {
      return const ValidationFailure(
        message: 'El título de la tarea no puede estar vacío',
        fieldErrors: {'title': ['El título es requerido']},
      );
    }

    if (task.title.length > 200) {
      return const ValidationFailure(
        message: 'El título excede la longitud máxima permitida',
        fieldErrors: {'title': ['El título no puede exceder 200 caracteres']},
      );
    }

    if (task.description != null && task.description!.length > 2000) {
      return const ValidationFailure(
        message: 'La descripción excede la longitud máxima permitida',
        fieldErrors: {
          'description': ['La descripción no puede exceder 2000 caracteres']
        },
      );
    }

    return null;
  }
}