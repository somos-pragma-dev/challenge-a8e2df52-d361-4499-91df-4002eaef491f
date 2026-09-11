package offline_field_app.presentation.providers;

import 'package:flutter/foundation.dart';
import 'package:offline_field_app/domain/entities/transaction.dart';
import 'package:offline_field_app/domain/repositories/transaction_repository.dart';
import 'package:offline_field_app/domain/usecases/create_transaction.dart';
import 'package:offline_field_app/domain/usecases/get_pending_transactions.dart';
import 'package:offline_field_app/core/errors/failures.dart';
import 'package:offline_field_app/core/errors/exceptions.dart';

enum TransactionListState { initial, loading, loaded, error }
enum TransactionCreateState { initial, creating, success, error }

class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _repository;
  final CreateTransaction _createTransactionUseCase;
  final GetPendingTransactions _getPendingTransactionsUseCase;

  TransactionProvider({
    required TransactionRepository repository,
    required CreateTransaction createTransactionUseCase,
    required GetPendingTransactions getPendingTransactionsUseCase,
  })  : _repository = repository,
        _createTransactionUseCase = createTransactionUseCase,
        _getPendingTransactionsUseCase = getPendingTransactionsUseCase;

  TransactionListState _listState = TransactionListState.initial;
  TransactionCreateState _createState = TransactionCreateState.initial;
  List<Transaction> _transactions = [];
  Transaction? _selectedTransaction;
  Failure? _lastFailure;
  String? _successMessage;

  TransactionListState get listState => _listState;
  TransactionCreateState get createState => _createState;
  List<Transaction> get transactions => List.unmodifiable(_transactions);
  Transaction? get selectedTransaction => _selectedTransaction;
  Failure? get lastFailure => _lastFailure;
  String? get successMessage => _successMessage;
  bool get isLoading => _listState == TransactionListState.loading;
  bool get isCreating => _createState == TransactionCreateState.creating;
  int get pendingCount => _transactions.where((t) => t.syncStatus == 'pending').length;
  int get failedCount => _transactions.where((t) => t.syncStatus == 'failed').length;

  Future<void> loadTransactions() async {
    _listState = TransactionListState.loading;
    _lastFailure = null;
    notifyListeners();

    try {
      final result = await _repository.getAllTransactions();
      result.fold(
        (failure) {
          _lastFailure = failure;
          _listState = TransactionListState.error;
        },
        (transactions) {
          _transactions = transactions;
          _listState = TransactionListState.loaded;
        },
      );
    } catch (e) {
      _lastFailure = const OfflineFailure.database('Failed to load transactions');
      _listState = TransactionListState.error;
    }
    notifyListeners();
  }

  Future<void> loadPendingTransactions() async {
    _listState = TransactionListState.loading;
    _lastFailure = null;
    notifyListeners();

    try {
      final result = await _getPendingTransactionsUseCase();
      result.fold(
        (failure) {
          _lastFailure = failure;
          _listState = TransactionListState.error;
        },
        (transactions) {
          _transactions = transactions;
          _listState = TransactionListState.loaded;
        },
      );
    } catch (e) {
      _lastFailure = const OfflineFailure.database('Failed to load pending transactions');
      _listState = TransactionListState.error;
    }
    notifyListeners();
  }

  Future<bool> createTransaction({
    required double amount,
    required String currency,
    required String transactionType,
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    _createState = TransactionCreateState.creating;
    _lastFailure = null;
    _successMessage = null;
    notifyListeners();

    try {
      final result = await _createTransactionUseCase(
        amount: amount,
        currency: currency,
        transactionType: transactionType,
        description: description,
        metadata: metadata,
      );

      return result.fold(
        (failure) {
          _lastFailure = failure;
          _createState = TransactionCreateState.error;
          notifyListeners();
          return false;
        },
        (transaction) {
          _transactions.insert(0, transaction);
          _createState = TransactionCreateState.success;
          _successMessage = 'Transaction created successfully';
          notifyListeners();
          return true;
        },
      );
    } on ValidationException catch (e) {
      _lastFailure = ValidationFailure(e.fieldErrors);
      _createState = TransactionCreateState.error;
      notifyListeners();
      return false;
    } catch (e) {
      _lastFailure = DatabaseFailure.transactionFailed(e.toString());
      _createState = TransactionCreateState.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTransaction(Transaction transaction) async {
    _listState = TransactionListState.loading;
    _lastFailure = null;
    notifyListeners();

    try {
      final result = await _repository.updateTransaction(transaction);
      return result.fold(
        (failure) {
          _lastFailure = failure;
          _listState = TransactionListState.error;
          notifyListeners();
          return false;
        },
        (updated) {
          final index = _transactions.indexWhere((t) => t.id == updated.id);
          if (index != -1) {
            _transactions[index] = updated;
          }
          _listState = TransactionListState.loaded;
          _successMessage = 'Transaction updated successfully';
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _lastFailure = DatabaseFailure.transactionFailed(e.toString());
      _listState = TransactionListState.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTransaction(String id) async {
    _listState = TransactionListState.loading;
    _lastFailure = null;
    notifyListeners();

    try {
      final result = await _repository.deleteTransaction(id);
      return result.fold(
        (failure) {
          _lastFailure = failure;
          _listState = TransactionListState.error;
          notifyListeners();
          return false;
        },
        (_) {
          _transactions.removeWhere((t) => t.id == id);
          _listState = TransactionListState.loaded;
          _successMessage = 'Transaction deleted successfully';
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _lastFailure = DatabaseFailure.transactionFailed(e.toString());
      _listState = TransactionListState.error;
      notifyListeners();
      return false;
    }
  }

  void selectTransaction(Transaction? transaction) {
    _selectedTransaction = transaction;
    notifyListeners();
  }

  Future<void> retryFailedTransaction(String id) async {
    final index = _transactions.indexWhere((t) => t.id == id);
    if (index != -1) {
      final transaction = _transactions[index];
      final updated = Transaction(
        id: transaction.id,
        externalId: transaction.externalId,
        amount: transaction.amount,
        currency: transaction.currency,
        transactionType: transaction.transactionType,
        description: transaction.description,
        metadata: transaction.metadata,
        createdAt: transaction.createdAt,
        updatedAt: DateTime.now(),
        version: transaction.version,
        syncStatus: 'pending',
        hash: transaction.hash,
      );
      await updateTransaction(updated);
    }
  }

  void clearMessages() {
    _lastFailure = null;
    _successMessage = null;
    notifyListeners();
  }

  void reset() {
    _listState = TransactionListState.initial;
    _createState = TransactionCreateState.initial;
    _transactions = [];
    _selectedTransaction = null;
    _lastFailure = null;
    _successMessage = null;
    notifyListeners();
  }
}