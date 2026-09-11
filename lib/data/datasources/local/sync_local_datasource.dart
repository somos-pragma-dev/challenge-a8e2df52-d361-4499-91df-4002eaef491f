import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/sync_record.dart';
import '../models/sync_record_model.dart';
import 'database_helper.dart';

class SyncLocalDatasource {
  final DatabaseHelper _databaseHelper;
  final Uuid _uuid;

  SyncLocalDatasource({
    required DatabaseHelper databaseHelper,
    Uuid? uuid,
  })  : _databaseHelper = databaseHelper,
        _uuid = uuid ?? const Uuid();

  Future<SyncRecordModel> createSyncRecord(SyncRecord syncRecord) async {
    try {
      final db = await _databaseHelper.database;
      final now = DateTime.now().toIso8601String();

      final model = SyncRecordModel(
        id: syncRecord.id ?? _uuid.v4(),
        entityId: syncRecord.entityId,
        entityType: syncRecord.entityType,
        operationType: syncRecord.operationType,
        payload: syncRecord.payload,
        createdAt: syncRecord.createdAt ?? now,
        retryCount: syncRecord.retryCount ?? 0,
        lastAttempt: syncRecord.lastAttempt,
        status: syncRecord.status ?? AppConstants.syncStatusPending,
      );

      await db.insert(
        AppConstants.pendingOperationsTable,
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return model;
    } catch (e) {
      throw OfflineException.database('Failed to create sync record: $e');
    }
  }

  Future<SyncRecordModel?> getSyncRecordById(String id) async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        AppConstants.pendingOperationsTable,
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (results.isEmpty) {
        return null;
      }

      return SyncRecordModel.fromMap(results.first);
    } catch (e) {
      throw OfflineException.database('Failed to get sync record: $e');
    }
  }

  Future<List<SyncRecordModel>> getPendingSyncRecords() async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        AppConstants.pendingOperationsTable,
        where: '${DatabaseColumns.syncStatus} = ?',
        whereArgs: [AppConstants.syncStatusPending],
        orderBy: '${DatabaseColumns.createdAt} ASC',
      );

      return results.map((map) => SyncRecordModel.fromMap(map)).toList();
    } catch (e) {
      throw OfflineException.database('Failed to get pending sync records: $e');
    }
  }

  Future<List<SyncRecordModel>> getFailedSyncRecords() async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        AppConstants.pendingOperationsTable,
        where: '${DatabaseColumns.syncStatus} = ?',
        whereArgs: [AppConstants.syncStatusFailed],
        orderBy: '${DatabaseColumns.createdAt} ASC',
      );

      return results.map((map) => SyncRecordModel.fromMap(map)).toList();
    } catch (e) {
      throw OfflineException.database('Failed to get failed sync records: $e');
    }
  }

  Future<List<SyncRecordModel>> getSyncRecordsByEntityId(String entityId) async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        AppConstants.pendingOperationsTable,
        where: 'entity_id = ?',
        whereArgs: [entityId],
        orderBy: '${DatabaseColumns.createdAt} DESC',
      );

      return results.map((map) => SyncRecordModel.fromMap(map)).toList();
    } catch (e) {
      throw OfflineException.database('Failed to get sync records by entity: $e');
    }
  }

  Future<SyncRecordModel> updateSyncRecord(SyncRecordModel model) async {
    try {
      final db = await _databaseHelper.database;

      await db.update(
        AppConstants.pendingOperationsTable,
        model.toMap(),
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [model.id],
      );

      return model;
    } catch (e) {
      throw OfflineException.database('Failed to update sync record: $e');
    }
  }

  Future<void> deleteSyncRecord(String id) async {
    try {
      final db = await _databaseHelper.database;
      await db.delete(
        AppConstants.pendingOperationsTable,
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw OfflineException.database('Failed to delete sync record: $e');
    }
  }

  Future<void> markSyncRecordAsCompleted(String id) async {
    try {
      final db = await _databaseHelper.database;
      await db.update(
        AppConstants.pendingOperationsTable,
        {DatabaseColumns.syncStatus: AppConstants.syncStatusCompleted},
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw OfflineException.database('Failed to mark sync record as completed: $e');
    }
  }

  Future<void> markSyncRecordAsFailed(String id) async {
    try {
      final db = await _databaseHelper.database;
      await db.update(
        AppConstants.pendingOperationsTable,
        {
          DatabaseColumns.syncStatus: AppConstants.syncStatusFailed,
          DatabaseColumns.operationType: 'RETRY',
        },
        where: '${DatabaseColumns.id} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw OfflineException.database('Failed to mark sync record as failed: $e');
    }
  }

  Future<void> incrementRetryCount(String id) async {
    try {
      final db = await _databaseHelper.database;
      final record = await getSyncRecordById(id);
      
      if (record != null) {
        await db.update(
          AppConstants.pendingOperationsTable,
          {
            DatabaseColumns.operationType: record.retryCount + 1,
            DatabaseColumns.syncStatus: record.lastAttempt = DateTime.now().toIso8601String(),
          },
          where: '${DatabaseColumns.id} = ?',
          whereArgs: [id],
        );
      }
    } catch (e) {
      throw OfflineException.database('Failed to increment retry count: $e');
    }
  }

  Future<void> deleteCompletedSyncRecords() async {
    try {
      final db = await _databaseHelper.database;
      await db.delete(
        AppConstants.pendingOperationsTable,
        where: '${DatabaseColumns.syncStatus} = ?',
        whereArgs: [AppConstants.syncStatusCompleted],
      );
    } catch (e) {
      throw OfflineException.database('Failed to delete completed sync records: $e');
    }
  }

  Future<int> getPendingCount() async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${AppConstants.pendingOperationsTable} WHERE ${DatabaseColumns.syncStatus} = ?',
        [AppConstants.syncStatusPending],
      );

      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw OfflineException.database('Failed to get pending count: $e');
    }
  }

  Future<int> getFailedCount() async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${AppConstants.pendingOperationsTable} WHERE ${DatabaseColumns.syncStatus} = ?',
        [AppConstants.syncStatusFailed],
      );

      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw OfflineException.database('Failed to get failed count: $e');
    }
  }

  Future<void> clearAllSyncRecords() async {
    try {
      final db = await _databaseHelper.database;
      await db.delete(AppConstants.pendingOperationsTable);
    } catch (e) {
      throw OfflineException.database('Failed to clear all sync records: $e');
    }
  }

  Future<List<SyncRecordModel>> getSyncRecordsByStatus(String status) async {
    try {
      final db = await _databaseHelper.database;
      final results = await db.query(
        AppConstants.pendingOperationsTable,
        where: '${DatabaseColumns.syncStatus} = ?',
        whereArgs: [status],
        orderBy: '${DatabaseColumns.createdAt} ASC',
      );

      return results.map((map) => SyncRecordModel.fromMap(map)).toList();
    } catch (e) {
      throw OfflineException.database('Failed to get sync records by status: $e');
    }
  }

  Future<void> bulkUpdateStatus(
    List<String> ids,
    String newStatus,
  ) async {
    try {
      final db = await _databaseHelper.database;
      final batch = db.batch();

      for (final id in ids) {
        batch.update(
          AppConstants.pendingOperationsTable,
          {DatabaseColumns.syncStatus: newStatus},
          where: '${DatabaseColumns.id} = ?',
          whereArgs: [id],
        );
      }

      await batch.commit(noResult: true);
    } catch (e) {
      throw OfflineException.database('Failed to bulk update sync records: $e');
    }
  }
}