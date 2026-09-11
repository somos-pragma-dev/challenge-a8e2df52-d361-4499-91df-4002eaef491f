library conflict_resolver;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/database/app_database.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/credit_application.dart';
import '../../domain/repositories/client_repository.dart';
import '../../domain/repositories/credit_application_repository.dart';

enum ConflictStrategy { serverWins, clientWins, manual, merge }

class ConflictInfo extends Equatable {
  final String entityType;
  final String entityId;
  final dynamic localVersion;
  final dynamic remoteVersion;
  final DateTime localLastModified;
  final DateTime remoteLastModified;
  final List<String> conflictingFields;

  const ConflictInfo({
    required this.entityType,
    required this.entityId,
    required this.localVersion,
    required this.remoteVersion,
    required this.localLastModified,
    required this.remoteLastModified,
    required this.conflictingFields,
  });

  @override
  List<Object?> get props => [
        entityType,
        entityId,
        localVersion,
        remoteVersion,
        localLastModified,
        remoteLastModified,
        conflictingFields,
      ];
}

class ConflictResolutionResult extends Equatable {
  final String entityType;
  final String entityId;
  final bool resolved;
  final ConflictStrategy strategyUsed;
  final dynamic resolvedEntity;
  final String? errorMessage;

  const ConflictResolutionResult({
    required this.entityType,
    required this.entityId,
    required this.resolved,
    required this.strategyUsed,
    this.resolvedEntity,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        entityType,
        entityId,
        resolved,
        strategyUsed,
        resolvedEntity,
        errorMessage,
      ];
}

class ConflictResolver {
  final ClientRepository clientRepository;
  final CreditApplicationRepository creditApplicationRepository;
  final AppDatabase database;

  ConflictResolver({
    required this.clientRepository,
    required this.creditApplicationRepository,
    required this.database,
  });

  Future<Either<Failure, List<ConflictInfo>>> detectConflicts() async {
    try {
      final conflicts = <ConflictInfo>[];

      final pendingClients = await database.getPendingClients();
      for (final clientData in pendingClients) {
        final remoteResult = await clientRepository.getRemoteClient(clientData.id);
        
        remoteResult.fold(
          (failure) {},
          (remoteClient) {
            if (remoteClient != null && remoteClient.version > clientData.version) {
              conflicts.add(ConflictInfo(
                entityType: 'client',
                entityId: clientData.id,
                localVersion: clientData.version,
                remoteVersion: remoteClient.version,
                localLastModified: clientData.lastModified,
                remoteLastModified: remoteClient.lastModified,
                conflictingFields: _findConflictingFields(
                  clientData,
                  remoteClient,
                ),
              ));
            }
          },
        );
      }

      final pendingApps = await database.getPendingCreditApplications();
      for (final appData in pendingApps) {
        final remoteResult = await creditApplicationRepository.getRemoteApplication(appData.id);
        
        remoteResult.fold(
          (failure) {},
          (remoteApp) {
            if (remoteApp != null && remoteApp.version > appData.version) {
              conflicts.add(ConflictInfo(
                entityType: 'credit_application',
                entityId: appData.id,
                localVersion: appData.version,
                remoteVersion: remoteApp.version,
                localLastModified: appData.lastModified,
                remoteLastModified: remoteApp.lastModified,
                conflictingFields: _findConflictingFieldsApp(
                  appData,
                  remoteApp,
                ),
              ));
            }
          },
        );
      }

      return Right(conflicts);
    } catch (e) {
      return Left(SyncFailure.unknown(e.toString()));
    }
  }

  List<String> _findConflictingFields(
    ClientsTableData local,
    Client remote,
  ) {
    final fields = <String>[];
    
    if (local.firstName != remote.firstName) fields.add('firstName');
    if (local.lastName != remote.lastName) fields.add('lastName');
    if (local.email != remote.email) fields.add('email');
    if (local.phone != remote.phone) fields.add('phone');
    if (local.address != remote.address) fields.add('address');
    
    return fields;
  }

