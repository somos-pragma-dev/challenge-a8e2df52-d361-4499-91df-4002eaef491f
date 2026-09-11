library sync_handler;

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/config/app_config.dart';
import '../../core/error/failures.dart';
import '../../core/network/connectivity_service.dart';
import '../services/conflict_resolver.dart';
import '../services/sync_coordinator.dart';

enum SyncEventType {
  connectivityChanged,
  syncRequested,
  syncCompleted,
  syncFailed,
  conflictDetected,
  backgroundSync,
}

class SyncEvent extends Equatable {
  final SyncEventType type;
  final DateTime timestamp;
  final Map<String, dynamic>? data;

  const SyncEvent({
    required this.type,
    required this.timestamp,
    this.data,
  });

  @override
  List<Object?> get props => [type, timestamp, data];
}

class SyncHandlerState extends Equatable {
  final bool isOnline;
  final bool isSyncing;
  final bool hasPendingChanges;
  final bool hasConflicts;
  final int pendingCount;
  final int conflictCount;
  final DateTime? lastSyncTime;
  final String? lastError;

  const SyncHandlerState({
    this.isOnline = false,
    this.isSyncing = false,
    this.hasPendingChanges = false,
    this.hasConflicts = false,
    this.pendingCount = 0,
    this.conflictCount = 0,
    this.lastSyncTime,
    this.lastError,
  });

  SyncHandlerState copyWith({
    bool? isOnline,
    bool? isSyncing,
    bool? hasPendingChanges,
    bool? hasConflicts,
    int? pendingCount,
    int? conflictCount,
    DateTime? lastSyncTime,
    String? lastError,
  }) {
    return SyncHandlerState(
      isOnline: isOnline ?? this.isOnline,
      isSyncing: isSyncing ?? this.isSyncing,
      hasPendingChanges: hasPendingChanges ?? this.hasPendingChanges,
      hasConflicts: hasConflicts ?? this.hasConflicts,
      pendingCount: pendingCount ?? this.pendingCount,
      conflictCount: conflictCount ?? this.conflictCount,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      lastError: lastError,
    );
  }

  @override
  List<Object?> get props => [
        isOnline,
        isSyncing,
        hasPendingChanges,
        hasConflicts,
        pendingCount,
        conflictCount,
        lastSyncTime,
        lastError,
      ];
}

class SyncHandler {
  final SyncCoordinator syncCoordinator;
  final ConflictResolver conflictResolver;
  final ConnectivityService connectivityService;
  final AppConfig config;

  final _eventController = StreamController<SyncEvent>.broadcast();
  final _stateController = StreamController<SyncHandlerState>.broadcast();
  
  Timer? _periodicSyncTimer;
  StreamSubscription? _connectivitySubscription;
  SyncHandlerState _currentState = const SyncHandlerState();

  SyncHandler({
    required this.syncCoordinator,
    required this.conflictResolver,
    required this.connectivityService,
    required this.config,
  }) {
    _init();
  }

  void _init() {
    _connectivitySubscription = connectivityService.statusStream.listen(
      _onConnectivityChanged,
    );
  }

  Stream<SyncEvent> get eventStream => _eventController.stream;
  Stream<SyncHandlerState> get stateStream => _stateController.stream;
  SyncHandlerState get currentState => _currentState;

  void _onConnectivityChanged(ConnectivityStatus status) {
    final wasOffline = !_currentState.isOnline;
    final isNowOnline = status.isConnected;
    
    _updateState(_currentState.copyWith(
      isOnline: isNowOnline,
    ));

    _eventController.add(SyncEvent(
      type: SyncEventType.connectivityChanged,
      timestamp: DateTime.now(),
      data: {
        'wasOffline': wasOffline,
        'isOnline': isNowOnline,
      },
    ));

    if (wasOffline && isNowOnline && _currentState.hasPendingChanges) {
      _triggerAutoSync();
    }
  }

