import 'package:equatable/equatable.dart';
import '../../entities/transaction.dart';
import '../../repositories/transaction_repository.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/exceptions.dart';

class GetPendingTransactionsParams extends Equatable {
  final int? limit;
  final int? offset;
  final String? transactionType;
  final DateTime? fromDate;
  final DateTime? toDate;

  const GetPendingTransactionsParams({
    this.limit,
    this.offset,
    this.transactionType,
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [limit, offset, transactionType, fromDate, toDate];
}

class PendingTransactionInfo extends Equatable {
  final Transaction transaction;
  final int retryCount;
  final DateTime? lastAttempt;
  final String? lastError;
  final DateTime createdAt;

  const PendingTransactionInfo({
    required this.transaction,
    required this.retryCount,
    this.lastAttempt,
    this.lastError,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [transaction, retryCount, lastAttempt, lastError, createdAt];
}

abstract class GetPendingTransactionsUseCase {
  Future<(List<PendingTransactionInfo>, Failure?)> call(GetPendingTransactionsParams params);
  Future<int> getTotalPendingCount();
  Future<Map<String, int>> getPendingCountByType();
}

class GetPendingTransactionsUseCaseImpl implements GetPendingTransactionsUseCase {
  final TransactionRepository _repository;
  final int _defaultPageSize;
  final int _maxPageSize;

  GetPendingTransactionsUseCaseImpl({
    required TransactionRepository repository,
    int defaultPageSize = 20,
    int maxPageSize = 100,
  })  : _repository = repository,
        _defaultPageSize = defaultPageSize,
        _maxPageSize = maxPageSize;

  @override
  Future<(List<PendingTransactionInfo>, Failure?)> call(GetPendingTransactionsParams params) async {
    try {
      final effectiveLimit = _resolveLimit(params.limit);
      final effectiveOffset = params.offset ?? 0;

      final pendingTransactions = await _repository.getPendingTransactions(
        limit: effectiveLimit,
        offset: effectiveOffset,
        transactionType: params.transactionType,
        fromDate: params.fromDate,
        toDate: params.toDate,
      );

      final result = <PendingTransactionInfo>[];
      for (final transaction in pendingTransactions) {
        final syncRecords = await _repository.getSyncRecordsForEntity(transaction.id);
        final latestRecord = syncRecords.isNotEmpty ? syncRecords.first : null;

        result.add(PendingTransactionInfo(
          transaction: transaction,
          retryCount: latestRecord?.retryCount ?? 0,
          lastAttempt: latestRecord?.lastAttempt,
          lastError: latestRecord?.errorMessage,
          createdAt: transaction.createdAt,
        ));
      }

      return (result, null);
    } on OfflineException catch (e) {
      return ( <PendingTransactionInfo>[], OfflineFailure.database(e.message));
    } catch (e) {
      return ( <PendingTransactionInfo>[], DatabaseFailure.transactionFailed(e.toString()));
    }
  }

  @override
  Future<int> getTotalPendingCount() async {
    try {
      return await _repository.getPendingCount();
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<Map<String, int>> getPendingCountByType() async {
    try {
      final allPending = await _repository.getPendingTransactions(limit: 1000);
      final counts = <String, int>{};
      for (final tx in allPending) {
        counts[tx.transactionType] = (counts[tx.transactionType] ?? 0) + 1;
      }
      return counts;
    } catch (e) {
      return {};
    }
  }

  int _resolveLimit(int? requestedLimit) {
    if (requestedLimit == null || requestedLimit <= 0) {
      return _defaultPageSize;
    }
    return requestedLimit > _maxPageSize ? _maxPageSize : requestedLimit;
  }
}