  List<String> _findConflictingFieldsApp(
    CreditApplicationsTableData local,
    CreditApplication remote,
  ) {
    final fields = <String>[];
    
    if (local.requestedAmount != remote.requestedAmount) fields.add('requestedAmount');
    if (local.purpose != remote.purpose) fields.add('purpose');
    if (local.termMonths != remote.termMonths) fields.add('termMonths');
    if (local.status != remote.status) fields.add('status');
    if (local.approvedAmount != remote.approvedAmount) fields.add('approvedAmount');
    
    return fields;
  }

  Future<Either<Failure, ConflictResolutionResult>> resolveConflict(
    ConflictInfo conflict,
    ConflictStrategy strategy,
  ) async {
    try {
      switch (conflict.entityType) {
        case 'client':
          return _resolveClientConflict(conflict, strategy);
        case 'credit_application':
          return _resolveApplicationConflict(conflict, strategy);
        default:
          return Left(SyncFailure.unknown('Unknown entity type: ${conflict.entityType}'));
      }
    } catch (e) {
      return Left(SyncFailure.resolveFailed());
    }
  }

  Future<Either<Failure, ConflictResolutionResult>> _resolveClientConflict(
    ConflictInfo conflict,
    ConflictStrategy strategy,
  ) async {
    switch (strategy) {
      case ConflictStrategy.serverWins:
        return _resolveClientServerWins(conflict);
      case ConflictStrategy.clientWins:
        return _resolveClientClientWins(conflict);
      case ConflictStrategy.merge:
        return _resolveClientMerge(conflict);
      case ConflictStrategy.manual:
        return Left(SyncFailure.unknown('Manual resolution requires user interaction'));
    }
  }

  Future<Either<Failure, ConflictResolutionResult>> _resolveClientServerWins(
    ConflictInfo conflict,
  ) async {
    final remoteResult = await clientRepository.getRemoteClient(conflict.entityId);
    
    return remoteResult.fold(
      (failure) => Left(failure),
      (remoteClient) async {
        if (remoteClient == null) {
          return const ConflictResolutionResult(
            entityType: 'client',
            entityId: '',
            resolved: false,
            strategyUsed: ConflictStrategy.serverWins,
            errorMessage: 'Remote client not found',
          );
        }

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

        return ConflictResolutionResult(
          entityType: 'client',
          entityId: conflict.entityId,
          resolved: true,
          strategyUsed: ConflictStrategy.serverWins,
          resolvedEntity: remoteClient,
        );
      },
    );
  }

  Future<Either<Failure, ConflictResolutionResult>> _resolveClientClientWins(
    ConflictInfo conflict,
  ) async {
    final localClient = await database.getClientById(conflict.entityId);
    
    if (localClient == null) {
      return const ConflictResolutionResult(
        entityType: 'client',
        entityId: '',
        resolved: false,
        strategyUsed: ConflictStrategy.clientWins,
        errorMessage: 'Local client not found',
      );
    }

    final client = Client(
      id: localClient.id,
      firstName: localClient.firstName,
      lastName: localClient.lastName,
      email: localClient.email,
      phone: localClient.phone,
      address: localClient.address,
      identificationNumber: localClient.identificationNumber,
      syncStatus: SyncStatus.pending,
      version: localClient.version + 1,
      lastModified: DateTime.now(),
      createdAt: localClient.createdAt,
      syncedAt: localClient.syncedAt,
    );

    final syncResult = await clientRepository.syncClient(client);
    
    return syncResult.fold(
      (failure) => Left(failure),
      (syncedClient) async {
        await database.updateClientsSyncStatus([client.id], 'synced');
        
        return ConflictResolutionResult(
          entityType: 'client',
          entityId: conflict.entityId,
          resolved: true,
          strategyUsed: ConflictStrategy.clientWins,
          resolvedEntity: syncedClient,
        );
      },
    );
  }

