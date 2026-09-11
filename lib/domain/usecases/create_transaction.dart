library;

import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class CreateTransaction {
  final TransactionRepository _repository;
  final Uuid _uuid;

  static const List<String> validTransactionTypes = [
    'payment',
    'refund',
    'transfer',
    'deposit',
    'withdrawal',
    'adjustment',
  ];

  static const List<String> validCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CAD',
    'AUD',
    'CHF',
    'MXN',
  ];

  static const double minAmount = 0.01;
  static const double maxAmount = 999999999.99;

  CreateTransaction(this._repository) : _uuid = const Uuid();

  Future<Transaction> execute(CreateTransactionParams params) async {
    await _validateInput(params);
    final operationHash = _generateOperationHash(params);
    await _checkIdempotency(operationHash, params.idempotencyKey);
    final transaction = _buildTransaction(params, operationHash);
    return await _repository.createTransaction(transaction);
  }

  Future<void> _validateInput(CreateTransactionParams params) async {
    final validationErrors = <String, List<String>>{};

    if (params.amount < minAmount || params.amount > maxAmount) {
      validationErrors['amount'] = [
        'Amount must be between $minAmount and $maxAmount',
      ];
    }

    if (!validTransactionTypes.contains(params.transactionType)) {
      validationErrors['transactionType'] = [
        'Invalid transaction type: ${params.transactionType}. Valid types: ${validTransactionTypes.join(", ")}',
      ];
    }

    if (!validCurrencies.contains(params.currency)) {
      validationErrors['currency'] = [
        'Invalid currency: ${params.currency}. Valid currencies: ${validCurrencies.join(", ")}',
      ];
    }

    if (params.description != null && params.description!.length > 500) {
      validationErrors['description'] = [
        'Description cannot exceed 500 characters',
      ];
    }

    if (params.metadata != null) {
      final metadataSize = params.metadata.toString().length;
      if (metadataSize > 10000) {
        validationErrors['metadata'] = [
          'Metadata cannot exceed 10000 characters',
        ];
      }
    }

    if (validationErrors.isNotEmpty) {
      throw ValidationException(
        'Validation failed for transaction creation',
        fieldErrors: validationErrors,
      );
    }
  }

  String _generateOperationHash(CreateTransactionParams params) {
    final hashInput = '${params.transactionType}:'
        '${params.amount}:'
        '${params.currency}:'
        '${params.description ?? ""}:'
        '${params.createdAt.toIso8601String()}';
    final bytes = hashInput.codeUnits;
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  Future<void> _checkIdempotency(
    String operationHash,
    String? idempotencyKey,
  ) async {
    if (idempotencyKey != null) {
      final existingByKey = await _repository.findByIdempotencyKey(idempotencyKey);
      if (existingByKey != null) {
        throw IdempotencyException.duplicateOperation(
          operationHash,
          existingRecordId: existingByKey.id,
        );
      }
    }

    final existingByHash = await _repository.getTransactionByHash(operationHash);
    if (existingByHash != null) {
      throw IdempotencyException.duplicateOperation(
        operationHash,
        existingRecordId: existingByHash.id,
      );
    }
  }

  Transaction _buildTransaction(
    CreateTransactionParams params,
    String operationHash,
  ) {
    final now = params.createdAt ?? DateTime.now();
    return Transaction(
      id: params.id ?? _uuid.v4(),
      externalId: null,
      amount: params.amount,
      currency: params.currency,
      transactionType: params.transactionType,
      description: params.description,
      metadata: params.metadata,
      createdAt: now,
      updatedAt: now,
      version: 1,
      syncStatus: 'pending',
      hash: operationHash,
    );
  }

  Future<Transaction> executeWithValidation(CreateTransactionParams params) async {
    try {
      return await execute(params);
    } on ValidationException catch (e) {
      throw ValidationFailure(
        'Transaction validation failed: ${e.message}',
        fieldErrors: e.fieldErrors,
      );
    } on IdempotencyException catch (e) {
      throw ConflictFailure.detected(
        e.existingRecordId ?? 'unknown',
        {'hash': e.operationHash},
        {'idempotencyKey': params.idempotencyKey},
      );
    } catch (e) {
      throw DatabaseFailure.transactionFailed('Failed to create transaction: $e');
    }
  }
}

class CreateTransactionParams {
  final String? id;
  final double amount;
  final String currency;
  final String transactionType;
  final String? description;
  final Map<String, dynamic>? metadata;
  final String? idempotencyKey;
  final DateTime? createdAt;

  const CreateTransactionParams({
    this.id,
    required this.amount,
    required this.currency,
    required this.transactionType,
    this.description,
    this.metadata,
    this.idempotencyKey,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'currency': currency,
      'transactionType': transactionType,
      'description': description,
      'metadata': metadata,
      'idempotencyKey': idempotencyKey,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory CreateTransactionParams.fromMap(Map<String, dynamic> map) {
    return CreateTransactionParams(
      id: map['id'] as String?,
      amount: (map['amount'] as num).toDouble(),
      currency: map['currency'] as String,
      transactionType: map['transactionType'] as String,
      description: map['description'] as String?,
      metadata: map['metadata'] as Map<String, dynamic>?,
      idempotencyKey: map['idempotencyKey'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
    );
  }
}