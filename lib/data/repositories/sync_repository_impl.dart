package offline_field_app.data.repositories;

import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';
import '../../domain/entities/sync_record.dart' as domain;
import '../../domain/repositories/sync_repository.dart';
import '../models/sync_record_model.dart';
import '../datasources/local/sync_local_datasource.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';

class SyncRepositoryImpl implements SyncRepository {
  final SyncLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final Uuid uuid;

  SyncRepositoryImpl({
    required this.localDataSource,
    required this.networkInfo,
    required this.uuid,
  });

  @override
  Future<domain.SyncRecord> recordOperation(domain.SyncRecord record) async {
    final recordId = uuid.v4();
    final now = DateTime.now().toUtc();
    
    final model = SyncRecordModel(
      id: recordId,
      entityId: record.entityId,
      entityType: record.entityType,
      operationType: record.operationType,
      payload: record.payload,
      status: 'pending',
      createdAt: now,
      updatedAt: now,
      attempts: 0,
      lastAttemptAt: null,
      errorMessage: null,
      version: 1,
    );

    await localDataSource.insertSyncRecord(model);
    return _mapModelToEntity(model);
  }

  @override
  Future<List<domain.SyncRecord>> getPendingSyncRecords() async {
    final models = await localDataSource.getPendingRecords();
    return models.map(_mapModelToEntity).toList();
  }

  @override
  Future<List<domain.SyncRecord>> getFailedSyncRecords() async {
    final models = await localDataSource.getFailedRecords();
    return models.map(_mapModelToEntity).toList();
  }

  @override
  Future<domain.SyncRecord> updateSyncRecord(domain.SyncRecord record) async {
    final existing = await localDataSource.getSyncRecordById(record.id);
    if (existing == null) {
      throw const OfflineException.database('Sync record not found');
    }

    final model = SyncRecordModel(
      id: record.id,
      entityId: record.entityId,
      entityType: record.entityType,
      operationType: record.operationType,
      payload: record.payload,
      status: record.status,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now().toUtc(),
      attempts: record.attempts,
      lastAttemptAt: record.lastAttemptAt,
      errorMessage: record.errorMessage,
      version: existing.version + 1,
    );

    await localDataSource.updateSyncRecord(model);
    return _mapModelToEntity(model);
  }

  @override
  Future<void> markAsCompleted(String recordId) async {
    await localDataSource.updateSyncRecordStatus(recordId, 'completed');
  }

  @override
  Future<void> markAsFailed(String recordId, String errorMessage) async {
    final record = await localDataSource.getSyncRecordById(recordId);
    if (record == null) {
      throw const OfflineException.database('Sync record not found');
    }

    await localDataSource.updateSyncRecordWithError(
      recordId,
      'failed',
      record.attempts + 1,
      DateTime.now().toUtc(),
      errorMessage,
    );
  }

  @override
  Future<void> incrementAttempt(String recordId) async {
    final record = await localDataSource.getSyncRecordById(recordId);
    if (record == null) {
      throw const OfflineException.database('Sync record not found');
    }

    await localDataSource.updateSyncRecordWithError(
      recordId,
      'in_progress',
      record.attempts + 1,
      DateTime.now().toUtc(),
      null,
    );
  }

  @override
  Future<void> deleteSyncRecord(String recordId) async {
    await localDataSource.deleteSyncRecord(recordId);
  }

  @override
  Future<void> clearCompletedRecords() async {
    await localDataSource.deleteCompletedRecords();
  }

  @override
  Future<int> getPendingCount() async {
    final records = await localDataSource.getPendingRecords();
    return records.length;
  }

  @override
  Future<int> getFailedCount() async {
    final records = await localDataSource.getFailedRecords();
    return records.length;
  }

  @override
  Future<List<domain.SyncRecord>> getSyncRecordsByEntityId(String entityId) async {
    final models = await localDataSource.getSyncRecordsByEntityId(entityId);
    return models.map(_mapModelToEntity).toList();
  }

  domain.SyncRecord _mapModelToEntity(SyncRecordModel model) {
    return domain.SyncRecord(
      id: model.id,
      entityId: model.entityId,
      entityType: model.entityType,
      operationType: model.operationType,
      payload: model.payload,
      status: model.status,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      attempts: model.attempts,
      lastAttemptAt: model.lastAttemptAt,
      errorMessage: model.errorMessage,
    );
  }
}