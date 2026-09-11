package data.repositories;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/config/app_config.dart';
import '../../core/database/app_database.dart';
import '../../core/error/failures.dart';
import '../../core/network/connectivity_service.dart';
import '../../domain/entities/credit_application.dart';
import '../../domain/entities/sync_status.dart';
import '../../domain/repositories/credit_application_repository.dart';
import '../datasources/local/credit_application_local_datasource.dart';
import '../datasources/remote/credit_application_remote_datasource.dart';
import '../models/credit_application_model.dart';

class CreditApplicationRepositoryImpl implements CreditApplicationRepository {
  final CreditApplicationLocalDatasource localDatasource;
  final CreditApplicationRemoteDatasource remoteDatasource;
  final ConnectivityService connectivityService;
  final AppConfig appConfig;
  final AppDatabase database;

  CreditApplicationRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.connectivityService,
    required this.appConfig,
    required this.database,
  });

  @override
  Future<Either<Failure, List<CreditApplication>>> getCreditApplications() async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      
      if (connectivityStatus.isConnected) {
        try {
          final remoteResult = await remoteDatasource.fetchAllApplications();
          return remoteResult.fold(
            (failure) async {
              final localApplications = await localDatasource.getAllApplications();
              return Right(localApplications.map((m) => m.toEntity()).toList());
            },
            (applicationModels) async {
              for (final model in applicationModels) {
                await localDatasource.saveApplication(model.copyWith(
                  syncStatus: SyncStatusEnum.synced,
                  syncedAt: DateTime.now(),
                ));
              }
              final localApplications = await localDatasource.getAllApplications();
              return Right(localApplications.map((m) => m.toEntity()).toList());
            },
          );
        } catch (e) {
          final localApplications = await localDatasource.getAllApplications();
          return Right(localApplications.map((m) => m.toEntity()).toList());
        }
      } else {
        final localApplications = await localDatasource.getAllApplications();
        return Right(localApplications.map((m) => m.toEntity()).toList());
      }
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.queryError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<CreditApplication>>> getApplicationsByClientId(
    String clientId,
  ) async {
    try {
      final applications = await localDatasource.getApplicationsByClientId(clientId);
      return Right(applications.map((m) => m.toEntity()).toList());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.queryError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, CreditApplication>> getApplicationById(String id) async {
    try {
      final applicationModel = await localDatasource.getApplicationById(id);
      if (applicationModel == null) {
        return Left(CacheFailure.notFound());
      }
      return Right(applicationModel.toEntity());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.queryError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, CreditApplication>> saveApplication(
    CreditApplication application,
  ) async {
    try {
      final applicationModel = CreditApplicationModel.fromEntity(application);
      final applicationWithSync = applicationModel.copyWith(
        syncStatus: SyncStatusEnum.pending,
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
      );
      
      await localDatasource.saveApplication(applicationWithSync);
      
      final connectivityStatus = await connectivityService.checkConnectivity();
      if (connectivityStatus.isConnected) {
        try {
          await remoteDatasource.createApplication(applicationModel);
          await localDatasource.updateSyncStatus(
            application.id,
            SyncStatusEnum.synced.name,
          );
          final updatedApplication = await localDatasource.getApplicationById(application.id);
          if (updatedApplication != null) {
            return Right(updatedApplication.toEntity());
          }
        } catch (e) {
          await _queueForSync(application.id, 'credit_application');
        }
      } else {
        await _queueForSync(application.id, 'credit_application');
      }
      
      return Right(applicationWithSync.toEntity());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.insertError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, CreditApplication>> updateApplication(
    CreditApplication application,
  ) async {
    try {
      final existingApplication = await localDatasource.getApplicationById(application.id);
      if (existingApplication == null) {
        return Left(CacheFailure.notFound());
      }
      
      final updatedModel = CreditApplicationModel.fromEntity(application).copyWith(
        syncStatus: SyncStatusEnum.pending,
        version: existingApplication.version + 1,
        lastModified: DateTime.now(),
      );
      
      await localDatasource.updateApplication(updatedModel);
      
      final connectivityStatus = await connectivityService.checkConnectivity();
      if (connectivityStatus.isConnected) {
        try {
          await remoteDatasource.updateApplication(application.id, updatedModel);
          await localDatasource.updateSyncStatus(
            application.id,
            SyncStatusEnum.synced.name,
          );
        } catch (e) {
          await _queueForSync(application.id, 'credit_application');
        }
      } else {
        await _queueForSync(application.id, 'credit_application');
      }
      
      final finalApplication = await localDatasource.getApplicationById(application.id);
      if (finalApplication != null) {
        return Right(finalApplication.toEntity());
      }
      return Left(CacheFailure.notFound());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.updateError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteApplication(String id) async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      
      if (connectivityStatus.isConnected) {
        try {
          await remoteDatasource.deleteApplication(id);
        } catch (e) {
          await _queueForSync(id, 'credit_application_delete');
        }
      } else {
        await _queueForSync(id, 'credit_application_delete');
      }
      
      await localDatasource.deleteApplication(id);
      return const Right(null);
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.deleteError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<CreditApplication>>> getPendingApplications() async {
    try {
      final pendingApplications = await localDatasource.getPendingApplications();
      return Right(pendingApplications.map((m) => m.toEntity()).toList());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.queryError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> syncApplications() async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      if (!connectivityStatus.isConnected) {
        return Left(NetworkFailure.noConnection());
      }
      
      final pendingApplications = await localDatasource.getPendingApplications();
      final syncedIds = <String>[];
      
      for (final application in pendingApplications) {
        try {
          if (application.syncStatus == SyncStatusEnum.pending) {
            await remoteDatasource.createApplication(application);
          } else if (application.syncStatus == SyncStatusEnum.conflict) {
            final serverResult = await remoteDatasource.fetchApplicationById(application.id);
            serverResult.fold(
              (failure) => continue,
              (serverVersion) async {
                final resolved = await _resolveConflict(application, serverVersion);
                await remoteDatasource.updateApplication(application.id, resolved);
              },
            );
          }
          syncedIds.add(application.id);
        } catch (e) {
          continue;
        }
      }
      
      if (syncedIds.isNotEmpty) {
        await database.updateCreditApplicationsSyncStatus(
          syncedIds,
          SyncStatusEnum.synced.name,
        );
      }
      
      return const Right(null);
    } on NetworkFailure catch (e) {
      return Left(e);
    } on SyncFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  Future<void> _queueForSync(String entityId, String entityType) async {
    await database.insertSyncLog(SyncLogTableCompanion.insert(
      entityType: entityType,
      entityId: entityId,
      operation: 'create',
      payload: '',
      status: 'pending',
      retryCount: 0,
      createdAt: DateTime.now(),
    ));
  }

  Future<CreditApplicationModel> _resolveConflict(
    CreditApplicationModel local,
    CreditApplicationModel remote,
  ) async {
    if (local.lastModified.isAfter(remote.lastModified)) {
      return local;
    }
    final merged = local.copyWith(
      requestedAmount: remote.requestedAmount,
      purpose: remote.purpose,
      termMonths: remote.termMonths,
      status: remote.status,
      approvedAmount: remote.approvedAmount,
      version: remote.version + 1,
      syncStatus: SyncStatusEnum.synced,
      syncedAt: DateTime.now(),
    );
    await localDatasource.updateApplication(merged);
    return merged;
  }
}