package lib.data.datasources.local;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lib/core/constants/app_constants.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._();

  static DatabaseHelper get instance {
    _instance ??= DatabaseHelper._();
    return _instance!;
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createTransactionsTable(db);
    await _createSyncRecordsTable(db);
    await _createPendingOperationsTable(db);
    await _createIndexes(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    for (var i = oldVersion; i < newVersion; i++) {
      await _runMigration(db, i);
    }
  }

  Future<void> _runMigration(Database db, int fromVersion) async {
    switch (fromVersion) {
      case 1:
        await _migrateToVersion2(db);
        break;
      case 2:
        await _migrateToVersion3(db);
        break;
    }
  }

  Future<void> _migrateToVersion2(Database db) async {
    await db.execute('''
      ALTER TABLE ${AppConstants.transactionsTable}
      ADD COLUMN ${DatabaseColumns.hash} TEXT
    ''');
  }

  Future<void> _migrateToVersion3(Database db) async {
    await db.execute('''
      CREATE INDEX idx_transactions_sync_status
      ON ${AppConstants.transactionsTable}(${DatabaseColumns.syncStatus})
    ''');
    await db.execute('''
      CREATE INDEX idx_sync_records_status
      ON ${AppConstants.syncRecordsTable}(${DatabaseColumns.syncStatus})
    ''');
  }

  Future<void> _createTransactionsTable(Database db) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.transactionsTable} (
        ${DatabaseColumns.id} TEXT PRIMARY KEY,
        ${DatabaseColumns.externalId} TEXT,
        ${DatabaseColumns.amount} REAL NOT NULL,
        ${DatabaseColumns.currency} TEXT NOT NULL,
        ${DatabaseColumns.transactionType} TEXT NOT NULL,
        ${DatabaseColumns.description} TEXT NOT NULL,
        ${DatabaseColumns.metadata} TEXT,
        ${DatabaseColumns.createdAt} TEXT NOT NULL,
        ${DatabaseColumns.updatedAt} TEXT NOT NULL,
        ${DatabaseColumns.version} INTEGER NOT NULL DEFAULT 1,
        ${DatabaseColumns.syncStatus} TEXT NOT NULL DEFAULT '${AppConstants.syncStatusPending}',
        ${DatabaseColumns.hash} TEXT
      )
    ''');
  }

  Future<void> _createSyncRecordsTable(Database db) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.syncRecordsTable} (
        ${DatabaseColumns.id} TEXT PRIMARY KEY,
        ${DatabaseColumns.uuid} TEXT NOT NULL,
        entity_type TEXT NOT NULL,
        ${DatabaseColumns.operationType} TEXT NOT NULL,
        payload TEXT,
        ${DatabaseColumns.hash} TEXT,
        ${DatabaseColumns.syncStatus} TEXT NOT NULL DEFAULT '${AppConstants.syncStatusPending}',
        ${DatabaseColumns.createdAt} TEXT NOT NULL,
        synced_at TEXT,
        retry_count INTEGER DEFAULT 0,
        error_message TEXT,
        ${DatabaseColumns.conflictData} TEXT,
        ${DatabaseColumns.version} INTEGER DEFAULT 1
      )
    ''');
  }

  Future<void> _createPendingOperationsTable(Database db) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.pendingOperationsTable} (
        ${DatabaseColumns.id} TEXT PRIMARY KEY,
        ${DatabaseColumns.uuid} TEXT NOT NULL,
        operation_type TEXT NOT NULL,
        payload TEXT NOT NULL,
        ${DatabaseColumns.hash} TEXT NOT NULL,
        created_at TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending'
      )
    ''');
  }

  Future<void> _createIndexes(Database db) async {
    await db.execute('''
      CREATE INDEX idx_transactions_created_at
      ON ${AppConstants.transactionsTable}(${DatabaseColumns.createdAt})
    ''');
    await db.execute('''
      CREATE INDEX idx_transactions_sync_status
      ON ${AppConstants.transactionsTable}(${DatabaseColumns.syncStatus})
    ''');
    await db.execute('''
      CREATE INDEX idx_sync_records_entity_id
      ON ${AppConstants.syncRecordsTable}(${DatabaseColumns.uuid})
    ''');
    await db.execute('''
      CREATE INDEX idx_sync_records_status
      ON ${AppConstants.syncRecordsTable}(${DatabaseColumns.syncStatus})
    ''');
  }

  Future<T> runInTransaction<T>(
    Future<T> Function(Transaction txn) action,
  ) async {
    final db = await database;
    return await db.transaction(action);
  }

  Future<void> runInTransactionVoid(
    Future<void> Function(Transaction txn) action,
  ) async {
    final db = await database;
    await db.transaction(action);
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertOrThrow(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    return await db.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  Future<Map<String, dynamic>?> queryById(String table, String id) async {
    final db = await database;
    final results = await db.query(
      table,
      where: '${DatabaseColumns.id} = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await database;
    return await db.update(
      table,
      data,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await database;
    return await db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<int> count(String table, {String? where, List<Object?>? whereArgs}) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $table${where != null ? ' WHERE $where' : ''}',
      whereArgs,
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    final db = await database;
    return await db.rawQuery(sql, arguments);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  Future<void> deleteDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  Future<void> clearTable(String table) async {
    final db = await database;
    await db.delete(table);
  }

  Future<void> clearAllTables() async {
    final db = await database;
    await db.delete(AppConstants.transactionsTable);
    await db.delete(AppConstants.syncRecordsTable);
    await db.delete(AppConstants.pendingOperationsTable);
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/sync_record.dart';
import '../models/transaction_model.dart';
import '../models/sync_record_model.dart';
import 'database_helper.dart';

class TransactionLocalDatasource {
  final DatabaseHelper _databaseHelper;
  final NetworkInfo _networkInfo;
  final Uuid _uuid;

  TransactionLocalDatasource({
    required DatabaseHelper databaseHelper,
    required NetworkInfo networkInfo,
    Uuid? uuid,
  })  : _databaseHelper = databaseHelper,
        _networkInfo = networkInfo,
        _uuid = uuid ?? const Uuid();

  Future<TransactionModel> createTransaction(Transaction transaction) async {
    try {
      final db = await _databaseHelper.database;
      final now = DateTime.now().toIso8601String();
      
      final id = _uuid.v4();
      final hash = _generateOperationHash(transaction);
      
      final model = TransactionModel(
        id: id,
        externalId: null,
        amount: transaction.amount,
        currency: transaction.currency,
        transactionType: transaction.transactionType,
        description: transaction.description,
        metadata: transaction.metadata,
        createdAt: now,
        updatedAt: now,
        version: 1,
        syncStatus: AppConstants.syncStatusPending,
        hash: hash,
      );

      await db.insert(
        AppConstants.transactionsTable,
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      final syncRecord = SyncRecordModel(
        id: _uuid.v4(),
        entityId: id,
        entityType: 'transaction',
        operationType: 'CREATE',
        payload: model.toMap(),
        createdAt: now,
        retryCount: 0,
        lastAttempt: null,
        status: AppConstants.syncStatusPending,
      );

      await db.insert(
        AppConstants.pendingOperationsTable,
        syncRecord.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return model;
    } catch (e) {
      throw OfflineException.database('Failed to create transaction: $e');
    }
  }

  Future<TransactionModel?> getTransactionById(String id) async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        AppConstants.transactionsTable,
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (results.isEmpty) {
        return null;
      }

      return TransactionModel.fromMap(results.first);
    } catch (e) {
      throw OfflineException.database('Failed to get transaction: $e');
    }
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        AppConstants.transactionsTable,
        orderBy: '${DatabaseColumns.createdAt} DESC',
      );

      return results.map((map) => TransactionModel.fromMap(map)).toList();
    } catch (e) {
      throw OfflineException.database('Failed to get all transactions: $e');
    }
  }

  Future<List<TransactionModel>> getPendingTransactions() async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        AppConstants.transactionsTable,
        where: '${DatabaseColumns.syncStatus} = ?',
        whereArgs: [AppConstants.syncStatusPending],
        orderBy: '${DatabaseColumns.createdAt} ASC',
      );

      return results.map((map) => TransactionModel.fromMap(map)).toList();
    } catch (e) {
      throw OfflineException.database('Failed to get pending transactions: $e');
    }
  }

  Future<List<TransactionModel>> getTransactionsByStatus(String status) async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        AppConstants.transactionsTable,
        where: '${DatabaseColumns.syncStatus} = ?',
        whereArgs: [status],
        orderBy: '${DatabaseColumns.createdAt} DESC',
      );

      return results.map((map) => TransactionModel.fromMap(map)).toList();
    } catch (e) {
      throw OfflineException.database('Failed to get transactions by status: $e');
    }
  }

  Future<TransactionModel> updateTransaction(TransactionModel model) async {
    try {
      final db = await _databaseHelper.database;
      final now = DateTime.now().toIso8601String();
      
      final updatedModel = model.copyWith(
        updatedAt: now,
        version: model.version + 1,
        syncStatus: AppConstants.syncStatusPending,
      );

      await db.update(
        AppConstants.transactionsTable,
        updatedModel.toMap(),
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [model.id],
      );

      final syncRecord = SyncRecordModel(
        id: _uuid.v4(),
        entityId: model.id,
        entityType: 'transaction',
        operationType: 'UPDATE',
        payload: updatedModel.toMap(),
        createdAt: now,
        retryCount: 0,
        lastAttempt: null,
        status: AppConstants.syncStatusPending,
      );

      await db.insert(
        AppConstants.pendingOperationsTable,
        syncRecord.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return updatedModel;
    } catch (e) {
      throw OfflineException.database('Failed to update transaction: $e');
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      final db = await _databaseHelper.database;
      final now = DateTime.now().toIso8601String();

      await db.delete(
        AppConstants.transactionsTable,
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [id],
      );

      final syncRecord = SyncRecordModel(
        id: _uuid.v4(),
        entityId: id,
        entityType: 'transaction',
        operationType: 'DELETE',
        payload: {'id': id},
        createdAt: now,
        retryCount: 0,
        lastAttempt: null,
        status: AppConstants.syncStatusPending,
      );

      await db.insert(
        AppConstants.pendingOperationsTable,
        syncRecord.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw OfflineException.database('Failed to delete transaction: $e');
    }
  }

  Future<void> markTransactionAsSynced(String id, String? externalId) async {
    try {
      final db = await _databaseHelper.database;
      await db.update(
        AppConstants.transactionsTable,
        {
          DatabaseColumns.syncStatus: AppConstants.syncStatusCompleted,
          DatabaseColumns.externalId: externalId,
        },
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw OfflineException.database('Failed to mark transaction as synced: $e');
    }
  }

  Future<void> markTransactionAsFailed(String id) async {
    try {
      final db = await _databaseHelper.database;
      await db.update(
        AppConstants.transactionsTable,
        {DatabaseColumns.syncStatus: AppConstants.syncStatusFailed},
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw OfflineException.database('Failed to mark transaction as failed: $e');
    }
  }

  Future<bool> isOperationIdempotent(String operationHash) async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        AppConstants.transactionsTable,
        where: '${DatabaseColumns.hash} = ?',
        whereArgs: [operationHash],
        limit: 1,
      );

      return results.isNotEmpty;
    } catch (e) {
      throw OfflineException.database('Failed to check idempotency: $e');
    }
  }

  Future<int> getPendingCount() async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${AppConstants.transactionsTable} WHERE ${DatabaseColumns.syncStatus} = ?',
        [AppConstants.syncStatusPending],
      );

      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw OfflineException.database('Failed to get pending count: $e');
    }
  }

  String _generateOperationHash(Transaction transaction) {
    final data = '${transaction.amount}${transaction.currency}${transaction.transactionType}${transaction.description}${DateTime.now().millisecondsSinceEpoch}';
    return sha256.convert(data.codeUnits).toString();
  }

  Future<void> markTransactionAsConflict(
    String id,
    Map<String, dynamic> conflictData,
  ) async {
    try {
      final db = await _databaseHelper.database;
      await db.update(
        AppConstants.transactionsTable,
        {
          DatabaseColumns.syncStatus: AppConstants.syncStatusConflict,
          DatabaseColumns.metadata: conflictData.toString(),
        },
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw OfflineException.database('Failed to mark transaction as conflict: $e');
    }
  }

  Future<void> resolveConflict(
    String id,
    TransactionModel resolvedModel,
    String strategy,
  ) async {
    try {
      final db = await _databaseHelper.database;
      final now = DateTime.now().toIso8601String();
      
      await db.update(
        AppConstants.transactionsTable,
        {
          DatabaseColumns.amount: resolvedModel.amount,
          DatabaseColumns.currency: resolvedModel.currency,
          DatabaseColumns.transactionType: resolvedModel.transactionType,
          DatabaseColumns.description: resolvedModel.description,
          DatabaseColumns.metadata: resolvedModel.metadata,
          DatabaseColumns.updatedAt: now,
          DatabaseColumns.version: resolvedModel.version,
          DatabaseColumns.syncStatus: AppConstants.syncStatusPending,
        },
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw OfflineException.database('Failed to resolve conflict: $e');
    }
  }
}