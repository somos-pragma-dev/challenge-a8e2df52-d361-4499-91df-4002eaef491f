package field_app.data.datasources.local;

import 'package:field_app/data/models/task_model.dart';
import 'package:field_app/data/models/sync_status_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getAllTasks();
  Future<List<TaskModel>> getPendingSyncTasks();
  Future<TaskModel?> getTaskById(String id);
  Future<void> saveTask(TaskModel task);
  Future<void> saveTasks(List<TaskModel> tasks);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<void> markTaskAsSynced(String id);
  Future<void> markTaskAsFailed(String id, String error);
  Future<void> markTaskAsConflict(String id);
  Future<int> getPendingTasksCount();
  Future<void> clearAllTasks();
  Future<SyncStatusModel?> getSyncStatus(String entityId);
  Future<void> saveSyncStatus(SyncStatusModel status);
  Future<List<SyncStatusModel>> getAllSyncStatuses();
  Future<void> updateTaskSyncStatus(String id, String syncStatus);
  Future<DateTime?> getLastSyncTime();
  Future<void> clearPendingSyncTasks();
  Future<void> insertTask(TaskModel task);
  Future<void> updateLastSyncTime(DateTime time);
  Future<void> insertSyncStatus(SyncStatusModel status);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final DatabaseHelper databaseHelper;
  final Uuid _uuid;

  TaskLocalDataSourceImpl({
    required this.databaseHelper,
    required this.uuid,
  });

  Future<Database> get _db async => await databaseHelper.database;

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final db = await _db;
    final maps = await db.query('tasks', where: 'is_deleted = ?', whereArgs: [0]);
    return maps.map((map) => TaskModel.fromMap(map)).toList();
  }

  @override
  Future<List<TaskModel>> getPendingSyncTasks() async {
    final db = await _db;
    final maps = await db.query(
      'tasks',
      where: 'sync_status = ? AND is_deleted = ?',
      whereArgs: ['pending', 0],
    );
    return maps.map((map) => TaskModel.fromMap(map)).toList();
  }

  @override
  Future<TaskModel?> getTaskById(String id) async {
    final db = await _db;
    final maps = await db.query(
      'tasks',
      where: 'id = ? AND is_deleted = ?',
      whereArgs: [id, 0],
    );
    if (maps.isEmpty) return null;
    return TaskModel.fromMap(maps.first);
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    final db = await _db;
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> saveTasks(List<TaskModel> tasks) async {
    final db = await _db;
    final batch = db.batch();
    for (final task in tasks) {
      batch.insert(
        'tasks',
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    final db = await _db;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    final db = await _db;
    await db.update(
      'tasks',
      {'is_deleted': 1, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> markTaskAsSynced(String id) async {
    final db = await _db;
    await db.update(
      'tasks',
      {'sync_status': 'synced', 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> markTaskAsFailed(String id, String error) async {
    final db = await _db;
    await db.update(
      'tasks',
      {
        'sync_status': 'failed',
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> markTaskAsConflict(String id) async {
    final db = await _db;
    await db.update(
      'tasks',
      {'sync_status': 'conflict', 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> getPendingTasksCount() async {
    final db = await _db;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE sync_status = ? AND is_deleted = ?',
      ['pending', 0],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  @override
  Future<void> clearAllTasks() async {
    final db = await _db;
    await db.delete('tasks');
  }

  @override
  Future<SyncStatusModel?> getSyncStatus(String entityId) async {
    final db = await _db;
    final maps = await db.query(
      'sync_status',
      where: 'entity_id = ?',
      whereArgs: [entityId],
    );
    if (maps.isEmpty) return null;
    return SyncStatusModel.fromMap(maps.first);
  }

  @override
  Future<void> saveSyncStatus(SyncStatusModel status) async {
    final db = await _db;
    await db.insert(
      'sync_status',
      status.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<SyncStatusModel>> getAllSyncStatuses() async {
    final db = await _db;
    final maps = await db.query('sync_status', orderBy: 'created_at DESC');
    return maps.map((map) => SyncStatusModel.fromMap(map)).toList();
  }

  @override
  Future<void> updateTaskSyncStatus(String id, String syncStatus) async {
    final db = await _db;
    await db.update(
      'tasks',
      {
        'sync_status': syncStatus,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<DateTime?> getLastSyncTime() async {
    final db = await _db;
    final maps = await db.query(
      'sync_status',
      where: 'entity_type = ?',
      whereArgs: ['_meta'],
      orderBy: 'last_sync_at DESC',
      limit: 1,
    );
    if (maps.isEmpty) return null;
    final lastSyncAt = maps.first['last_sync_at'];
    if (lastSyncAt == null) return null;
    return DateTime.tryParse(lastSyncAt.toString());
  }

  @override
  Future<void> clearPendingSyncTasks() async {
    final db = await _db;
    await db.update(
      'tasks',
      {'sync_status': 'synced'},
      where: 'sync_status = ?',
      whereArgs: ['pending'],
    );
  }

  @override
  Future<void> insertTask(TaskModel task) async {
    final db = await _db;
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateLastSyncTime(DateTime time) async {
    final db = await _db;
    final existing = await db.query(
      'sync_status',
      where: 'entity_id = ?',
      whereArgs: ['_last_sync'],
    );
    
    if (existing.isEmpty) {
      await db.insert('sync_status', {
        'id': '_last_sync',
        'entity_type': '_meta',
        'entity_id': '_last_sync',
        'status': 'synced',
        'version': 1,
        'last_sync_at': time.toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'retry_count': 0,
      });
    } else {
      await db.update(
        'sync_status',
        {
          'last_sync_at': time.toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'entity_id = ?',
        whereArgs: ['_last_sync'],
      );
    }
  }

  @override
  Future<void> insertSyncStatus(SyncStatusModel status) async {
    final db = await _db;
    await db.insert(
      'sync_status',
      status.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}