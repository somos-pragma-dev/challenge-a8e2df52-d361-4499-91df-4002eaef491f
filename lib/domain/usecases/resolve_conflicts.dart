package credit_field_app.domain.usecases;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../core/error/failures.dart';
import '../entities/client.dart';
import '../entities/credit_application.dart';
import '../entities/sync_status.dart';
import '../repositories/client_repository.dart';
import '../repositories/credit_application_repository.dart';

enum ConflictResolutionStrategy {
  lastWriteWins,
  serverWins,
  clientWins,
  manual,
}

class ConflictResolutionParams extends Equatable {
  final ConflictResolutionStrategy strategy;
  final bool resolveAllAutomatically;
  final List<String>? specificClientIds;
  final List<String>? specificApplicationIds;

  const ConflictResolutionParams({
    this.strategy = ConflictResolutionStrategy.lastWriteWins,
    this.resolveAllAutomatically = false,
    this.specificClientIds,
    this.specificApplicationIds,
  });

  @override
  List<Object?> get props => [
        strategy,
        resolveAllAutomatically,
        specificClientIds,
        specificApplicationIds,
      ];
}

class ConflictInfo extends Equatable {
  final String entityType;
  final String entityId;
  final dynamic localVersion;
  final dynamic serverVersion;
  final DateTime localLastModified;
  final DateTime serverLastModified;
  final Map<String, dynamic>? localData;
  final Map<String, dynamic>? serverData;

  const ConflictInfo({
    required this.entityType,
    required this.entityId,
    required this.localVersion,
    required this.serverVersion,
    required this.localLastModified,
    required this.serverLastModified,
    this.localData,
    this.serverData,
  });

  bool get localIsNewer => localLastModified.isAfter(serverLastModified);
  bool get serverIsNewer => serverLastModified.isAfter(localLastModified);

  @override
  List<Object?> get props => [
        entityType,
        entityId,
        localVersion,
        serverVersion,
        localLastModified,
        serverLastModified,
        localData,
        serverData,
      ];
}

class ConflictResolutionResult extends Equatable {
  final int totalConflicts;
  final int resolved;
  final int failed;
  final int skipped;
  final List<String> resolvedClientIds;
  final List<String> resolvedApplicationIds;
  final List<ConflictInfo> unresolvedConflicts;

  const ConflictResolutionResult({
    required this.totalConflicts,
    required this.resolved,
    required this.failed,
    required this.skipped,
    required this.resolvedClientIds,
    required this.resolvedApplicationIds,
    required this.unresolvedConflicts,
  });

  bool get hasUnresolved => unresolvedConflicts.isNotEmpty;
  double get resolutionRate =>
      totalConflicts > 0 ? (resolved / totalConflicts) * 100 : 0;

  @override
  List<Object?> get props => [
        totalConflicts,
        resolved,
        failed,
        skipped,
        resolvedClientIds,
        resolvedApplicationIds,
        unresolvedConflicts,
      ];
}

class ResolveConflicts {
  final ClientRepository clientRepository;
  final CreditApplicationRepository creditApplicationRepository;

  ResolveConflicts({
    required this.clientRepository,
    required this.creditApplicationRepository,
  });

