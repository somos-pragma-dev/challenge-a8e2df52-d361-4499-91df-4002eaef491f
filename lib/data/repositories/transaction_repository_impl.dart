package offline_field_app.data.repositories;

import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/transaction.dart' as domain;
import '../../domain/repositories/transaction_repository.dart';
import '../models/transaction_model.dart';
import '../datasources/local/transaction_local_datasource.dart';
import '../datasources/remote/transaction_remote_datasource.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;
  final TransactionRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final Uuid uuid;
  final Hash hash;

  TransactionRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
    required this.uuid,
    required this.hash,
  });

  @override
  Future<domain.Transaction> createTransaction(domain.Transaction transaction) async {
    final operationHash = _generateOperationHash(transaction);
    final existingRecord = await localDataSource.getTransactionByHash(operationHash);
    if (existingRecord != null) {
      throw IdempotencyException.duplicateOperation(operationHash, existingRecord.id);
    }

    final now = DateTime.now().toUtc();
    final transactionId = uuid.v4();
    final model = TransactionModel(
      id: transactionId,
      externalId: transaction.externalId,
      amount: transaction.amount,
      currency: transaction.currency,
      transactionType: transaction.transactionType,
      description: transaction.description,
      metadata: transaction.metadata,
      createdAt: now,
      updatedAt: now,
      version: 1,
      syncStatus: 'pending',
      hash: operationHash,
    );

    await localDataSource.insertTransaction(model);
    
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final remoteModel = await remoteDataSource.createTransaction(model.toJson());
        await localDataSource.updateTransactionSyncStatus(transactionId, 'completed', remoteModel.id);
        return _mapModelToEntity(
          await localDataSource.getTransactionById(transactionId)!,
        );
      } catch (e) {
        await localDataSource.updateTransactionSyncStatus(transactionId, 'failed', null);
        rethrow;
      }
    }

    return _mapModelToEntity(model);
  }

  @override
  Future<domain.Transaction?> getTransactionById(String id) async {
    final model = await localDataSource.getTransactionById(id);
    if (model == null) return null;
    return _mapModelToEntity(model);
  }

  @override
  Future<List<domain.Transaction>> getAllTransactions({int? limit, int? offset}) async {
    final models = await localDataSource.getAllTransactions(limit: limit, offset: offset);
    return models.map(_mapModelToEntity).toList();
  }

  @override
  Future<List<domain.Transaction>> getPendingTransactions() async {
    final models = await localDataSource.getPendingTransactions();
    return models.map(_mapModelToEntity).toList();
  }

  @override
  Future<domain.Transaction> updateTransaction(domain.Transaction transaction) async {
    final existing = await localDataSource.getTransactionById(transaction.id);
    if (existing == null) {
      throw const OfflineException.database('Transaction not found');
    }

    final newVersion = existing.version + 1;
    final operationHash = _generateOperationHash(transaction, existing.version);
    final model = TransactionModel(
      id: transaction.id,
      externalId: transaction.externalId,
      amount: transaction.amount,
      currency: transaction.currency,
      transactionType: transaction.transactionType,
      description: transaction.description,
      metadata: transaction.metadata,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now().toUtc(),
      version: newVersion,
      syncStatus: 'pending',
      hash: operationHash,
    );

    await localDataSource.updateTransaction(model);

    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        await remoteDataSource.updateTransaction(model.toJson());
        await localDataSource.updateTransactionSyncStatus(transaction.id, 'completed', null);
      } catch (e) {
        await localDataSource.updateTransactionSyncStatus(transaction.id, 'failed', null);
        rethrow;
      }
    }

    return _mapModelToEntity(model);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final existing = await localDataSource.getTransactionById(id);
    if (existing == null) {
      throw const OfflineException.database('Transaction not found');
    }

    await localDataSource.deleteTransaction(id);

    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        await remoteDataSource.deleteTransaction(id);
      } catch (e) {
        // Log error but don't throw - local delete succeeded
      }
    }
  }

  @override
  Future<List<domain.Transaction>> searchTransactions(String query) async {
    final models = await localDataSource.searchTransactions(query);
    return models.map(_mapModelToEntity).toList();
  }

  String _generateOperationHash(domain.Transaction transaction, [int? baseVersion]) {
    final content = '${transaction.amount}${transaction.currency}'
        '${transaction.transactionType}${transaction.description}'
        '${baseVersion ?? 0}';
    return hash.convert(content.codeUnits).toString();
  }

  domain.Transaction _mapModelToEntity(TransactionModel model) {
    return domain.Transaction(
      id: model.id,
      externalId: model.externalId,
      amount: model.amount,
      currency: model.currency,
      transactionType: model.transactionType,
      description: model.description,
      metadata: model.metadata,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      version: model.version,
      syncStatus: model.syncStatus,
    );
  }
}