  void _updateState(SyncHandlerState newState) {
    _currentState = newState;
    _stateController.add(_currentState);
  }

  void startPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = Timer.periodic(
      config.syncInterval,
      (_) => _triggerAutoSync(),
    );
  }

  void stopPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = null;
  }

  Future<void> _triggerAutoSync() async {
    if (_currentState.isSyncing || !_currentState.isOnline) {
      return;
    }

    await handleSyncRequested();
  }

  Future<Either<Failure, void>> handleSyncRequested() async {
    if (_currentState.isSyncing) {
      return const Left(SyncFailure(
        message: 'Sincronización ya en progreso',
      ));
    }

    if (!_currentState.isOnline) {
      return Left(NetworkFailure.noConnection());
    }

    _updateState(_currentState.copyWith(
      isSyncing: true,
      lastError: null,
    ));

    _eventController.add(SyncEvent(
      type: SyncEventType.syncRequested,
      timestamp: DateTime.now(),
    ));

    try {
      final conflictsResult = await conflictResolver.detectConflicts();
      
      await conflictsResult.fold(
        (failure) async {},
        (conflicts) async {
          if (conflicts.isNotEmpty) {
            _updateState(_currentState.copyWith(
              hasConflicts: true,
              conflictCount: conflicts.length,
            ));

            _eventController.add(SyncEvent(
              type: SyncEventType.conflictDetected,
              timestamp: DateTime.now(),
              data: {
                'count': conflicts.length,
                'conflicts': conflicts,
              },
            ));

            await conflictResolver.resolveAllConflicts(
              ConflictStrategy.serverWins,
            );
          }
        },
      );

      final result = await syncCoordinator.executeFullSync();
      
      return result.fold(
        (failure) {
          _updateState(_currentState.copyWith(
            isSyncing: false,
            lastError: failure.message,
          ));

          _eventController.add(SyncEvent(
            type: SyncEventType.syncFailed,
            timestamp: DateTime.now(),
            data: {'error': failure.message},
          ));

          return Left(failure);
        },
        (syncResult) {
          _updateState(_currentState.copyWith(
            isSyncing: false,
            hasPendingChanges: syncResult.uploadedClients > 0 || 
                               syncResult.uploadedApplications > 0,
            pendingCount: 0,
            hasConflicts: syncResult.hasConflicts,
            conflictCount: syncResult.conflictsResolved,
            lastSyncTime: DateTime.now(),
          ));

          _eventController.add(SyncEvent(
            type: SyncEventType.syncCompleted,
            timestamp: DateTime.now(),
            data: {
              'uploadedClients': syncResult.uploadedClients,
              'downloadedClients': syncResult.downloadedClients,
              'uploadedApplications': syncResult.uploadedApplications,
              'downloadedApplications': syncResult.downloadedApplications,
              'conflictsResolved': syncResult.conflictsResolved,
            },
          ));

          return const Right(null);
        },
      );
    } catch (e) {
      _updateState(_currentState.copyWith(
        isSyncing: false,
        lastError: e.toString(),
      ));

      _eventController.add(SyncEvent(
        type: SyncEventType.syncFailed,
        timestamp: DateTime.now(),
        data: {'error': e.toString()},
      ));

      return Left(SyncFailure.unknown(e.toString()));
    }
  }

  Future<void> refreshPendingCount() async {
    // Esta funcionalidad se implementaría consultando la base de datos
    // para obtener la cantidad de registros pendientes
  }

  void handleBackgroundSync() {
    _eventController.add(SyncEvent(
      type: SyncEventType.backgroundSync,
      timestamp: DateTime.now(),
    ));

    if (!_currentState.isSyncing && _currentState.isOnline) {
      handleSyncRequested();
    }
  }

  void dispose() {
    _periodicSyncTimer?.cancel();
    _connectivitySubscription?.cancel();
    _eventController.close();
    _stateController.close();
  }
}