  Future<Either<Failure, ConflictResolutionResult>> call(
    ConflictResolutionParams params,
  ) async {
    try {
      final List<ConflictInfo> allConflicts = [];
      final List<String> resolvedClientIds = [];
      final List<String> resolvedApplicationIds = [];
      final List<ConflictInfo> unresolvedConflicts = [];

      final clientsResult = await _getConflictedClients(params);
      final applicationsResult = await _getConflictedApplications(params);

      clientsResult.fold(
        (failure) => Left(failure),
        (clientConflicts) => allConflicts.addAll(clientConflicts),
      );

      applicationsResult.fold(
        (failure) => Left(failure),
        (applicationConflicts) => allConflicts.addAll(applicationConflicts),
      );

      if (allConflicts.isEmpty) {
        return const Right(ConflictResolutionResult(
          totalConflicts: 0,
          resolved: 0,
          failed: 0,
          skipped: 0,
          resolvedClientIds: [],
          resolvedApplicationIds: [],
          unresolvedConflicts: [],
        ));
      }

      int resolved = 0;
      int failed = 0;
      int skipped = 0;

      for (final conflict in allConflicts) {
        if (params.strategy == ConflictResolutionStrategy.manual &&
            !params.resolveAllAutomatically) {
          skipped++;
          unresolvedConflicts.add(conflict);
          continue;
        }

        final resolutionResult = await _resolveSingleConflict(
          conflict,
          params.strategy,
        );

        resolutionResult.fold(
          (failure) {
            failed++;
            unresolvedConflicts.add(conflict);
          },
          (success) {
            resolved++;
            if (conflict.entityType == 'client') {
              resolvedClientIds.add(conflict.entityId);
            } else if (conflict.entityType == 'credit_application') {
              resolvedApplicationIds.add(conflict.entityId);
            }
          },
        );
      }

      return Right(ConflictResolutionResult(
        totalConflicts: allConflicts.length,
        resolved: resolved,
        failed: failed,
        skipped: skipped,
        resolvedClientIds: resolvedClientIds,
        resolvedApplicationIds: resolvedApplicationIds,
        unresolvedConflicts: unresolvedConflicts,
      ));
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  Future<Either<Failure, List<ConflictInfo>>> _getConflictedClients(
    ConflictResolutionParams params,
  ) async {
    final pendingResult = await clientRepository.getConflictedClients();

    return pendingResult.fold(
      (failure) => Left(failure),
      (clients) {
        final conflicts = <ConflictInfo>[];
        for (final client in clients) {
          if (params.specificClientIds != null &&
              !params.specificClientIds!.contains(client.id)) {
            continue;
          }

          final serverDataResult = 
              await clientRepository.getClientFromServer(client.id);

          serverDataResult.fold(
            (failure) {},
            (serverClient) {
              if (serverClient != null && 
                  serverClient.version > client.version) {
                conflicts.add(ConflictInfo(
                  entityType: 'client',
                  entityId: client.id,
                  localVersion: client.version,
                  serverVersion: serverClient.version,
                  localLastModified: client.lastModified,
                  serverLastModified: serverClient.lastModified,
                  localData: _clientToMap(client),
                  serverData: _clientToMap(serverClient),
                ));
              }
            },
          );
        }
        return Right(conflicts);
      },
    );
  }

  Future<Either<Failure, List<ConflictInfo>>> _getConflictedApplications(
    ConflictResolutionParams params,
  ) async {
    final pendingResult = 
        await creditApplicationRepository.getConflictedApplications();

    return pendingResult.fold(
      (failure) => Left(failure),
      (applications) {
        final conflicts = <ConflictInfo>[];
        for (final application in applications) {
          if (params.specificApplicationIds != null &&
              !params.specificApplicationIds!.contains(application.id)) {
            continue;
          }

          final serverDataResult = await creditApplicationRepository
              .getCreditApplicationFromServer(application.id);

          serverDataResult.fold(
            (failure) {},
            (serverApplication) {
              if (serverApplication != null &&
                  serverApplication.version > application.version) {
                conflicts.add(ConflictInfo(
                  entityType: 'credit_application',
                  entityId: application.id,
                  localVersion: application.version,
                  serverVersion: serverApplication.version,
                  localLastModified: application.lastModified,
                  serverLastModified: serverApplication.lastModified,
                  localData: _applicationToMap(application),
                  serverData: _applicationToMap(serverApplication),
                ));
              }
            },
          );
        }
        return Right(conflicts);
      },
    );
  }

  Future<Either<Failure, bool>> _resolveSingleConflict(
    ConflictInfo conflict,
    ConflictResolutionStrategy strategy,
  ) async {
    try {
      final winnerData = _determineWinner(conflict, strategy);

      if (conflict.entityType == 'client') {
        return await _resolveClientConflict(conflict.entityId, winnerData);
      } else if (conflict.entityType == 'credit_application') {
        return await _resolveApplicationConflict(
            conflict.entityId, winnerData);
      }

      return const Right(false);
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  Map<String, dynamic> _determineWinner(
    ConflictInfo conflict,
    ConflictResolutionStrategy strategy,
  ) {
    switch (strategy) {
      case ConflictResolutionStrategy.lastWriteWins:
        return conflict.localIsNewer 
            ? conflict.localData! 
            : conflict.serverData!;
      case ConflictResolutionStrategy.serverWins:
        return conflict.serverData!;
      case ConflictResolutionStrategy.clientWins:
        return conflict.localData!;
      case ConflictResolutionStrategy.manual:
        return conflict.localData!;
    }
  }

  Future<Either<Failure, bool>> _resolveClientConflict(
    String clientId,
    Map<String, dynamic> winnerData,
  ) async {
    try {
      final clientResult = await clientRepository.getClientById(clientId);

      return clientResult.fold(
        (failure) => Left(failure),
        (client) async {
          if (client == null) {
            return const Right(false);
          }

          final updatedClient = client.copyWith(
            firstName: winnerData['firstName'] as String? ?? client.firstName,
            lastName: winnerData['lastName'] as String? ?? client.lastName,
            email: winnerData['email'] as String? ?? client.email,
            phone: winnerData['phone'] as String? ?? client.phone,
            address: winnerData['address'] as String? ?? client.address,
            identificationNumber: winnerData['identificationNumber'] 
                as String? ?? client.identificationNumber,
            syncStatus: SyncStatus.synced,
            version: winnerData['version'] as int? ?? (client.version + 1),
            syncedAt: DateTime.now(),
          );

          await clientRepository.saveClient(updatedClient);
          return const Right(true);
        },
      );
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  Future<Either<Failure, bool>> _resolveApplicationConflict(
    String applicationId,
    Map<String, dynamic> winnerData,
  ) async {
    try {
      final applicationResult = 
          await creditApplicationRepository.getCreditApplicationById(applicationId);

      return applicationResult.fold(
        (failure) => Left(failure),
        (application) async {
          if (application == null) {
            return const Right(false);
          }

          final updatedApplication = application.copyWith(
            requestedAmount: winnerData['requestedAmount'] 
                as double? ?? application.requestedAmount,
            purpose: winnerData['purpose'] as String? ?? application.purpose,
            termMonths: winnerData['termMonths'] as int? ?? application.termMonths,
            status: winnerData['status'] as String? ?? application.status,
            syncStatus: SyncStatus.synced,
            version: winnerData['version'] as int? ?? (application.version + 1),
            syncedAt: DateTime.now(),
          );

          await creditApplicationRepository
              .saveCreditApplication(updatedApplication);
          return const Right(true);
        },
      );
    } catch (e) {
      return Left(UnknownFailure.fromException(e));
    }
  }

  Map<String, dynamic> _clientToMap(Client client) {
    return {
      'id': client.id,
      'firstName': client.firstName,
      'lastName': client.lastName,
      'email': client.email,
      'phone': client.phone,
      'address': client.address,
      'identificationNumber': client.identificationNumber,
      'version': client.version,
      'lastModified': client.lastModified.toIso8601String(),
    };
  }

  Map<String, dynamic> _applicationToMap(CreditApplication application) {
    return {
      'id': application.id,
      'clientId': application.clientId,
      'requestedAmount': application.requestedAmount,
      'purpose': application.purpose,
      'termMonths': application.termMonths,
      'status': application.status,
      'version': application.version,
      'lastModified': application.lastModified.toIso8601String(),
    };
  }
}