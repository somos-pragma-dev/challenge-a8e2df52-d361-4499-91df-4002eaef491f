import 'package:equatable/equatable.dart';
import '../../entities/transaction.dart';
import '../../repositories/transaction_repository.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/constants/app_constants.dart';

class ResolveConflictParams extends Equatable {
  final String entityId;
  final ConflictResolutionStrategy strategy;
  final Map<String, dynamic>? manualResolution;
  final bool notifyServer;

  const ResolveConflictParams({
    required this.entityId,
    required this.strategy,
    this.manualResolution,
    this.notifyServer = true,
  });

  @override
  List<Object?> get props => [entityId, strategy, manualResolution, notifyServer];
}

enum ConflictResolutionStrategy {
  serverWins,
  clientWins,
  lastWriteWins,
  manual,
  merge,
}

class ConflictData extends Equatable {
  final String entityId;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> serverData;
  final int localVersion;
  final int serverVersion;
  final DateTime localUpdatedAt;
  final DateTime serverUpdatedAt;
  final List<String> conflictingFields;

  const ConflictData({
    required this.entityId,
    required this.localData,
    required this.serverData,
    required this.localVersion,
    required this.serverVersion,
    required this.localUpdatedAt,
    required this.serverUpdatedAt,
    required this.conflictingFields,
  });

  @override
  List<Object?> get props => [
        entityId,
        localData,
        serverData,
        localVersion,
        serverVersion,
        localUpdatedAt,
        serverUpdatedAt,
        conflictingFields,
      ];
}

class ConflictResolutionResult extends Equatable {
  final bool success;
  final Transaction? resolvedTransaction;
  final String? errorMessage;
  final String resolutionType;

  const ConflictResolutionResult({
    required this.success,
    this.resolvedTransaction,
    this.errorMessage,
    required this.resolutionType,
  });

  @override
  List<Object?> get props => [success, resolvedTransaction, errorMessage, resolutionType];
}

abstract class ResolveConflictUseCase {
  Future<(ConflictData?, Failure?)> getConflictData(String entityId);
  Future<(List<ConflictData>, Failure?)> getAllConflicts();
  Future<(ConflictResolutionResult, Failure?)> call(ResolveConflictParams params);
  Future<(ConflictResolutionResult, Failure?)> autoResolve(String entityId, String strategy);
}

class ResolveConflictUseCaseImpl implements ResolveConflictUseCase {
  final TransactionRepository _repository;
  final int _maxMergeFields;

  ResolveConflictUseCaseImpl({
    required TransactionRepository repository,
    int maxMergeFields = 10,
  })  : _repository = repository,
        _maxMergeFields = maxMergeFields;

  @override
  Future<(ConflictData?, Failure?)> getConflictData(String entityId) async {
    try {
      final localTransaction = await _repository.getById(entityId);
      if (localTransaction == null) {
        return (null, DatabaseFailure.notFound('transactions', entityId));
      }

      final serverTransaction = await _repository.getServerTransactionById(entityId);
      if (serverTransaction == null) {
        return (null, const SyncFailure.serverError('Server version not available'));
      }

      final conflictData = _buildConflictData(localTransaction, serverTransaction);
      return (conflictData, null);
    } on OfflineException catch (e) {
      return (null, OfflineFailure.database(e.message));
    } catch (e) {
      return (null, DatabaseFailure.transactionFailed(e.toString()));
    }
  }

  @override
  Future<(List<ConflictData>, Failure?)> getAllConflicts() async {
    try {
      final pendingWithConflicts = await _repository.getPendingWithConflicts();
      final conflicts = <ConflictData>[];

      for (final localTx in pendingWithConflicts) {
        final serverTx = await _repository.getServerTransactionById(localTx.id);
        if (serverTx != null) {
          conflicts.add(_buildConflictData(localTx, serverTx));
        }
      }

      return (conflicts, null);
    } catch (e) {
      return (<ConflictData>[], DatabaseFailure.transactionFailed(e.toString()));
    }
  }

  @override
  Future<(ConflictResolutionResult, Failure?)> call(ResolveConflictParams params) async {
    try {
      final (conflictData, failure) = await getConflictData(params.entityId);
      if (failure != null || conflictData == null) {
        return (ConflictResolutionResult(
          success: false,
          errorMessage: failure?.message ?? 'Conflict data not found',
          resolutionType: 'failed',
        ), failure);
      }

      final resolution = _determineResolution(params.strategy, conflictData, params.manualResolution);
      final resolvedTransaction = await _applyResolution(params.entityId, resolution);

      if (params.notifyServer) {
        try {
          await _notifyServerOfResolution(params.entityId, resolution);
        } catch (_) {
          // Non-critical, resolution already applied locally
        }
      }

      return (ConflictResolutionResult(
        success: true,
        resolvedTransaction: resolvedTransaction,
        resolutionType: params.strategy.name,
      ), null);
    } on SyncConflictException catch (e) {
      return (ConflictResolutionResult(
        success: false,
        errorMessage: e.message,
        resolutionType: 'failed',
      ), ConflictFailure.unresolved(params.entityId));
    } catch (e) {
      return (ConflictResolutionResult(
        success: false,
        errorMessage: e.toString(),
        resolutionType: 'failed',
      ), ConflictFailure.unresolved(params.entityId));
    }
  }

