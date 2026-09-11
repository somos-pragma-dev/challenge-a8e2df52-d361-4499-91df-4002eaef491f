package credit_field_app.presentation.viewmodels;

import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:credit_field_app/core/error/failures.dart';
import 'package:credit_field_app/core/network/connectivity_service.dart';
import 'package:credit_field_app/domain/entities/sync_status.dart';
import 'package:credit_field_app/sync/services/sync_coordinator.dart';

part 'sync_viewmodel_event.dart';
part 'sync_viewmodel_state.dart';

class SyncViewModel extends Bloc<SyncViewModelEvent, SyncViewModelState> {
  final SyncCoordinator _syncCoordinator;
  final ConnectivityService _connectivityService;
  StreamSubscription<ConnectivityStatus>? _connectivitySubscription;
  Timer? _periodicSyncTimer;

  SyncViewModel({
    required SyncCoordinator syncCoordinator,
    required ConnectivityService connectivityService,
  })  : _syncCoordinator = syncCoordinator,
        _connectivityService = connectivityService,
        super(const SyncViewModelState()) {
    on<StartSync>(_onStartSync);
    on<StopSync>(_onStopSync);
    on<CheckSyncStatus>(_onCheckSyncStatus);
    on<ResolveConflict>(_onResolveConflict);
    on<SyncConnectivityChanged>(_onConnectivityChanged);
    on<StartPeriodicSync>(_onStartPeriodicSync);
    on<StopPeriodicSync>(_onStopPeriodicSync);
    on<ForceSyncAll>(_onForceSyncAll);
    on<ClearSyncHistory>(_onClearSyncHistory);

    _connectivitySubscription = _connectivityService.statusStream.listen(
      (status) => add(SyncConnectivityChanged(status)),
    );

    _initializeSync();
  }

  Future<void> _initializeSync() async {
    final status = await _connectivityService.checkConnectivity();
    final isOnline = status.isConnected;
    
    add(const CheckSyncStatus());
    
    if (isOnline) {
      add(const StartSync());
    }
  }

