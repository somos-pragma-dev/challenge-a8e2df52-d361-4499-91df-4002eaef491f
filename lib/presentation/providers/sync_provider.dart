package offline_field_app.presentation.providers;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:offline_field_app/core/network/network_info.dart';
import 'package:offline_field_app/domain/repositories/sync_repository.dart';
import 'package:offline_field_app/domain/entities/sync_record.dart';
import 'package:offline_field_app/domain/usecases/sync_transactions.dart';
import 'package:offline_field_app/domain/usecases/resolve_conflict.dart';
import 'package:offline_field_app/core/errors/failures.dart';
import 'package:offline_field_app/core/errors/exceptions.dart';

enum SyncState { idle, checking, syncing, completed, error }
enum ConflictResolutionState { none, detecting, resolved, manualRequired }

class SyncProvider extends ChangeNotifier {
  final SyncRepository _syncRepository;
  final SyncTransactions _syncTransactionsUseCase;
  final ResolveConflict _resolveConflictUseCase;
  final NetworkInfo _networkInfo;

  SyncProvider({
    required SyncRepository syncRepository,
    required SyncTransactions syncTransactionsUseCase,
    required ResolveConflict resolveConflictUseCase,
    required NetworkInfo networkInfo,
  })  : _syncRepository = syncRepository,
        _syncTransactionsUseCase = syncTransactionsUseCase,
        _resolveConflictUseCase = resolveConflictUseCase,
        _networkInfo = networkInfo {
    _initConnectivityListener();
  }

  SyncState _syncState = SyncState.idle;
  ConflictResolutionState _conflictState = ConflictResolutionState.none;
  NetworkStatus _networkStatus = NetworkStatus.disconnected;
  List<SyncRecord> _syncHistory = [];
  SyncRecord? _lastSyncRecord;
  Failure? _lastFailure;
  String? _successMessage;
  double _syncProgress = 0.0;
  int _totalItems = 0;
  int _processedItems = 0;
  Map<String, dynamic>? _currentConflict;
  StreamSubscription<NetworkStatus>? _connectivitySubscription;
  Timer? _autoSyncTimer;
  bool _autoSyncEnabled = false;

  SyncState get syncState => _syncState;
  ConflictResolutionState get conflictState => _conflictState;
  NetworkStatus get networkStatus => _networkStatus;
  List<SyncRecord> get syncHistory => List.unmodifiable(_syncHistory);
  SyncRecord? get lastSyncRecord => _lastSyncRecord;
  Failure? get lastFailure => _lastFailure;
  String? get successMessage => _successMessage;
  double get syncProgress => _syncProgress;
  int get totalItems => _totalItems;
  int get processedItems => _processedItems;
  Map<String, dynamic>? get currentConflict => _currentConflict;
  bool get isOnline => _networkStatus == NetworkStatus.connected;
  bool get isSyncing => _syncState == SyncState.syncing;
  bool get autoSyncEnabled => _autoSyncEnabled;
  bool get hasConflicts => _conflictState == ConflictResolutionState.detecting ||
                           _conflictState == ConflictResolutionState.manualRequired;

  void _initConnectivityListener() {
    _connectivitySubscription = _networkInfo.onConnectivityChanged.listen(
      (status) {
        final previousStatus = _networkStatus;
        _networkStatus = status;
        notifyListeners();
        if (previousStatus == NetworkStatus.disconnected &&
            status == NetworkStatus.connected) {
          if (_autoSyncEnabled) {
            syncPendingTransactions();
          }
        }
      },
    );
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    await _networkInfo.checkConnectivity();
    _networkStatus = _networkInfo.isConnected ? NetworkStatus.connected : NetworkStatus.disconnected;
    notifyListeners();
  }

  Future<void> loadSyncHistory() async {
    try {
      final result = await _syncRepository.getSyncHistory();
      result.fold(
        (failure) {
          _lastFailure = failure;
        },
        (records) {
          _syncHistory = records;
          if (records.isNotEmpty) {
            _lastSyncRecord = records.first;
          }
        },
      );
    } catch (e) {
      _lastFailure = OfflineFailure.database('Failed to load sync history');
    }
    notifyListeners();
  }