  Future<Either<Failure, ConflictResolutionResult>> _resolveClientMerge(
    ConflictInfo conflict,
  ) async {
    final localClient = await database.getClientById(conflict.entityId);
    final remoteResult = await clientRepository.getRemoteClient(conflict.entityId);
    
    if (localClient == null) {
      return const ConflictResolutionResult(
        entityType: 'client',
        entityId: '',
        resolved: false,
        strategyUsed: ConflictStrategy.merge,
        errorMessage: 'Local client not found',
      );
    }

    return remoteResult.fold(
      (failure) => Left(failure),
      (remoteClient) async {
        if (remoteClient == null) {
          return const ConflictResolutionResult(
            entityType: 'client',
            entityId: '',
            resolved: false,
            strategyUsed: ConflictStrategy.merge,
            errorMessage: 'Remote client not found',
          );
        }

        final mergedClient = Client(
          id: localClient.id,
          firstName: conflict.localLastModified.isAfter(conflict.remoteLastModified)
              ? localClient.firstName
              : remoteClient.firstName,
          lastName: conflict.localLastModified.isAfter(conflict.remoteLastModified)
              ? localClient.lastName
              : remoteClient.lastName,
          email: conflict.localLastModified.isAfter(conflict.remoteLastModified)
              ? localClient.email
              : remoteClient.email,
          phone: conflict.localLastModified.isAfter(conflict.remoteLastModified)
              ? localClient.phone
              : remoteClient.phone,
          address: conflict.localLastModified.isAfter(conflict.remoteLastModified)
              ? localClient.address
              : remoteClient.address,
          identificationNumber: localClient.identificationNumber,
          syncStatus: SyncStatus.pending,
          version: (localClient.version > remoteClient.version 
              ? localClient.version 
              : remoteClient.version) + 1,
          lastModified: DateTime.now(),
          createdAt: localClient.createdAt,
          syncedAt: localClient.syncedAt,
        );

        final syncResult = await clientRepository.syncClient(mergedClient);
        
        return syncResult.fold(
          (failure) => Left(failure),
          (synced) async {
            await database.updateClientsSyncStatus([mergedClient.id], 'synced');
            
            return ConflictResolutionResult(
              entityType: 'client',
              entityId: conflict.entityId,
              resolved: true,
              strategyUsed: ConflictStrategy.merge,
              resolvedEntity: mergedClient,
            );
          },
        );
      },
    );
  }

  Future<Either<Failure, ConflictResolutionResult>> _resolveApplicationConflict(
    ConflictInfo conflict,
    ConflictStrategy strategy,
  ) async {
    switch (strategy) {
      case ConflictStrategy.serverWins:
        return _resolveAppServerWins(conflict);
      case ConflictStrategy.clientWins:
        return _resolveAppClientWins(conflict);
      case ConflictStrategy.merge:
        return _resolveAppMerge(conflict);
      case ConflictStrategy.manual:
        return Left(SyncFailure.unknown('Manual resolution requires user interaction'));
    }
  }

  Future<Either<Failure, ConflictResolutionResult>> _resolveAppServerWins(
    ConflictInfo conflict,
  ) async {
    final remoteResult = await creditApplicationRepository.getRemoteApplication(conflict.entityId);
    
    return remoteResult.fold(
      (failure) => Left(failure),
      (remoteApp) async {
        if (remoteApp == null) {
          return const ConflictResolutionResult(
            entityType: 'credit_application',
            entityId: '',
            resolved: false,
            strategyUsed: ConflictStrategy.serverWins,
            errorMessage: 'Remote application not found',
          );
        }

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

        return ConflictResolutionResult(
          entityType: 'credit_application',
          entityId: conflict.entityId,
          resolved: true,
          strategyUsed: ConflictStrategy.serverWins,
          resolvedEntity: remoteApp,
        );
      },
    );
  }