  Future<void> _onStartSync(
    StartSync event,
    Emitter<SyncViewModelState> emit,
  ) async {
    if (state.isSyncing) return;
    
    emit(state.copyWith(
      status: SyncViewModelStatus.syncing,
      isSyncing: true,
    ));

    try {
      final result = await _syncCoordinator.syncPendingChanges();
      
      result.fold(
        (failure) => emit(state.copyWith(
          status: SyncViewModelStatus.error,
          isSyncing: false,
          errorMessage: failure.message,
          lastError: failure,
        )),
        (syncResult) {
          final conflicts = syncResult.conflicts;
          final syncedCount = syncResult.syncedCount;
          final failedCount = syncResult.failedCount;

          if (conflicts.isNotEmpty) {
            emit(state.copyWith(
              status: SyncViewModelStatus.conflictDetected,
              isSyncing: false,
              pendingConflicts: conflicts,
              lastSyncResult: syncResult,
            ));
          } else {
            emit(state.copyWith(
              status: SyncViewModelStatus.synced,
              isSyncing: false,
              syncedCount: syncedCount,
              failedCount: failedCount,
              lastSyncResult: syncResult,
              lastSyncTime: DateTime.now(),
            ));
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: SyncViewModelStatus.error,
        isSyncing: false,
        errorMessage: 'Error inesperado durante la sincronización: $e',
      ));
    }
  }

  Future<void> _onStopSync(
    StopSync event,
    Emitter<SyncViewModelState> emit,
  ) async {
    await _syncCoordinator.cancelSync();
    emit(state.copyWith(
      status: SyncViewModelStatus.idle,
      isSyncing: false,
    ));
  }

  Future<void> _onCheckSyncStatus(
    CheckSyncStatus event,
    Emitter<SyncViewModelState> emit,
  ) async {
    emit(state.copyWith(status: SyncViewModelStatus.checking));

    try {
      final pendingItems = await _syncCoordinator.getPendingItemsCount();
      final conflicts = await _syncCoordinator.getConflicts();
      final lastSync = await _syncCoordinator.getLastSyncTime();

      emit(state.copyWith(
        status: SyncViewModelStatus.idle,
        pendingItemsCount: pendingItems,
        pendingConflicts: conflicts,
        lastSyncTime: lastSync,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SyncViewModelStatus.error,
        errorMessage: 'Error al verificar estado de sincronización: $e',
      ));
    }
  }

  Future<void> _onResolveConflict(
    ResolveConflict event,
    Emitter<SyncViewModelState> emit,
  ) async {
    emit(state.copyWith(
      status: SyncViewModelStatus.resolving,
      isResolvingConflict: true,
    ));

    try {
      final result = await _syncCoordinator.resolveConflict(
        event.conflictId,
        event.resolution,
      );

      result.fold(
        (failure) => emit(state.copyWith(
          status: SyncViewModelStatus.error,
          isResolvingConflict: false,
          errorMessage: failure.message,
        )),
        (resolved) {
          final updatedConflicts = state.pendingConflicts
              .where((c) => c.id != event.conflictId)
              .toList();

          emit(state.copyWith(
            status: updatedConflicts.isEmpty
                ? SyncViewModelStatus.synced
                : SyncViewModelStatus.conflictDetected,
            isResolvingConflict: false,
            pendingConflicts: updatedConflicts,
            lastConflictResolution: result,
          ));

          if (state.isOnline && updatedConflicts.isEmpty) {
            add(const StartSync());
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(
        status: SyncViewModelStatus.error,
        isResolvingConflict: false,
        errorMessage: 'Error al resolver conflicto: $e',
      ));
    }
  }

  void _onConnectivityChanged(
    SyncConnectivityChanged event,
    Emitter<SyncViewModelState> emit,
  ) {
    final isOnline = event.status.isConnected;
    emit(state.copyWith(isOnline: isOnline));

    if (isOnline && state.pendingItemsCount > 0 && !state.isSyncing) {
      add(const StartSync());
    }
  }

  void _onStartPeriodicSync(
    StartPeriodicSync event,
    Emitter<SyncViewModelState> emit,
  ) {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = Timer.periodic(
      event.interval,
      (_) => add(const StartSync()),
    );
    emit(state.copyWith(isPeriodicSyncEnabled: true));
  }

  void _onStopPeriodicSync(
    StopPeriodicSync event,
    Emitter<SyncViewModelState> emit,
  ) {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = null;
    emit(state.copyWith(isPeriodicSyncEnabled: false));
  }

  Future<void> _onForceSyncAll(
    ForceSyncAll event,
    Emitter<SyncViewModelState> emit,
  ) async {
    if (!state.isOnline) {
      emit(state.copyWith(
        status: SyncViewModelStatus.error,
        errorMessage: 'No hay conexión para sincronización',
      ));
      return;
    }

    emit(state.copyWith(
      status: SyncViewModelStatus.syncing,
      isSyncing: true,
    ));

    try {
      final result = await _syncCoordinator.forceSyncAll();
      
      result.fold(
        (failure) => emit(state.copyWith(
          status: SyncViewModelStatus.error,
          isSyncing: false,
          errorMessage: failure.message,
        )),
        (syncResult) => emit(state.copyWith(
          status: SyncViewModelStatus.synced,
          isSyncing: false,
          syncedCount: syncResult.syncedCount,
          failedCount: syncResult.failedCount,
          lastSyncTime: DateTime.now(),
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        status: SyncViewModelStatus.error,
        isSyncing: false,
        errorMessage: 'Error en sincronización forzada: $e',
      ));
    }
  }

  Future<void> _onClearSyncHistory(
    ClearSyncHistory event,
    Emitter<SyncViewModelState> emit,
  ) async {
    await _syncCoordinator.clearSyncHistory();
    emit(state.copyWith(
      syncedCount: 0,
      failedCount: 0,
      pendingItemsCount: 0,
      pendingConflicts: [],
    ));
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _periodicSyncTimer?.cancel();
    return super.close();
  }
}