import 'package:equatable/equatable.dart';
import '../../entities/transaction.dart';
import '../../entities/sync_record.dart';
import '../../repositories/transaction_repository.dart';
import '../../repositories/sync_repository.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/network_info.dart';
import '../../../core/constants/app_constants.dart';

class SyncTransactionsParams extends Equatable {
  final bool forceFullSync;
  final int? batchSize;
  final String? conflictStrategy;
  final bool enableRetry;

  const SyncTransactionsParams({
    this.forceFullSync = false,
    this.batchSize,
    this.conflictStrategy,
    this.enableRetry = true,
  });

  @override
  List<Object?> get props => [forceFullSync, batchSize, conflictStrategy, enableRetry];
}

class SyncResult extends Equatable {
  final int uploaded;
  final int downloaded;
  final int conflicts;
  final int failed;
  final Duration duration;
  final List<String> errorMessages;

  const SyncResult({
    required this.uploaded,
    required this.downloaded,
    required this.conflicts,
    required this.failed,
    required this.duration,
    this.errorMessages = const [],
  });

  bool get hasErrors => failed > 0 || conflicts > 0;
  bool get isPartialSuccess => (uploaded + downloaded) > 0 && hasErrors;
  bool get isFullSuccess => uploaded > 0 && failed == 0 && conflicts == 0;

  @override
  List<Object?> get props => [uploaded, downloaded, conflicts, failed, duration, errorMessages];
}

abstract class SyncTransactionsUseCase {
  Future<(SyncResult?, Failure?)> call(SyncTransactionsParams params);
  Future<void> cancelSync();
  Future<SyncStatus> getCurrentSyncStatus();
}

enum SyncStatus { idle, inProgress, failed, completed }

class SyncTransactionsUseCaseImpl implements SyncTransactionsUseCase {
  final TransactionRepository _transactionRepository;
  final SyncRepository _syncRepository;
  final NetworkInfo _networkInfo;
  final int _maxRetryAttempts;
  final int _retryDelaySeconds;
  final int _defaultBatchSize;
  bool _isCancelled = false;

  SyncTransactionsUseCaseImpl({
    required TransactionRepository transactionRepository,
    required SyncRepository syncRepository,
    required NetworkInfo networkInfo,
    int maxRetryAttempts = 3,
    int retryDelaySeconds = 5,
    int defaultBatchSize = 50,
  })  : _transactionRepository = transactionRepository,
        _syncRepository = syncRepository,
        _networkInfo = networkInfo,
        _maxRetryAttempts = maxRetryAttempts,
        _retryDelaySeconds = retryDelaySeconds,
        _defaultBatchSize = defaultBatchSize;

  @override
  Future<(SyncResult?, Failure?)> call(SyncTransactionsParams params) async {
    _isCancelled = false;
    final startTime = DateTime.now();

    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      return (null, const OfflineFailure.networkUnavailable());
    }

