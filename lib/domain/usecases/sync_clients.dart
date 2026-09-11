package credit_field_app.domain.usecases;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/error/failures.dart';
import '../entities/client.dart';
import '../entities/sync_status.dart';
import '../repositories/client_repository.dart';

class SyncClientsParams extends Equatable {
  final bool forceFullSync;
  final int? batchSize;

  const SyncClientsParams({
    this.forceFullSync = false,
    this.batchSize,
  });

  @override
  List<Object?> get props => [forceFullSync, batchSize];
}

class SyncClientsResult extends Equatable {
  final int totalProcessed;
  final int successfullySynced;
  final int failedSync;
  final int conflictsDetected;
  final List<String> failedClientIds;
  final List<String> conflictClientIds;

  const SyncClientsResult({
    required this.totalProcessed,
    required this.successfullySynced,
    required this.failedSync,
    required this.conflictsDetected,
    required this.failedClientIds,
    required this.conflictClientIds,
  });

  bool get hasErrors => failedSync > 0 || conflictsDetected > 0;
  bool get hasConflicts => conflictsDetected > 0;
  double get successRate =>
      totalProcessed > 0 ? (successfullySynced / totalProcessed) * 100 : 0;

  @override
  List<Object?> get props => [
        totalProcessed,
        successfullySynced,
        failedSync,
        conflictsDetected,
        failedClientIds,
        conflictClientIds,
      ];
}

class SyncClients {
  final ClientRepository clientRepository;

  SyncClients({required this.clientRepository});

  Future<Either<Failure, SyncClientsResult>> call(SyncClientsParams params) async {
    try {
      final pendingClientsResult = await clientRepository.getPendingClients();
      
      return pendingClientsResult.fold(
        (failure) => Left(failure),
        (pendingClients) async {
          if (pendingClients.isEmpty) {
            return const Right(SyncClientsResult(
              totalProcessed: 0,
              successfullySynced: 0,
              failedSync: 0,
              conflictsDetected: 0,
              failedClientIds: [],
              conflictClientIds: [],
            ));
          }

          final batchSize = params.batchSize ?? pendingClients.length;
          final clientsToProcess = params.forceFullSync
              ? pendingClients
              : pendingClients.take(batchSize).toList();

          int successfullySynced = 0;
          int failedSync = 0;
          int conflictsDetected = 0;
          final List<String> failedClientIds = [];
          final List<String> conflictClientIds = [];

          for (final client in clientsToProcess) {
            final syncResult = await _syncSingleClient(client);
            
            syncResult.fold(
              (failure) {
                failedSync++;
                failedClientIds.add(client.id);
              },
              (result) {
                if (result == _SyncClientOutcome.synced) {
                  successfullySynced++;
                } else if (result == _SyncClientOutcome.conflict) {
                  conflictsDetected++;
                  conflictClientIds.add(client.id);
                } else {
                  failedSync++;
                  failedClientIds.add(client.id);
                }
              },
            );
          }

          return Right(SyncClientsResult(
            totalProcessed: clientsToProcess.length,
            successfullySynced: successfullySynced,
            failedSync: failedSync,
            conflictsDetected: conflictsDetected,
            failedClientIds: failedClientIds,
            conflictClientIds: conflictClientIds,
          ));
        },
      );
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  Future<Either<Failure, _SyncClientOutcome>> _syncSingleClient(Client client) async {
    try {
      final uploadResult = await clientRepository.uploadClientToServer(client);

      return uploadResult.fold(
        (failure) async {
          if (failure is SyncFailure && 
              failure.message.contains('conflict')) {
            await clientRepository.updateClientSyncStatus(
              client.id,
              SyncStatus.conflict,
            );
            return const Right(_SyncClientOutcome.conflict);
          }
          
          await clientRepository.updateClientSyncStatus(
            client.id,
            SyncStatus.pending,
          );
          return const Right(_SyncClientOutcome.failed);
        },
        (serverVersion) async {
          final updatedClient = client.copyWith(
            syncStatus: SyncStatus.synced,
            version: serverVersion,
            syncedAt: DateTime.now(),
          );
          
          await clientRepository.saveClient(updatedClient);
          return const Right(_SyncClientOutcome.synced);
        },
      );
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }
}

enum _SyncClientOutcome {
  synced,
  conflict,
  failed,
}