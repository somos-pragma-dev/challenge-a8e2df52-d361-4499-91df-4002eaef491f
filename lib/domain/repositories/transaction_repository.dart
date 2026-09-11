library;

import 'package:equatable/equatable.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/sync_record.dart';

abstract class TransactionRepository {
  Future<Transaction> createTransaction(Transaction transaction);
  Future<Transaction> updateTransaction(Transaction transaction);
  Future<void> deleteTransaction(String id);
  Future<Transaction?> getTransactionById(String id);
  Future<Transaction?> getTransactionByExternalId(String externalId);
  Future<Transaction?> getTransactionByHash(String operationHash);
  Future<List<Transaction>> getAllTransactions();
  Future<List<Transaction>> getTransactionsBySyncStatus(String syncStatus);
  Future<List<Transaction>> getTransactionsByType(String transactionType);
  Future<List<Transaction>> getTransactionsByDateRange(DateTime startDate, DateTime endDate);
  Future<List<Transaction>> getPendingTransactions({int? limit, int? offset, String? transactionType, DateTime? fromDate, DateTime? toDate});
  Future<int> getTransactionCount();
  Future<int> getTransactionCountBySyncStatus(String syncStatus);
  Future<int> getPendingCount();
  Future<void> updateSyncStatus(String id, String syncStatus, {String? externalId});
  Future<void> updateSyncStatusBatch(List<String> ids, String syncStatus, {String? externalId});
  Stream<List<Transaction>> watchAllTransactions();
  Stream<List<Transaction>> watchTransactionsBySyncStatus(String syncStatus);
  Future<void> markAsSynced(String id, String externalId, int version);
  Future<void> markAsFailed(String id, String errorDetails);
  Future<List<Transaction>> getUnsyncedTransactions();
  Future<Map<String, dynamic>> exportTransactions(String startDate, String endDate);
  Future<void> importTransactions(Map<String, dynamic> data);
  Future<Transaction?> findByIdempotencyKey(String idempotencyKey);
  Future<void> incrementVersion(String id);
  Future<List<SyncRecord>> getSyncRecordsForEntity(String entityId);
  Future<Map<String, dynamic>?> syncTransaction(Transaction transaction);
  Future<void> resolveConflict(String entityId, Map<String, dynamic> serverData, String resolution);
  Future<void> forceSync(Transaction transaction);
  Future<List<Transaction>> getServerTransactions();
  Future<Transaction?> getByExternalId(String externalId);
  Future<Transaction?> create(Transaction transaction);
  Future<Transaction?> update(Transaction transaction);
  Future<Transaction?> getServerTransactionById(String entityId);
  Future<List<Transaction>> getPendingWithConflicts();
}

class TransactionFilter extends Equatable {
  final String? syncStatus;
  final String? transactionType;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? minAmount;
  final double? maxAmount;
  final String? currency;
  final bool? isDeleted;

  const TransactionFilter({
    this.syncStatus,
    this.transactionType,
    this.startDate,
    this.endDate,
    this.minAmount,
    this.maxAmount,
    this.currency,
    this.isDeleted,
  });

  TransactionFilter copyWith({
    String? syncStatus,
    String? transactionType,
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
    String? currency,
    bool? isDeleted,
  }) {
    return TransactionFilter(
      syncStatus: syncStatus ?? this.syncStatus,
      transactionType: transactionType ?? this.transactionType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      currency: currency ?? this.currency,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [
        syncStatus,
        transactionType,
        startDate,
        endDate,
        minAmount,
        maxAmount,
        currency,
        isDeleted,
      ];
}

class TransactionResult extends Equatable {
  final Transaction transaction;
  final bool isNew;
  final bool wasSynced;

  const TransactionResult({
    required this.transaction,
    required this.isNew,
    required this.wasSynced,
  });

  @override
  List<Object?> get props => [transaction, isNew, wasSynced];
}