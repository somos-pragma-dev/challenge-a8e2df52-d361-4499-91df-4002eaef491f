package offline_field_app.core.sync;

import 'dart:async';
import 'package:equatable/equatable.dart';

enum SyncStrategy {
  optimistic,
  pessimistic,
}

enum SyncOperationStatus {
  pending,
  inProgress,
  completed,
  failed,
  conflict,
}

class SyncOperation extends Equatable {
  final String id;
  final String entityType;
  final String entityId;
  final String operationType;
  final Map<String, dynamic> payload;
  final SyncOperationStatus status;
  final DateTime createdAt;
  final DateTime? executedAt;
  final int retryCount;
  final String? errorMessage;
  final int priority;

  const SyncOperation({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operationType,
    required this.payload,
    required this.status,
    required this.createdAt,
    this.executedAt,
    this.retryCount = 0,
    this.errorMessage,
    this.priority = 0,
  });

  SyncOperation copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? operationType,
    Map<String, dynamic>? payload,
    SyncOperationStatus? status,
    DateTime? createdAt,
    DateTime? executedAt,
    int? retryCount,
    String? errorMessage,
    int? priority,
  }) {
    return SyncOperation(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operationType: operationType ?? this.operationType,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      executedAt: executedAt ?? this.executedAt,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
      priority: priority ?? this.priority,
    );
  }

  @override
  List<Object?> get props => [
        id,
        entityType,
        entityId,
        operationType,
        payload,
        status,
        createdAt,
        executedAt,
        retryCount,
        errorMessage,
        priority,
      ];
}

class SyncQueue extends Equatable {
  final List<SyncOperation> operations;
  final int maxSize;

  const SyncQueue({
    required this.operations,
    this.maxSize = 1000,
  });

  factory SyncQueue.empty({int maxSize = 1000}) => SyncQueue(
        operations: const [],
        maxSize: maxSize,
      );

  bool get isEmpty => operations.isEmpty;
  bool get isNotEmpty => operations.isNotEmpty;
  int get length => operations.length;

  SyncQueue addOperation(SyncOperation operation) {
    if (operations.length >= maxSize) {
      throw StateError('Sync queue is full');
    }
    final updatedOps = [...operations, operation];
    updatedOps.sort((a, b) => b.priority.compareTo(a.priority));
    return SyncQueue(operations: updatedOps, maxSize: maxSize);
  }

  SyncQueue removeOperation(String operationId) {
    return SyncQueue(
      operations: operations.where((op) => op.id != operationId).toList(),
      maxSize: maxSize,
    );
  }

  SyncQueue updateOperation(SyncOperation operation) {
    return SyncQueue(
      operations: operations
          .map((op) => op.id == operation.id ? operation : op)
          .toList(),
      maxSize: maxSize,
    );
  }

  SyncOperation? getNextOperation() {
    final pending = operations
        .where((op) => op.status == SyncOperationStatus.pending)
        .toList();
    if (pending.isEmpty) return null;
    return pending.first;
  }

  @override
  List<Object?> get props => [operations, maxSize];
}

abstract class SyncEngine {
  Stream<SyncEngineState> get stateStream;
  SyncEngineState get currentState;
  Future<void> startSync();
  Future<void> stopSync();
  Future<void> enqueueOperation(SyncOperation operation);
  Future<void> processQueue();
  void setStrategy(SyncStrategy strategy);
  void dispose();
}

class SyncEngineState extends Equatable {
  final bool isRunning;
  final bool isPaused;
  final SyncStrategy strategy;
  final SyncQueue queue;
  final int processedCount;
  final int failedCount;
  final int conflictCount;
  final DateTime? lastSyncAt;
  final String? currentOperationId;
  final String? errorMessage;

  const SyncEngineState({
    required this.isRunning,
    required this.isPaused,
    required this.strategy,
    required this.queue,
    required this.processedCount,
    required this.failedCount,
    required this.conflictCount,
    this.lastSyncAt,
    this.currentOperationId,
    this.errorMessage,
  });

  factory SyncEngineState.initial() => SyncEngineState(
        isRunning: false,
        isPaused: false,
        strategy: SyncStrategy.optimistic,
        queue: SyncQueue.empty(),
        processedCount: 0,
        failedCount: 0,
        conflictCount: 0,
      );

  double get successRate {
    final total = processedCount + failedCount;
    if (total == 0) return 0.0;
    return processedCount / total;
  }

  @override
  List<Object?> get props => [
        isRunning,
        isPaused,
        strategy,
        queue,
        processedCount,
        failedCount,
        conflictCount,
        lastSyncAt,
        currentOperationId,
        errorMessage,
      ];
}

class SyncEngineImpl implements SyncEngine {
  final SyncStrategy _defaultStrategy;
  final int maxRetries;
  final Duration retryDelay;
  final Duration batchInterval;

  SyncEngineState _state;
  final StreamController<SyncEngineState> _stateController;
  Timer? _syncTimer;
  Timer? _retryTimer;
  bool _isDisposed = false;

  final Future<Map<String, dynamic> Function(SyncOperation)> _operationExecutor;
  final Future<Map<String, dynamic>?> Function(SyncOperation) _conflictHandler;
  final Future<void> Function(SyncOperation) _onOperationSuccess;
  final Future<void> Function(SyncOperation, String) _onOperationFailure;