  Future<bool> syncPendingTransactions() async {
    if (_syncState == SyncState.syncing) {
      return false;
    }

    if (!isOnline) {
      _lastFailure = const OfflineFailure.networkUnavailable();
      notifyListeners();
      return false;
    }

    _syncState = SyncState.syncing;
    _lastFailure = null;
    _successMessage = null;
    _syncProgress = 0.0;
    _processedItems = 0;
    notifyListeners();

    try {
      final result = await _syncTransactionsUseCase();
      return result.fold(
        (failure) {
          _handleSyncFailure(failure);
          return false;
        },
        (syncResult) async {
          _totalItems = syncResult['total'] ?? 0;
          _processedItems = syncResult['processed'] ?? 0;
          _syncProgress = _totalItems > 0 ? _processedItems / _totalItems : 1.0;

          if (syncResult['conflicts'] != null && (syncResult['conflicts'] as List).isNotEmpty) {
            _conflictState = ConflictResolutionState.detecting;
            _currentConflict = syncResult['conflicts'].first as Map<String, dynamic>;
          } else {
            _conflictState = ConflictResolutionState.resolved;
            _currentConflict = null;
          }

          await _saveSyncRecord(syncResult);
          _syncState = SyncState.completed;
          _successMessage = 'Sync completed: $_processedItems of $_totalItems items';
          notifyListeners();
          return true;
        },
      );
    } on SyncConflictException catch (e) {
      _conflictState = ConflictResolutionState.manualRequired;
      _currentConflict = e.toConflictData();
      _syncState = SyncState.error;
      notifyListeners();
      return false;
    } catch (e) {
      _lastFailure = SyncFailure.serverError(e.toString());
      _syncState = SyncState.error;
      notifyListeners();
      return false;
    }
  }

  void _handleSyncFailure(Failure failure) {
    _syncState = SyncState.error;
    _lastFailure = failure;
    if (failure is SyncFailure) {
      if (failure.code == 'timeout') {
        _lastFailure = SyncFailure.timeout();
      } else if (failure.code == 'unauthorized') {
        _lastFailure = SyncFailure.unauthorized();
      }
    }
    notifyListeners();
  }

  Future<void> _saveSyncRecord(Map<String, dynamic> syncResult) async {
    final record = SyncRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      syncStatus: syncResult['success'] == true ? 'completed' : 'failed',
      recordsProcessed: syncResult['processed'] ?? 0,
      recordsFailed: syncResult['failed'] ?? 0,
      conflictsDetected: (syncResult['conflicts'] as List?)?.length ?? 0,
      startedAt: DateTime.now().subtract(const Duration(seconds: 30)),
      completedAt: DateTime.now(),
      errorDetails: _lastFailure?.message,
    );

    final result = await _syncRepository.saveSyncRecord(record);
    result.fold(
      (failure) {},
      (_) {
        _syncHistory.insert(0, record);
        _lastSyncRecord = record;
      },
    );
  }

  Future<bool> resolveConflict({
    required String entityId,
    required String resolution,
    Map<String, dynamic>? resolvedData,
  }) async {
    if (_currentConflict == null) {
      return false;
    }

    _conflictState = ConflictResolutionState.detecting;
    notifyListeners();

    try {
      final result = await _resolveConflictUseCase(
        entityId: entityId,
        resolution: resolution,
        resolvedData: resolvedData,
      );

      return result.fold(
        (failure) {
          _lastFailure = failure;
          _conflictState = ConflictResolutionState.manualRequired;
          notifyListeners();
          return false;
        },
        (_) {
          _conflictState = ConflictResolutionState.resolved;
          _currentConflict = null;
          _successMessage = 'Conflict resolved successfully';
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _lastFailure = SyncFailure.serverError(e.toString());
      _conflictState = ConflictResolutionState.manualRequired;
      notifyListeners();
      return false;
    }
  }

  void enableAutoSync({Duration interval = const Duration(minutes: 5)}) {
    _autoSyncEnabled = true;
    _autoSyncTimer?.cancel();
    _autoSyncTimer = Timer.periodic(interval, (_) {
      if (isOnline) {
        syncPendingTransactions();
      }
    });
    notifyListeners();
  }

  void disableAutoSync() {
    _autoSyncEnabled = false;
    _autoSyncTimer?.cancel();
    _autoSyncTimer = null;
    notifyListeners();
  }

  Future<void> checkAndSync() async {
    if (!isOnline) {
      return;
    }

    _syncState = SyncState.checking;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final hasPending = await _checkPendingItems();
    if (hasPending) {
      await syncPendingTransactions();
    } else {
      _syncState = SyncState.idle;
      notifyListeners();
    }
  }

  Future<bool> _checkPendingItems() async {
    try {
      final result = await _syncRepository.getPendingOperationsCount();
      return result.fold(
        (_) => false,
        (count) => count > 0,
      );
    } catch (e) {
      return false;
    }
  }

  void clearConflict() {
    _currentConflict = null;
    _conflictState = ConflictResolutionState.none;
    notifyListeners();
  }

  void clearMessages() {
    _lastFailure = null;
    _successMessage = null;
    notifyListeners();
  }

  void reset() {
    _syncState = SyncState.idle;
    _conflictState = ConflictResolutionState.none;
    _syncHistory = [];
    _lastSyncRecord = null;
    _lastFailure = null;
    _successMessage = null;
    _syncProgress = 0.0;
    _totalItems = 0;
    _processedItems = 0;
    _currentConflict = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _autoSyncTimer?.cancel();
    super.dispose();
  }
}