    try {
      final batchSize = params.batchSize ?? _defaultBatchSize;
      final pendingTransactions = await _transactionRepository.getPendingTransactions(
        limit: batchSize,
      );

      if (pendingTransactions.isEmpty) {
        return (SyncResult(
          uploaded: 0,
          downloaded: 0,
          conflicts: 0,
          failed: 0,
          duration: DateTime.now().difference(startTime),
        ), null);
      }

      int uploaded = 0;
      int conflicts = 0;
      int failed = 0;
      final errorMessages = <String>[];

      for (final transaction in pendingTransactions) {
        if (_isCancelled) break;

        final syncResult = await _syncSingleTransaction(
          transaction,
          params.conflictStrategy ?? AppConstants.conflictStrategyLastWriteWins,
          params.enableRetry,
        );

        switch (syncResult) {
          case _SyncSingleResult.success:
            uploaded++;
            break;
          case _SyncSingleResult.conflict:
            conflicts++;
            break;
          case _SyncSingleResult.failed:
            failed++;
            errorMessages.add('Failed to sync transaction ${transaction.id}');
            break;
        }
      }

      final serverTransactions = await _fetchServerChanges();
      int downloaded = 0;
      for (final serverTx in serverTransactions) {
        if (_isCancelled) break;
        await _applyServerTransaction(serverTx);
        downloaded++;
      }

      final duration = DateTime.now().difference(startTime);
      final result = SyncResult(
        uploaded: uploaded,
        downloaded: downloaded,
        conflicts: conflicts,
        failed: failed,
        duration: duration,
        errorMessages: errorMessages,
      );

      if (failed > 0) {
        return (result, SyncFailure.batchFailed(failed, pendingTransactions.length));
      }

      return (result, null);
    } on SyncConflictException catch (e) {
      return (null, ConflictFailure.detected(e.entityId, e.localData, e.serverData));
    } on NetworkException catch (e) {
      return (null, SyncFailure.serverError(e.message));
    } catch (e) {
      return (null, SyncFailure.serverError(e.toString()));
    }
  }

  Future<_SyncSingleResult> _syncSingleTransaction(
    Transaction transaction,
    String conflictStrategy,
    bool enableRetry,
  ) async {
    int attempts = 0;
    while (attempts <= _maxRetryAttempts) {
      if (_isCancelled) return _SyncSingleResult.failed;

      try {
        final result = await _transactionRepository.syncTransaction(transaction);
        if (result.hasConflict) {
          return _handleConflict(transaction, result.serverData!, conflictStrategy);
        }
        await _updateSyncRecord(transaction.id, true, null);
        return _SyncSingleResult.success;
      } catch (e) {
        attempts++;
        if (attempts > _maxRetryAttempts || !enableRetry) {
          await _updateSyncRecord(transaction.id, false, e.toString());
          return _SyncSingleResult.failed;
        }
        await Future.delayed(Duration(seconds: _retryDelaySeconds * attempts));
      }
    }
    return _SyncSingleResult.failed;
  }

  Future<_SyncSingleResult> _handleConflict(
    Transaction transaction,
    Map<String, dynamic> serverData,
    String strategy,
  ) async {
    switch (strategy) {
      case AppConstants.conflictStrategyServerWins:
        await _transactionRepository.resolveConflict(
          transaction.id,
          serverData,
          'server',
        );
        return _SyncSingleResult.success;
      case AppConstants.conflictStrategyClientWins:
        await _transactionRepository.forceSync(transaction);
        return _SyncSingleResult.success;
      case AppConstants.conflictStrategyManual:
        return _SyncSingleResult.conflict;
      default:
        final localVersion = transaction.version ?? 0;
        final serverVersion = serverData['version'] as int? ?? 0;
        if (serverVersion > localVersion) {
          await _transactionRepository.resolveConflict(
            transaction.id,
            serverData,
            'server',
          );
        } else {
          await _transactionRepository.forceSync(transaction);
        }
        return _SyncSingleResult.success;
    }
  }

  Future<List<Transaction>> _fetchServerChanges() async {
    return await _transactionRepository.getServerTransactions();
  }

  Future<void> _applyServerTransaction(Transaction serverTx) async {
    final localTx = await _transactionRepository.getByExternalId(serverTx.externalId);
    if (localTx == null) {
      await _transactionRepository.create(serverTx);
    } else if ((localTx.version ?? 0) < (serverTx.version ?? 0)) {
      await _transactionRepository.update(serverTx);
    }
  }

  Future<void> _updateSyncRecord(String entityId, bool success, String? error) async {
    final record = SyncRecord(
      id: '',
      entityId: entityId,
      entityType: 'transaction',
      operationType: 'sync',
      status: success ? 'completed' : 'failed',
      retryCount: 0,
      errorMessage: error,
      createdAt: DateTime.now(),
      lastAttempt: DateTime.now(),
    );
    await _syncRepository.saveSyncRecord(record);
  }

  @override
  Future<void> cancelSync() async {
    _isCancelled = true;
  }

  @override
  Future<SyncStatus> getCurrentSyncStatus() async {
    final pendingCount = await _transactionRepository.getPendingCount();
    if (pendingCount > 0) return SyncStatus.idle;
    return SyncStatus.completed;
  }
}

enum _SyncSingleResult { success, conflict, failed }