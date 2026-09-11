package credit_field_app.data.datasources.local;

import 'package:drift/drift.dart';
import 'package:dartz/dartz.dart';
import '../../../core/database/app_database.dart';
import '../../../core/error/failures.dart';
import '../../models/client_model.dart';
import '../../../domain/entities/sync_status.dart';

abstract class ClientLocalDataSource {
  Future<Either<Failure, List<ClientModel>>> getAllClients();
  Stream<Either<Failure, List<ClientModel>>> watchAllClients();
  Future<Either<Failure, ClientModel?>> getClientById(String id);
  Future<Either<Failure, ClientModel>> saveClient(ClientModel client);
  Future<Either<Failure, bool>> updateClient(ClientModel client);
  Future<Either<Failure, int>> deleteClient(String id);
  Future<Either<Failure, List<ClientModel>>> getPendingClients();
  Stream<Either<Failure, List<ClientModel>>> watchPendingClients();
  Future<Either<Failure, void>> updateSyncStatus(
      List<String> ids, SyncStatus status);
}

class ClientLocalDataSourceImpl implements ClientLocalDataSource {
  final AppDatabase _database;

  ClientLocalDataSourceImpl(this._database);

  @override
  Future<Either<Failure, List<ClientModel>>> getAllClients() async {
    try {
      final clients = await _database.getAllClients();
      return Right(clients.map(_mapToModel).toList());
    } catch (e) {
      return Left(DatabaseFailure.queryError(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<ClientModel>>> watchAllClients() {
    return _database.watchAllClients().map((clients) {
      try {
        return Right<Failure, List<ClientModel>>(
            clients.map(_mapToModel).toList());
      } catch (e) {
        return Left<Failure, List<ClientModel>>(
            DatabaseFailure.queryError(e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, ClientModel?>> getClientById(String id) async {
    try {
      final client = await _database.getClientById(id);
      if (client == null) {
        return const Right(null);
      }
      return Right(_mapToModel(client));
    } catch (e) {
      return Left(DatabaseFailure.queryError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ClientModel>> saveClient(ClientModel client) async {
    try {
      final existingClient = await _database.getClientById(client.id);
      final now = DateTime.now();

      final companion = ClientsTableCompanion(
        id: Value(client.id),
        firstName: Value(client.firstName),
        lastName: Value(client.lastName),
        email: Value(client.email),
        phone: Value(client.phone),
        address: Value(client.address),
        identificationNumber: Value(client.identificationNumber),
        syncStatus: Value(client.syncStatus.name),
        version: Value(client.version),
        lastModified: Value(now),
        createdAt: Value(existingClient?.createdAt ?? now),
        syncedAt: Value(
            client.syncStatus == SyncStatus.synced ? now : client.syncedAt),
      );

      if (existingClient != null) {
        final updated = await _database.updateClient(companion);
        if (!updated) {
          return Left(DatabaseFailure.updateError());
        }
      } else {
        final id = await _database.insertClient(companion);
        if (id == 0) {
          return Left(DatabaseFailure.insertError());
        }
      }

      final savedClient = await _database.getClientById(client.id);
      if (savedClient == null) {
        return Left(DatabaseFailure.queryError('Client not found after save'));
      }

      return Right(_mapToModel(savedClient));
    } catch (e) {
      return Left(DatabaseFailure.insertError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateClient(ClientModel client) async {
    try {
      final now = DateTime.now();
      final companion = ClientsTableCompanion(
        id: Value(client.id),
        firstName: Value(client.firstName),
        lastName: Value(client.lastName),
        email: Value(client.email),
        phone: Value(client.phone),
        address: Value(client.address),
        identificationNumber: Value(client.identificationNumber),
        syncStatus: Value(client.syncStatus.name),
        version: Value(client.version + 1),
        lastModified: Value(now),
        createdAt: Value(client.createdAt),
        syncedAt: Value(client.syncedAt),
      );

      final result = await _database.updateClient(companion);
      if (!result) {
        return Left(DatabaseFailure.updateError());
      }
      return const Right(true);
    } catch (e) {
      return Left(DatabaseFailure.updateError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> deleteClient(String id) async {
    try {
      final result = await _database.deleteClient(id);
      if (result == 0) {
        return Left(DatabaseFailure.deleteError('Client not found'));
      }
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure.deleteError(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ClientModel>>> getPendingClients() async {
    try {
      final clients = await _database.getPendingClients();
      return Right(clients.map(_mapToModel).toList());
    } catch (e) {
      return Left(DatabaseFailure.queryError(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<ClientModel>>> watchPendingClients() {
    return _database.watchPendingClients().map((clients) {
      try {
        return Right<Failure, List<ClientModel>>(
            clients.map(_mapToModel).toList());
      } catch (e) {
        return Left<Failure, List<ClientModel>>(
            DatabaseFailure.queryError(e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, void>> updateSyncStatus(
      List<String> ids, SyncStatus status) async {
    try {
      await _database.updateClientsSyncStatus(
        ids,
        status.name,
      );
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure.updateError(e.toString()));
    }
  }

  ClientModel _mapToModel(ClientsTableData data) {
    return ClientModel(
      id: data.id,
      firstName: data.firstName,
      lastName: data.lastName,
      email: data.email,
      phone: data.phone,
      address: data.address,
      identificationNumber: data.identificationNumber,
      syncStatus: _parseSyncStatus(data.syncStatus),
      version: data.version,
      lastModified: data.lastModified,
      createdAt: data.createdAt,
      syncedAt: data.syncedAt,
    );
  }

  SyncStatus _parseSyncStatus(String status) {
    switch (status) {
      case 'synced':
        return SyncStatus.synced;
      case 'conflict':
        return SyncStatus.conflict;
      case 'pending':
      default:
        return SyncStatus.pending;
    }
  }
}