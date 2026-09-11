part of 'sync_viewmodel.dart';

enum SyncViewModelStatus {
  initial,
  checking,
  idle,
  syncing,
  synced,
  conflictDetected,
  resolving,
  error,
}

class SyncResult extends Equatable {
  final int syncedCount;
  final int failedCount;
  final List<SyncConflict> conflicts;
  final DateTime timestamp;

  const SyncResult({
    required this.syncedCount,
    required this.failedCount,
    required this.conflicts,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [syncedCount, failedCount, conflicts, timestamp];
}

class SyncConflict extends Equatable {
  final String id;
  final String entityType;
  final String entityId;
  final dynamic localVersion;
  final dynamic remoteVersion;
  final DateTime detectedAt;

  const SyncConflict({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.localVersion,
    required this.remoteVersion,
    required this.detectedAt,
  });

  @override
  List<Object?> get props => [
        id,
        entityType,
        entityId,
        localVersion,
        remoteVersion,
        detectedAt,
      ];
}

enum ConflictResolution { useLocal, useRemote, merge }

class SyncViewModelState extends Equatable {
  final SyncViewModelStatus status;
  final bool isSyncing;
  final bool isResolvingConflict;
  final bool isOnline;
  final bool isPeriodicSyncEnabled;
  final int pendingItemsCount;
  final int syncedCount;
  final int failedCount;
  final List<SyncConflict> pendingConflicts;
  final DateTime? lastSyncTime;
  final String? errorMessage;
  final Failure? lastError;
  final SyncResult? lastSyncResult;
  final dynamic lastConflictResolution;

  const SyncViewModelState({
    this.status = SyncViewModelStatus.initial,
    this.isSyncing = false,
    this.isResolvingConflict = false,
    this.isOnline = false,
    this.isPeriodicSyncEnabled = false,
    this.pendingItemsCount = 0,
    this.syncedCount = 0,
    this.failedCount = 0,
    this.pendingConflicts = const [],
    this.lastSyncTime,
    this.errorMessage,
    this.lastError,
    this.lastSyncResult,
    this.lastConflictResolution,
  });

  SyncViewModelState copyWith({
    SyncViewModelStatus? status,
    bool? isSyncing,
    bool? isResolvingConflict,
    bool? isOnline,
    bool? isPeriodicSyncEnabled,
    int? pendingItemsCount,
    int? syncedCount,
    int? failedCount,
    List<SyncConflict>? pendingConflicts,
    DateTime? lastSyncTime,
    String? errorMessage,
    Failure? lastError,
    SyncResult? lastSyncResult,
    dynamic lastConflictResolution,
  }) {
    return SyncViewModelState(
      status: status ?? this.status,
      isSyncing: isSyncing ?? this.isSyncing,
      isResolvingConflict: isResolvingConflict ?? this.isResolvingConflict,
      isOnline: isOnline ?? this.isOnline,
      isPeriodicSyncEnabled: isPeriodicSyncEnabled ?? this.isPeriodicSyncEnabled,
      pendingItemsCount: pendingItemsCount ?? this.pendingItemsCount,
      syncedCount: syncedCount ?? this.syncedCount,
      failedCount: failedCount ?? this.failedCount,
      pendingConflicts: pendingConflicts ?? this.pendingConflicts,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      errorMessage: errorMessage ?? this.errorMessage,
      lastError: lastError ?? this.lastError,
      lastSyncResult: lastSyncResult ?? this.lastSyncResult,
      lastConflictResolution: lastConflictResolution ?? this.lastConflictResolution,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isSyncing,
        isResolvingConflict,
        isOnline,
        isPeriodicSyncEnabled,
        pendingItemsCount,
        syncedCount,
        failedCount,
        pendingConflicts,
        lastSyncTime,
        errorMessage,
        lastError,
        lastSyncResult,
        lastConflictResolution,
      ];
}

library sync;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/config/app_config.dart';
import '../../core/database/app_database.dart';
import '../../core/error/failures.dart';
import '../../core/network/connectivity_service.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/credit_application.dart';
import '../../domain/repositories/client_repository.dart';
import '../../domain/repositories/credit_application_repository.dart';

part 'sync_coordinator.g.dart';

enum SyncState { idle, syncing, error, completed }

class SyncResult extends Equatable {
  final int uploadedClients;
  final int downloadedClients;
  final int uploadedApplications;
  final int downloadedApplications;
  final int conflictsResolved;
  final List<String> errors;

  const SyncResult({
    this.uploadedClients = 0,
    this.downloadedClients = 0,
    this.uploadedApplications = 0,
    this.downloadedApplications = 0,
    this.conflictsResolved = 0,
    this.errors = const [],
  });

  bool get hasErrors => errors.isNotEmpty;
  bool get hasConflicts => conflictsResolved > 0;

  @override
  List<Object?> get props => [
        uploadedClients,
        downloadedClients,
        uploadedApplications,
        downloadedApplications,
        conflictsResolved,
        errors,
      ];
}

class SyncProgress extends Equatable {
  final SyncState state;
  final String currentOperation;
  final double progress;
  final String? errorMessage;

  const SyncProgress({
    this.state = SyncState.idle,
    this.currentOperation = '',
    this.progress = 0.0,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [state, currentOperation, progress, errorMessage];
}

class SyncCoordinator {
  final AppDatabase database;
  final ClientRepository clientRepository;
  final CreditApplicationRepository creditApplicationRepository;
  final ConnectivityService connectivityService;
  final AppConfig config;

  final _progressController = StreamController<SyncProgress>.broadcast();
  bool _isSyncing = false;

  SyncCoordinator({
    required this.database,
    required this.clientRepository,
    required this.creditApplicationRepository,
    required this.connectivityService,
    required this.config,
  });

  Stream<SyncProgress> get progressStream => _progressController.stream;
  bool get isSyncing => _isSyncing;

  Future<Either<Failure, SyncResult>> executeFullSync() async {
    if (_isSyncing) {
      return const Left(SyncFailure(
        message: 'Sincronización ya en progreso',
      ));
    }

    final connectivity = await connectivityService.checkConnectivity();
    if (!connectivity.isConnected) {
      return Left(NetworkFailure.noConnection());
    }

    _isSyncing = true;
    _progressController.add(const SyncProgress(
      state: SyncState.syncing,
      currentOperation: 'Iniciando sincronización...',
      progress: 0.0,
    ));

    try {
      final result = await _performSync();
      _isSyncing = false;
      return result;
    } catch (e) {
      _isSyncing = false;
      _progressController.add(SyncProgress(
        state: SyncState.error,
        currentOperation: 'Error de sincronización',
        errorMessage: e.toString(),
      ));
      return Left(SyncFailure.unknown(e.toString()));
    }
  }

  Future<Either<Failure, SyncResult>> _performSync() async {
    final errors = <String>[];
    var uploadedClients = 0;
    var downloadedClients = 0;
    var uploadedApplications = 0;
    var downloadedApplications = 0;
    var conflictsResolved = 0;

    _progressController.add(const SyncProgress(
      state: SyncState.syncing,
      currentOperation: 'Subiendo clientes pendientes...',
      progress: 0.1,
    ));

    final uploadClientsResult = await _uploadPendingClients();
    uploadClientsResult.fold(
      (failure) => errors.add('Error uploading clients: ${failure.message}'),
      (count) => uploadedClients = count,
    );

    _progressController.add(const SyncProgress(
      state: SyncState.syncing,
      currentOperation: 'Descargando clientes del servidor...',
      progress: 0.3,
    ));

    final downloadClientsResult = await _downloadClients();
    downloadClientsResult.fold(
      (failure) => errors.add('Error downloading clients: ${failure.message}'),
      (count) => downloadedClients = count,
    );

    _progressController.add(const SyncProgress(
      state: SyncState.syncing,
      currentOperation: 'Subiendo solicitudes de crédito...',
      progress: 0.5,
    ));

    final uploadAppsResult = await _uploadPendingApplications();
    uploadAppsResult.fold(
      (failure) => errors.add('Error uploading applications: ${failure.message}'),
      (count) => uploadedApplications = count,
    );

    _progressController.add(const SyncProgress(
      state: SyncState.syncing,
      currentOperation: 'Descargando solicitudes de crédito...',
      progress: 0.7,
    ));

    final downloadAppsResult = await _downloadApplications();
    downloadAppsResult.fold(
      (failure) => errors.add('Error downloading applications: ${failure.message}'),
      (count) => downloadedApplications = count,
    );

    _progressController.add(const SyncProgress(
      state: SyncState.syncing,
      currentOperation: 'Resolviendo conflictos...',
      progress: 0.9,
    ));

    final conflictResult = await _resolvePendingConflicts();
    conflictResult.fold(
      (failure) => errors.add('Error resolving conflicts: ${failure.message}'),
      (count) => conflictsResolved = count,
    );

    _progressController.add(const SyncProgress(
      state: SyncState.completed,
      currentOperation: 'Sincronización completada',
      progress: 1.0,
    ));

    return Right(SyncResult(
      uploadedClients: uploadedClients,
      downloadedClients: downloadedClients,
      uploadedApplications: uploadedApplications,
      downloadedApplications: downloadedApplications,
      conflictsResolved: conflictsResolved,
      errors: errors,
    ));
  }

  Future<Either<Failure, int>> _uploadPendingClients() async {
    try {
      final pendingClients = await database.getPendingClients();
      if (pendingClients.isEmpty) {
        return const Right(0);
      }

      var uploaded = 0;
      final batchSize = config.maxBatchSize;

      for (var i = 0; i < pendingClients.length; i += batchSize) {
        final batch = pendingClients.skip(i).take(batchSize).toList();
        
        for (final clientData in batch) {
          final client = Client(
            id: clientData.id,
            firstName: clientData.firstName,
            lastName: clientData.lastName,
            email: clientData.email,
            phone: clientData.phone,
            address: clientData.address,
            identificationNumber: clientData.identificationNumber,
            syncStatus: _mapSyncStatus(clientData.syncStatus),
            version: clientData.version,
            lastModified: clientData.lastModified,
            createdAt: clientData.createdAt,
            syncedAt: clientData.syncedAt,
          );

          final result = await clientRepository.syncClient(client);
          result.fold(
            (failure) async {
              await database.insertSyncLog(SyncLogTableCompanion.insert(
                entityType: 'client',
                entityId: client.id,
                operation: 'upload',
                payload: client.toString(),
                status: 'failed',
                retryCount: 0,
                createdAt: DateTime.now(),
              ));
            },
            (syncedClient) async {
              await database.updateClientsSyncStatus(
                [client.id],
                'synced',
              );
              uploaded++;
            },
          );
        }
      }

      return Right(uploaded);
    } catch (e) {
      return Left(SyncFailure.uploadFailed('client', 'batch'));
    }
  }

  Future<Either<Failure, int>> _downloadClients() async {
    try {
      final result = await clientRepository.getRemoteClients();
      
      return result.fold(
        (failure) => Left(failure),
        (remoteClients) async {
          var downloaded = 0;
          
          for (final remoteClient in remoteClients) {
            final localClient = await database.getClientById(remoteClient.id);
            
            if (localClient == null) {
              await database.insertClient(ClientsTableCompanion.insert(
                id: remoteClient.id,
                firstName: remoteClient.firstName,
                lastName: remoteClient.lastName,
                email: remoteClient.email,
                phone: remoteClient.phone,
                address: remoteClient.address,
                identificationNumber: remoteClient.identificationNumber,
                syncStatus: const Value('synced'),
                version: remoteClient.version,
                lastModified: remoteClient.lastModified,
                createdAt: remoteClient.createdAt,
                syncedAt: DateTime.now(),
              ));
              downloaded++;
            } else if (remoteClient.version > localClient.version) {
              await database.updateClient(ClientsTableCompanion(
                id: Value(remoteClient.id),
                firstName: Value(remoteClient.firstName),
                lastName: Value(remoteClient.lastName),
                email: Value(remoteClient.email),
                phone: Value(remoteClient.phone),
                address: Value(remoteClient.address),
                identificationNumber: Value(remoteClient.identificationNumber),
                syncStatus: const Value('synced'),
                version: remoteClient.version,
                lastModified: remoteClient.lastModified,
                syncedAt: Value(DateTime.now()),
              ));
              downloaded++;
            }
          }
          
          return Right(downloaded);
        },
      );
    } catch (e) {
      return Left(SyncFailure.downloadFailed());
    }
  }

  Future<Either<Failure, int>> _uploadPendingApplications() async {
    try {
      final pendingApps = await database.getPendingCreditApplications();
      if (pendingApps.isEmpty) {
        return const Right(0);
      }

      var uploaded = 0;

      for (final appData in pendingApps) {
        final application = CreditApplication(
          id: appData.id,
          clientId: appData.clientId,
          requestedAmount: appData.requestedAmount,
          purpose: appData.purpose,
          termMonths: appData.termMonths,
          status: appData.status,
          syncStatus: _mapSyncStatus(appData.syncStatus),
          version: appData.version,
          lastModified: appData.lastModified,
          createdAt: appData.createdAt,
          syncedAt: appData.syncedAt,
          rejectionReason: appData.rejectionReason,
          approvedAmount: appData.approvedAmount,
        );

        final result = await creditApplicationRepository.syncApplication(application);
        result.fold(
          (failure) async {
            await database.insertSyncLog(SyncLogTableCompanion.insert(
              entityType: 'credit_application',
              entityId: application.id,
              operation: 'upload',
              payload: application.toString(),
              status: 'failed',
              retryCount: 0,
              createdAt: DateTime.now(),
            ));
          },
          (syncedApp) async {
            await database.updateCreditApplicationsSyncStatus(
              [application.id],
              'synced',
            );
            uploaded++;
          },
        );
      }

      return Right(uploaded);
    } catch (e) {
      return Left(SyncFailure.uploadFailed('credit_application', 'batch'));
    }
  }

  Future<Either<Failure, int>> _downloadApplications() async {
    try {
      final result = await creditApplicationRepository.getRemoteApplications();
      
      return result.fold(
        (failure) => Left(failure),
        (remoteApps) async {
          var downloaded = 0;
          
          for (final remoteApp in remoteApps) {
            final localApp = await database.getCreditApplicationById(remoteApp.id);
            
            if (localApp == null) {
              await database.insertCreditApplication(CreditApplicationsTableCompanion.insert(
                id: remoteApp.id,
                clientId: remoteApp.clientId,
                requestedAmount: remoteApp.requestedAmount,
                purpose: remoteApp.purpose,
                termMonths: remoteApp.termMonths,
                status: remoteApp.status,
                syncStatus: const Value('synced'),
                version: remoteApp.version,
                lastModified: remoteApp.lastModified,
                createdAt: remoteApp.createdAt,
                syncedAt: DateTime.now(),
                rejectionReason: remoteApp.rejectionReason,
                approvedAmount: remoteApp.approvedAmount,
              ));
              downloaded++;
            } else if (remoteApp.version > localApp.version) {
              await database.updateCreditApplication(CreditApplicationsTableCompanion(
                id: Value(remoteApp.id),
                clientId: Value(remoteApp.clientId),
                requestedAmount: Value(remoteApp.requestedAmount),
                purpose: Value(remoteApp.purpose),
                termMonths: Value(remoteApp.termMonths),
                status: Value(remoteApp.status),
                syncStatus: const Value('synced'),
                version: remoteApp.version,
                lastModified: remoteApp.lastModified,
                syncedAt: Value(DateTime.now()),
                rejectionReason: Value(remoteApp.rejectionReason),
                approvedAmount: Value(remoteApp.approvedAmount),
              ));
              downloaded++;
            }
          }
          
          return Right(downloaded);
        },
      );
    } catch (e) {
      return Left(SyncFailure.downloadFailed());
    }
  }

  Future<Either<Failure, int>> _resolvePendingConflicts() async {
    return const Right(0);
  }

  SyncStatus _mapSyncStatus(String dbStatus) {
    switch (dbStatus) {
      case 'pending':
        return SyncStatus.pending;
      case 'synced':
        return SyncStatus.synced;
      case 'conflict':
        return SyncStatus.conflict;
      default:
        return SyncStatus.pending;
    }
  }

  Future<void> schedulePeriodicSync() async {
    while (_isSyncing) {
      await Future.delayed(config.syncInterval);
    }
    
    await executeFullSync();
  }

  void dispose() {
    _progressController.close();
  }
}