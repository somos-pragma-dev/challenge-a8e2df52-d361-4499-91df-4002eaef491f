import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/constants/app_constants.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, AppConstants.databaseName);

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
    await db.execute('''
      CREATE TABLE ${AppConstants.taskTableName} (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        priority TEXT NOT NULL,
        status TEXT NOT NULL,
        due_date INTEGER,
        assigned_to TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        sync_status TEXT NOT NULL,
        local_modified INTEGER NOT NULL DEFAULT 0,
        server_version INTEGER,
        is_deleted INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE ${AppConstants.syncStatusTableName} (
        id TEXT PRIMARY KEY,
        entity_type TEXT NOT NULL,
        entity_id TEXT NOT NULL,
        operation TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        last_attempt INTEGER,
        attempt_count INTEGER NOT NULL DEFAULT 0,
        error_message TEXT,
        retry_after INTEGER
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_tasks_sync_status 
      ON ${AppConstants.taskTableName}(sync_status)
    ''');

    await db.execute('''
      CREATE INDEX idx_sync_status_entity 
      ON ${AppConstants.syncStatusTableName}(entity_type, entity_id)
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await _performMigration(db, oldVersion, newVersion);
    }
  }

  Future<void> _performMigration(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE ${AppConstants.taskTableName} 
        ADD COLUMN server_version INTEGER
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS task_tags (
          task_id TEXT NOT NULL,
          tag TEXT NOT NULL,
          PRIMARY KEY (task_id, tag),
          FOREIGN KEY (task_id) REFERENCES ${AppConstants.taskTableName}(id) ON DELETE CASCADE
        )
      ''');
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  Future<void> clearAllTables() async {
    final db = await database;
    await db.delete(AppConstants.taskTableName);
    await db.delete(AppConstants.syncStatusTableName);
  }

  Future<int> getPendingSyncCount() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT COUNT(*) as count 
      FROM ${AppConstants.taskTableName} 
      WHERE sync_status IN (?, ?)
    ''', [AppConstants.syncStatusPending, AppConstants.syncStatusFailed]);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> resetDatabase() async {
    await clearAllTables();
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, AppConstants.databaseName);
    await deleteDatabase(path);
    _database = null;
  }
}