  @override
  Future<(ConflictResolutionResult, Failure?)> autoResolve(
    String entityId,
    String strategy,
  ) async {
    final strategyEnum = _parseStrategy(strategy);
    final params = ResolveConflictParams(
      entityId: entityId,
      strategy: strategyEnum,
      notifyServer: true,
    );
    return call(params);
  }

  ConflictData _buildConflictData(Transaction local, Transaction server) {
    final localData = _transactionToMap(local);
    final serverData = _transactionToMap(server);
    final conflictingFields = <String>[];

    for (final key in localData.keys) {
      if (localData[key] != serverData[key]) {
        conflictingFields.add(key);
      }
    }

    return ConflictData(
      entityId: local.id,
      localData: localData,
      serverData: serverData,
      localVersion: local.version ?? 0,
      serverVersion: server.version ?? 0,
      localUpdatedAt: local.updatedAt,
      serverUpdatedAt: server.updatedAt,
      conflictingFields: conflictingFields,
    );
  }

  Map<String, dynamic> _transactionToMap(Transaction tx) {
    return {
      'id': tx.id,
      'externalId': tx.externalId,
      'amount': tx.amount,
      'currency': tx.currency,
      'transactionType': tx.transactionType,
      'description': tx.description,
      'metadata': tx.metadata,
      'version': tx.version,
      'updatedAt': tx.updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> _determineResolution(
    ConflictResolutionStrategy strategy,
    ConflictData conflictData,
    Map<String, dynamic>? manualResolution,
  ) {
    switch (strategy) {
      case ConflictResolutionStrategy.serverWins:
        return conflictData.serverData;
      case ConflictResolutionStrategy.clientWins:
        return conflictData.localData;
      case ConflictResolutionStrategy.lastWriteWins:
        if (conflictData.serverUpdatedAt.isAfter(conflictData.localUpdatedAt)) {
          return conflictData.serverData;
        }
        return conflictData.localData;
      case ConflictResolutionStrategy.manual:
        if (manualResolution != null) return manualResolution;
        return conflictData.localData;
      case ConflictResolutionStrategy.merge:
        return _mergeData(conflictData);
    }
  }

  Map<String, dynamic> _mergeData(ConflictData conflictData) {
    final merged = <String, dynamic>{};
    final allKeys = <String>{...conflictData.localData.keys, ...conflictData.serverData.keys};

    for (final key in allKeys) {
      if (key == 'version') {
        merged[key] = (conflictData.localVersion > conflictData.serverVersion
                ? conflictData.localVersion
                : conflictData.serverVersion) +
            1;
      } else if (conflictData.localData[key] == conflictData.serverData[key]) {
        merged[key] = conflictData.localData[key];
      } else if (conflictData.conflictingFields.contains(key)) {
        merged[key] = conflictData.serverData[key] ?? conflictData.localData[key];
      } else {
        merged[key] = conflictData.localData[key] ?? conflictData.serverData[key];
      }
    }

    return merged;
  }

  Future<Transaction> _applyResolution(
    String entityId,
    Map<String, dynamic> resolution,
  ) async {
    final resolved = resolution['version'] as int? ?? 1;
    final transaction = Transaction(
      id: entityId,
      externalId: resolution['externalId'] as String? ?? '',
      amount: (resolution['amount'] as num?)?.toDouble() ?? 0.0,
      currency: resolution['currency'] as String? ?? 'USD',
      transactionType: resolution['transactionType'] as String? ?? 'default',
      description: resolution['description'] as String? ?? '',
      metadata: resolution['metadata'] as Map<String, dynamic>?,
      version: resolved,
      syncStatus: 'pending',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _repository.resolveConflict(entityId, resolution, 'resolved');
    return transaction;
  }

  Future<void> _notifyServerOfResolution(
    String entityId,
    Map<String, dynamic> resolution,
  ) async {
    // Placeholder for server notification
    // In a real implementation, this would call the remote datasource
  }

  ConflictResolutionStrategy _parseStrategy(String strategy) {
    switch (strategy) {
      case 'server':
        return ConflictResolutionStrategy.serverWins;
      case 'client':
        return ConflictResolutionStrategy.clientWins;
      case 'last_write':
        return ConflictResolutionStrategy.lastWriteWins;
      case 'merge':
        return ConflictResolutionStrategy.merge;
      default:
        return ConflictResolutionStrategy.manual;
    }
  }
}