  SyncEngineImpl({
    SyncStrategy defaultStrategy = SyncStrategy.optimistic,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 5),
    this.batchInterval = const Duration(seconds: 30),
    required Future<Map<String, dynamic> Function(SyncOperation)> operationExecutor,
    required Future<Map<String, dynamic>?> Function(SyncOperation) conflictHandler,
    Future<void> Function(SyncOperation)? onOperationSuccess,
    Future<void> Function(SyncOperation, String)? onOperationFailure,
  })  : _defaultStrategy = defaultStrategy,
        _operationExecutor = operationExecutor,
        _conflictHandler = conflictHandler,
        _onOperationSuccess = onOperationSuccess ?? (_) async {},
        _onOperationFailure = onOperationFailure ?? (_, __) async {},
        _state = SyncEngineState.initial(),
        _stateController = StreamController<SyncEngineState>.broadcast() {
    _state = _state.copyWith(strategy: defaultStrategy);
  }

  @override
  Stream<SyncEngineState> get stateStream => _stateController.stream;

  @override
  SyncEngineState get currentState => _state;

  void _emitState(SyncEngineState newState) {
    if (_isDisposed || _stateController.isClosed) return;
    _state = newState;
    _stateController.add(_state);
  }

  @override
  Future<void> startSync() async {
    if (_state.isRunning || _isDisposed) return;

    _emitState(_state.copyWith(
      isRunning: true,
      isPaused: false,
      errorMessage: null,
    ));

    _syncTimer = Timer.periodic(batchInterval, (_) {
      if (!_state.isPaused && _state.queue.isNotEmpty) {
        processQueue();
      }
    });

    await processQueue();
  }

  @override
  Future<void> stopSync() async {
    _syncTimer?.cancel();
    _retryTimer?.cancel();

    if (_isDisposed) return;

    _emitState(_state.copyWith(
      isRunning: false,
      isPaused: true,
    ));
  }

  @override
  Future<void> enqueueOperation(SyncOperation operation) async {
    if (_isDisposed) return;

    final updatedQueue = _state.queue.addOperation(operation);
    _emitState(_state.copyWith(queue: updatedQueue));

    if (_state.isRunning && !_state.isPaused) {
      await processQueue();
    }
  }

  @override
  Future<void> processQueue() async {
    if (_isDisposed || !_state.isRunning || _state.isPaused) return;

    while (_state.queue.isNotEmpty) {
      final operation = _state.queue.getNextOperation();
      if (operation == null) break;

      _emitState(_state.copyWith(currentOperationId: operation.id));

      try {
        await _executeOperation(operation);
      } catch (e) {
        await _handleOperationError(operation, e.toString());
      }

      if (_isDisposed) break;
    }

    _emitState(_state.copyWith(currentOperationId: null));
  }

  Future<void> _executeOperation(SyncOperation operation) async {
    final inProgressOp = operation.copyWith(
      status: SyncOperationStatus.inProgress,
      executedAt: DateTime.now(),
    );

    var queue = _state.queue.updateOperation(inProgressOp);
    _emitState(_state.copyWith(queue: queue));

    try {
      final result = await _operationExecutor(operation);

      if (result.containsKey('conflict')) {
        await _handleConflict(operation, result);
        return;
      }

      queue = _state.queue.removeOperation(operation.id);
      _emitState(_state.copyWith(
        queue: queue,
        processedCount: _state.processedCount + 1,
        lastSyncAt: DateTime.now(),
      ));

      await _onOperationSuccess(operation);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _handleConflict(
    SyncOperation operation,
    Map<String, dynamic> result,
  ) async {
    final conflictData = result['conflict'] as Map<String, dynamic>;
    final resolution = await _conflictHandler(operation);

    if (resolution != null) {
      final resolvedOp = operation.copyWith(
        payload: {...operation.payload, ...resolution},
        status: SyncOperationStatus.pending,
        retryCount: 0,
      );
      final queue = _state.queue.updateOperation(resolvedOp);
      _emitState(_state.copyWith(queue: queue));
    } else {
      final conflictOp = operation.copyWith(
        status: SyncOperationStatus.conflict,
        errorMessage: 'Conflict detected and not resolved',
      );
      final queue = _state.queue.updateOperation(conflictOp);
      _emitState(_state.copyWith(
        queue: queue,
        conflictCount: _state.conflictCount + 1,
      ));
    }
  }

  Future<void> _handleOperationError(
    SyncOperation operation,
    String error,
  ) async {
    if (operation.retryCount < maxRetries) {
      final retryOp = operation.copyWith(
        status: SyncOperationStatus.pending,
        retryCount: operation.retryCount + 1,
        errorMessage: error,
      );
      final queue = _state.queue.updateOperation(retryOp);
      _emitState(_state.copyWith(queue: queue));

      _retryTimer = Timer(retryDelay, () {
        if (_state.isRunning && !_state.isPaused) {
          processQueue();
        }
      });
    } else {
      final failedOp = operation.copyWith(
        status: SyncOperationStatus.failed,
        errorMessage: error,
      );
      final queue = _state.queue.updateOperation(failedOp);
      _emitState(_state.copyWith(
        queue: queue,
        failedCount: _state.failedCount + 1,
        errorMessage: error,
      ));

      await _onOperationFailure(operation, error);
    }
  }

  @override
  void setStrategy(SyncStrategy strategy) {
    if (_isDisposed) return;
    _emitState(_state.copyWith(strategy: strategy));
  }

  @override
  void dispose() {
    _isDisposed = true;
    _syncTimer?.cancel();
    _retryTimer?.cancel();
    if (!_stateController.isClosed) {
      _stateController.close();
    }
  }
}