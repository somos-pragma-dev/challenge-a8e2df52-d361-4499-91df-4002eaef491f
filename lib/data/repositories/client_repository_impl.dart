package data.repositories;

import 'package:dartz/dartz.dart';
import '../../core/config/app_config.dart';
import '../../core/database/app_database.dart';
import '../../core/error/failures.dart';
import '../../core/network/connectivity_service.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/sync_status.dart';
import '../../domain/repositories/client_repository.dart';
import '../datasources/local/client_local_datasource.dart';
import '../datasources/remote/client_remote_datasource.dart';
import '../models/client_model.dart';

class ClientRepositoryImpl implements ClientRepository {
  final ClientLocalDatasource localDatasource;
  final ClientRemoteDatasource remoteDatasource;
  final ConnectivityService connectivityService;
  final AppConfig appConfig;
  final AppDatabase database;

  ClientRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
    required this.connectivityService,
    required this.appConfig,
    required this.database,
  });

  @override
  Future<Either<Failure, List<Client>>> getClients() async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      
      if (connectivityStatus.isConnected) {
        try {
          final remoteResult = await remoteDatasource.fetchAllClients();
          return remoteResult.fold(
            (failure) async {
              final localResult = await localDatasource.getAllClients();
              return localResult.fold(
                (failure) => Left(failure),
                (models) => Right(models.map((m) => m.toEntity()).toList()),
              );
            },
            (clientModels) async {
              for (final model in clientModels) {
                await localDatasource.saveClient(model.copyWith(
                  syncStatus: SyncStatusEnum.synced,
                  syncedAt: DateTime.now(),
                ));
              }
              final localResult = await localDatasource.getAllClients();
              return localResult.fold(
                (failure) => Left(failure),
                (models) => Right(models.map((m) => m.toEntity()).toList()),
              );
            },
          );
        } catch (e) {
          final localResult = await localDatasource.getAllClients();
          return localResult.fold(
            (failure) => Left(failure),
            (models) => Right(models.map((m) => m.toEntity()).toList()),
          );
        }
      } else {
        final localResult = await localDatasource.getAllClients();
        return localResult.fold(
          (failure) => Left(failure),
          (models) => Right(models.map((m) => m.toEntity()).toList()),
        );
      }
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Client>> getClientById(String id) async {
    try {
      final result = await localDatasource.getClientById(id);
      return result.fold(
        (failure) => Left(failure),
        (model) => model != null 
            ? Right(model.toEntity()) 
            : Left(CacheFailure.notFound()),
      );
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Client>> saveClient(Client client) async {
    try {
      final clientModel = ClientModel.fromEntity(client);
      final modelWithSync = clientModel.copyWith(
        syncStatus: SyncStatusEnum.pending,
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
      );
      
      await localDatasource.saveClient(modelWithSync);
      
      final connectivityStatus = await connectivityService.checkConnectivity();
      if (connectivityStatus.isConnected) {
        try {
          await remoteDatasource.createClient(clientModel);
          await localDatasource.updateSyncStatus(
            [client.id],
            SyncStatusEnum.synced,
          );
          final updatedResult = await localDatasource.getClientById(client.id);
          return updatedResult.fold(
            (failure) => Left(failure),
            (model) => Right(model.toEntity()),
          );
        } catch (e) {
          await _queueForSync(client.id, 'client');
        }
      } else {
        await _queueForSync(client.id, 'client');
      }
      
      return Right(modelWithSync.toEntity());
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.insertError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Client>> updateClient(Client client) async {
    try {
      final existingResult = await localDatasource.getClientById(client.id);
      final existing = existingResult.fold<ClientModel?>(
        (failure) => null,
        (model) => model,
      );
      
      if (existing == null) {
        return Left(CacheFailure.notFound());
      }
      
      final updatedModel = ClientModel.fromEntity(client).copyWith(
        syncStatus: SyncStatusEnum.pending,
        version: existing.version + 1,
        lastModified: DateTime.now(),
      );
      
      await localDatasource.updateClient(updatedModel);
      
      final connectivityStatus = await connectivityService.checkConnectivity();
      if (connectivityStatus.isConnected) {
        try {
          await remoteDatasource.updateClient(updatedModel);
          await localDatasource.updateSyncStatus(
            [client.id],
            SyncStatusEnum.synced,
          );
        } catch (e) {
          await _queueForSync(client.id, 'client');
        }
      } else {
        await _queueForSync(client.id, 'client');
      }
      
      final finalResult = await localDatasource.getClientById(client.id);
      return finalResult.fold(
        (failure) => Left(failure),
        (model) => Right(model.toEntity()),
      );
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.updateError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteClient(String id) async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      
      if (connectivityStatus.isConnected) {
        try {
          await remoteDatasource.deleteClient(id);
        } catch (e) {
          await _queueForSync(id, 'client_delete');
        }
      } else {
        await _queueForSync(id, 'client_delete');
      }
      
      await localDatasource.deleteClient(id);
      return const Right(null);
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure.deleteError(e.message));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<Client>>> getPendingClients() async {
    try {
      final result = await localDatasource.getPendingClients();
      return result.fold(
        (failure) => Left(failure),
        (models) => Right(models.map((m) => m.toEntity()).toList()),
      );
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> syncClients() async {
    try {
      final connectivityStatus = await connectivityService.checkConnectivity();
      if (!connectivityStatus.isConnected) {
        return Left(NetworkFailure.noConnection());
      }
      
      final pendingResult = await localDatasource.getPendingClients();
      final pendingClients = pendingResult.fold(
        (failure) => <ClientModel>[],
        (models) => models,
      );
      
      final syncedIds = <String>[];
      
      for (final client in pendingClients) {
        try {
          if (client.syncStatus == SyncStatusEnum.pending) {
            await remoteDatasource.createClient(client);
          } else if (client.syncStatus == SyncStatusEnum.conflict) {
            final serverResult = await remoteDatasource.fetchClientById(client.id);
            serverResult.fold(
              (failure) => null,
              (serverVersion) async {
                final resolved = await _resolveConflict(client, serverVersion);
                await remoteDatasource.updateClient(resolved);
              },
            );
          }
          syncedIds.add(client.id);
        } catch (e) {
          continue;
        }
      }
      
      if (syncedIds.isNotEmpty) {
        await database.updateClientsSyncStatus(
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

  @override
  Stream<List<Client>> watchAllClients() {
    return localDatasource.watchAllClients().map(
      (result) => result.fold(
        (failure) => [],
        (models) => models.map((m) => m.toEntity()).toList(),
      ),
    );
  }

  @override
  Stream<List<Client>> watchPendingClients() {
    return localDatasource.watchPendingClients().map(
      (result) => result.fold(
        (failure) => [],
        (models) => models.map((m) => m.toEntity()).toList(),
      ),
    );
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

  Future<ClientModel> _resolveConflict(
    ClientModel local,
    ClientModel remote,
  ) async {
    if (local.lastModified.isAfter(remote.lastModified)) {
      return local;
    }
    final merged = local.copyWith(
      firstName: remote.firstName,
      lastName: remote.lastName,
      email: remote.email,
      phone: remote.phone,
      address: remote.address,
      identificationNumber: remote.identificationNumber,
      version: remote.version + 1,
      syncStatus: SyncStatusEnum.synced,
      syncedAt: DateTime.now(),
    );
    await localDatasource.updateClient(merged);
    return merged;
  }
}