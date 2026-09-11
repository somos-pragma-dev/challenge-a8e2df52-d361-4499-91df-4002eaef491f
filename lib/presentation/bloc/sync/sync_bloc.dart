import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../core/network/network_info.dart';
import '../../../core/errors/failures.dart';
import '../../../domain/usecases/sync_tasks.dart';
import '../../../domain/usecases/resolve_conflict.dart';
import '../../../domain/repositories/sync_repository.dart';
import '../../../domain/entities/sync_status_entity.dart';
import '../../../core/constants/app_constants.dart';
import 'sync_event.dart';
import 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final NetworkInfo networkInfo;
  final SyncTasks syncTasksUseCase;
  final ResolveConflict resolveConflictUseCase;
  final SyncRepository syncRepository;

  StreamSubscription<bool>? _connectivitySubscription;
  Timer? _retryTimer;
  Timer? _periodicSyncTimer;
  int _retryCount = 0;
  DateTime? _lastSyncTime;

  SyncBloc({
    required this.networkInfo,
    required this.syncTasksUseCase,
    required this.resolveConflictUseCase,
    required this.syncRepository,
  }) : super(const SyncInitial()) {
    on<SyncStatusCheckEvent>(_onSyncStatusCheck);
    on<ConnectionChangedEvent>(_onConnectionChanged);
    on<SyncRequestedEvent>(_onSyncRequested);
    on<SyncStartedEvent>(_onSyncStarted);
    on<SyncProgressEvent>(_onSyncProgress);
    on<SyncCompletedEvent>(_onSyncCompleted);
    on<SyncFailedEvent>(_onSyncFailed);
    on<ConflictDetectedEvent>(_onConflictDetected);
    on<ConflictResolvedEvent>(_onConflictResolved);
    on<RetrySyncEvent>(_onRetrySync);

    _initializeConnectivityListener();
    _initializePeriodicSync();
  }

  void _initializeConnectivityListener() {
    _connectivitySubscription = networkInfo.onConnectivityChanged.listen(
      (isConnected) {
        add(ConnectionChangedEvent(
          isConnected: isConnected,
          connectionType: isConnected ? 'network' : null,
        ));
      },
    );
  }

  void _initializePeriodicSync() {
    if (AppConstants.enableAutoSync) {
      _periodicSyncTimer = Timer.periodic(
        AppConstants.networkCheckInterval,
        (_) => _checkAndSync(),
      );
    }
  }

  Future<void> _checkAndSync() async {
    final isConnected = await networkInfo.isConnected;
    if (isConnected && AppConstants.enableAutoSync) {
      final pendingCount = await _getPendingChangesCount();
      if (pendingCount > 0) {
        add(const SyncRequestedEvent());
      }
    }
  }

  Future<int> _getPendingChangesCount() async {
    try {
      final pendingItems = await syncRepository.getPendingSyncItems();
      return pendingItems.length;
    } catch (e) {
      return 0;
    }
  }

  Future<void> _onSyncStatusCheck(
    SyncStatusCheckEvent event,
    Emitter<SyncState> emit,
  ) async {
    try {
      final isConnected = await networkInfo.isConnected;
      final pendingCount = await _getPendingChangesCount();

      if (isConnected) {
        final connectivityResult = await networkInfo.connectivityResult;
        emit(SyncOnline(
          connectionType: connectivityResult.name,
          lastSyncTime: _lastSyncTime,
          pendingChangesCount: pendingCount,
        ));
      } else {
        emit(SyncOffline(
          lastSyncTime: _lastSyncTime,
          pendingChangesCount: pendingCount,
        ));
      }
    } catch (e) {
      emit(SyncFailure(
        errorMessage: 'Failed to check sync status: ${e.toString()}',
        isConnected: state.isConnected,
        connectionType: state.connectionType,
        lastSyncTime: _lastSyncTime,
      ));
    }
  }

  Future<void> _onConnectionChanged(
    ConnectionChangedEvent event,
    Emitter<SyncState> emit,
  ) async {
    if (event.isConnected) {
      final pendingCount = await _getPendingChangesCount();
      emit(SyncOnline(
        connectionType: event.connectionType,
        lastSyncTime: _lastSyncTime,
        pendingChangesCount: pendingCount,
      ));

      if (pendingCount > 0 && AppConstants.enableAutoSync) {
        add(const SyncRequestedEvent());
      }
    } else {
      emit(SyncOffline(
        lastSyncTime: _lastSyncTime,
        pendingChangesCount: state.pendingChangesCount,
      ));
    }
  }

  Future<void> _onSyncRequested(
    SyncRequestedEvent event,
    Emitter<SyncState> emit,
  ) async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      emit(SyncOffline(
        lastSyncTime: _lastSyncTime,
        pendingChangesCount: state.pendingChangesCount,
      ));
      return;
    }

    try {
      final pendingCount = await _getPendingChangesCount();
      if (pendingCount == 0) {
        emit(SyncOnline(
          connectionType: state.connectionType,
          lastSyncTime: _lastSyncTime,
          pendingChangesCount: 0,
        ));
        return;
      }

      add(SyncStartedEvent(pendingItemsCount: pendingCount));

      final result = await syncTasksUseCase(
        forceFullSync: event.forceFullSync,
      );

      result.fold(
        (failure) {
          add(SyncFailedEvent(
            errorMessage: failure.userFriendlyMessage,
            errorCode: failure.code,
            retryCount: _retryCount,
            canRetry: failure.isRecoverable,
          ));
        },
        (syncResult) {
          _lastSyncTime = DateTime.now();
          _retryCount = 0;

          add(SyncCompletedEvent(
            syncedItemsCount: syncResult.syncedCount,
            syncDuration: syncResult.duration,
            conflictIds: syncResult.conflictIds,
          ));
        },
      );
    } catch (e) {
      add(SyncFailedEvent(
        errorMessage: 'Sync failed: ${e.toString()}',
        retryCount: _retryCount,
        canRetry: true,
      ));
    }
  }

  Future<void> _onSyncStarted(
    SyncStartedEvent event,
    Emitter<SyncState> emit,
  ) async {
    emit(SyncInProgress(
      isConnected: state.isConnected,
      connectionType: state.connectionType,
      totalItems: event.pendingItemsCount,
      processedItems: 0,
      currentOperation: 'Initializing sync...',
      startTime: DateTime.now(),
      lastSyncTime: _lastSyncTime,
      pendingChangesCount: event.pendingItemsCount,
    ));
  }

  Future<void> _onSyncProgress(
    SyncProgressEvent event,
    Emitter<SyncState> emit,
  ) async {
    if (state is SyncInProgress) {
      final currentState = state as SyncInProgress;
      emit(SyncInProgress(
        isConnected: currentState.isConnected,
        connectionType: currentState.connectionType,
        totalItems: event.totalItems,
        processedItems: event.processedItems,
        currentItemId: event.currentItemId,
        currentOperation: 'Syncing item ${event.processedItems}/${event.totalItems}',
        startTime: currentState.startTime,
        lastSyncTime: _lastSyncTime,
        pendingChangesCount: currentState.pendingChangesCount,
      ));
    }
  }

  Future<void> _onSyncCompleted(
    SyncCompletedEvent event,
    Emitter<SyncState> emit,
  ) async {
    final pendingCount = await _getPendingChangesCount();

    if (event.conflictIds != null && event.conflictIds!.isNotEmpty) {
      emit(SyncCompleted(
        syncedItemsCount: event.syncedItemsCount,
        syncDuration: event.syncDuration,
        conflictIds: event.conflictIds,
        lastSyncTime: _lastSyncTime,
        pendingChangesCount: pendingCount,
      ));
    } else {
      emit(SyncCompleted(
        syncedItemsCount: event.syncedItemsCount,
        syncDuration: event.syncDuration,
        lastSyncTime: _lastSyncTime,
        pendingChangesCount: pendingCount,
      ));
    }
  }

  Future<void> _onSyncFailed(
    SyncFailedEvent event,
    Emitter<SyncState> emit,
  ) async {
    _retryCount = event.retryCount;

    if (event.canRetry && _retryCount < AppConstants.maxRetryAttempts) {
      final nextRetry = DateTime.now().add(
        Duration(milliseconds: AppConstants.retryDelayMilliseconds),
      );

      emit(SyncWaitingForRetry(
        nextRetryAt: nextRetry,
        currentRetryCount: _retryCount,
        lastError: event.errorMessage,
        isConnected: state.isConnected,
        connectionType: state.connectionType,
        lastSyncTime: _lastSyncTime,
        pendingChangesCount: state.pendingChangesCount,
      ));

      _scheduleRetry(nextRetry);
    } else {
      emit(SyncFailure(
        errorMessage: event.errorMessage,
        errorCode: event.errorCode,
        retryCount: _retryCount,
        canRetry: false,
        isConnected: state.isConnected,
        connectionType: state.connectionType,
        lastSyncTime: _lastSyncTime,
        pendingChangesCount: state.pendingChangesCount,
      ));
    }
  }

  void _scheduleRetry(DateTime nextRetryAt) {
    _retryTimer?.cancel();
    final delay = nextRetryAt.difference(DateTime.now());
    if (delay.isNegative) {
      add(const RetrySyncEvent());
      return;
    }

    _retryTimer = Timer(delay, () {
      add(const RetrySyncEvent());
    });
  }

  Future<void> _onRetrySync(
    RetrySyncEvent event,
    Emitter<SyncState> emit,
  ) async {
    add(SyncRequestedEvent(forceFullSync: false));
  }

  Future<void> _onConflictDetected(
    ConflictDetectedEvent event,
    Emitter<SyncState> emit,
  ) async {
    try {
      final pendingItems = await syncRepository.getPendingSyncItems();

      emit(SyncConflict(
        entityId: event.entityId,
        entityType: event.entityType,
        localVersion: event.localVersion,
        remoteVersion: event.remoteVersion,
        conflictType: event.conflictType,
        pendingSyncItems: pendingItems,
        isConnected: state.isConnected,
        connectionType: state.connectionType,
        lastSyncTime: _lastSyncTime,
        pendingChangesCount: state.pendingChangesCount,
      ));
    } catch (e) {
      emit(SyncFailure(
        errorMessage: 'Failed to handle conflict: ${e.toString()}',
        isConnected: state.isConnected,
        connectionType: state.connectionType,
        lastSyncTime: _lastSyncTime,
        pendingChangesCount: state.pendingChangesCount,
      ));
    }
  }

  Future<void> _onConflictResolved(
    ConflictResolvedEvent event,
    Emitter<SyncState> emit,
  ) async {
    try {
      await resolveConflictUseCase(
        entityId: event.entityId,
        resolutionStrategy: event.resolutionStrategy,
        resolvedData: event.resolvedVersion,
      );

      final pendingCount = await _getPendingChangesCount();

      if (state.isConnected) {
        emit(SyncOnline(
          connectionType: state.connectionType,
          lastSyncTime: _lastSyncTime,
          pendingChangesCount: pendingCount,
        ));
      } else {
        emit(SyncOffline(
          lastSyncTime: _lastSyncTime,
          pendingChangesCount: pendingCount,
        ));
      }
    } catch (e) {
      emit(SyncFailure(
        errorMessage: 'Failed to resolve conflict: ${e.toString()}',
        isConnected: state.isConnected,
        connectionType: state.connectionType,
        lastSyncTime: _lastSyncTime,
        pendingChangesCount: state.pendingChangesCount,
      ));
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _retryTimer?.cancel();
    _periodicSyncTimer?.cancel();
    return super.close();
  }
}