  Future<Either<Failure, ConflictResolutionResult>> _resolveAppClientWins(
    ConflictInfo conflict,
  ) async {
    final localApp = await database.getCreditApplicationById(conflict.entityId);
    
    if (localApp == null) {
      return const ConflictResolutionResult(
        entityType: 'credit_application',
        entityId: '',
        resolved: false,
        strategyUsed: ConflictStrategy.clientWins,
        errorMessage: 'Local application not found',
      );
    }

    final app = CreditApplication(
      id: localApp.id,
      clientId: localApp.clientId,
      requestedAmount: localApp.requestedAmount,
      purpose: localApp.purpose,
      termMonths: localApp.termMonths,
      status: localApp.status,
      syncStatus: SyncStatus.pending,
      version: localApp.version + 1,
      lastModified: DateTime.now(),
      createdAt: localApp.createdAt,
      syncedAt: localApp.syncedAt,
      rejectionReason: localApp.rejectionReason,
      approvedAmount: localApp.approvedAmount,
    );

    final syncResult = await creditApplicationRepository.syncApplication(app);
    
    return syncResult.fold(
      (failure) => Left(failure),
      (syncedApp) async {
        await database.updateCreditApplicationsSyncStatus([app.id], 'synced');
        
        return ConflictResolutionResult(
          entityType: 'credit_application',
          entityId: conflict.entityId,
          resolved: true,
          strategyUsed: ConflictStrategy.clientWins,
          resolvedEntity: syncedApp,
        );
      },
    );
  }

  Future<Either<Failure, ConflictResolutionResult>> _resolveAppMerge(
    ConflictInfo conflict,
  ) async {
    final localApp = await database.getCreditApplicationById(conflict.entityId);
    final remoteResult = await creditApplicationRepository.getRemoteApplication(conflict.entityId);
    
    if (localApp == null) {
      return const ConflictResolutionResult(
        entityType: 'credit_application',
        entityId: '',
        resolved: false,
        strategyUsed: ConflictStrategy.merge,
        errorMessage: 'Local application not found',
      );
    }

    return remoteResult.fold(
      (failure) => Left(failure),
      (remoteApp) async {
        if (remoteApp == null) {
          return const ConflictResolutionResult(
            entityType: 'credit_application',
            entityId: '',
            resolved: false,
            strategyUsed: ConflictStrategy.merge,
            errorMessage: 'Remote application not found',
          );
        }

        final mergedApp = CreditApplication(
          id: localApp.id,
          clientId: localApp.clientId,
          requestedAmount: conflict.localLastModified.isAfter(conflict.remoteLastModified)
              ? localApp.requestedAmount
              : remoteApp.requestedAmount,
          purpose: conflict.localLastModified.isAfter(conflict.remoteLastModified)
              ? localApp.purpose
              : remoteApp.purpose,
          termMonths: conflict.localLastModified.isAfter(conflict.remoteLastModified)
              ? localApp.termMonths
              : remoteApp.termMonths,
          status: conflict.localLastModified.isAfter(conflict.remoteLastModified)
              ? localApp.status
              : remoteApp.status,
          syncStatus: SyncStatus.pending,
          version: (localApp.version > remoteApp.version 
              ? localApp.version 
              : remoteApp.version) + 1,
          lastModified: DateTime.now(),
          createdAt: localApp.createdAt,
          syncedAt: localApp.syncedAt,
          rejectionReason: conflict.localLastModified.isAfter(conflict.remoteLastModified)
              ? localApp.rejectionReason
              : remoteApp.rejectionReason,
          approvedAmount: conflict.localLastModified.isAfter(conflict.remoteLastModified)
              ? localApp.approvedAmount
              : remoteApp.approvedAmount,
        );

        final syncResult = await creditApplicationRepository.syncApplication(mergedApp);
        
        return syncResult.fold(
          (failure) => Left(failure),
          (synced) async {
            await database.updateCreditApplicationsSyncStatus([mergedApp.id], 'synced');
            
            return ConflictResolutionResult(
              entityType: 'credit_application',
              entityId: conflict.entityId,
              resolved: true,
              strategyUsed: ConflictStrategy.merge,
              resolvedEntity: mergedApp,
            );
          },
        );
      },
    );
  }

  Future<Either<Failure, List<ConflictResolutionResult>>> resolveAllConflicts(
    ConflictStrategy defaultStrategy,
  ) async {
    final conflictsResult = await detectConflicts();
    
    return conflictsResult.fold(
      (failure) => Left(failure),
      (conflicts) async {
        final results = <ConflictResolutionResult>[];
        
        for (final conflict in conflicts) {
          final result = await resolveConflict(conflict, defaultStrategy);
          result.fold(
            (failure) {},
            (resolution) => results.add(resolution),
          );
        }
        
        return Right(results);
      },
    );
  }
}