import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Field App';
  static const String appVersion = '1.0.0';
  
  static const Color primaryColor = Color(0xFF1565C0);
  static const Color secondaryColor = Color(0xFF43A047);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color warningColor = Color(0xFFFFA000);
  static const Color surfaceColor = Color(0xFFF5F5F5);
  
  static const String baseUrl = 'https://api.fieldapp.example.com';
  static const String apiVersion = 'v1';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  static const int maxRetryAttempts = 3;
  static const int retryDelayMilliseconds = 1000;
  static const int syncIntervalMinutes = 5;
  static const int conflictResolutionTimeoutSeconds = 30;
  
  static const String databaseName = 'field_app.db';
  static const int databaseVersion = 1;
  
  static const int taskTableId = 1;
  static const String taskTableName = 'tasks';
  static const String syncStatusTableName = 'sync_status';
  
  static const int maxOfflineTasks = 1000;
  static const int batchSyncSize = 50;
  
  static const Duration networkCheckInterval = Duration(seconds: 10);
  static const Duration syncDebounceDelay = Duration(seconds: 2);
  
  static const String syncStatusPending = 'pending';
  static const String syncStatusSynced = 'synced';
  static const String syncStatusFailed = 'failed';
  static const String syncStatusConflict = 'conflict';
  
  static const String taskPriorityLow = 'low';
  static const String taskPriorityMedium = 'medium';
  static const String taskPriorityHigh = 'high';
  
  static const String taskStatusPending = 'pending';
  static const String taskStatusInProgress = 'in_progress';
  static const String taskStatusCompleted = 'completed';
  static const String taskStatusCancelled = 'cancelled';
  
  static const String conflictResolutionStrategyServer = 'server';
  static const String conflictResolutionStrategyClient = 'client';
  static const String conflictResolutionStrategyManual = 'manual';
  static const String conflictResolutionStrategyLastWriteWins = 'last_write_wins';
  
  static const List<String> validTaskPriorities = [
    taskPriorityLow,
    taskPriorityMedium,
    taskPriorityHigh,
  ];
  
  static const List<String> validTaskStatuses = [
    taskStatusPending,
    taskStatusInProgress,
    taskStatusCompleted,
    taskStatusCancelled,
  ];
  
  static const int maxTitleLength = 200;
  static const int maxDescriptionLength = 2000;
  
  static const String locale = 'es_ES';
  static const String timezone = 'America/Bogota';
  
  static const bool enableOfflineMode = true;
  static const bool enableAutoSync = true;
  static const bool enableConflictDetection = true;
  static const bool enableDetailedLogs = true;
  
  static const Map<String, dynamic> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-App-Version': appVersion,
    'X-Platform': 'android',
    'X-Locale': locale,
  };
}

class DatabaseConstants {
  static const String tasksTable = '''
    CREATE TABLE tasks (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      description TEXT,
      priority TEXT NOT NULL,
      status TEXT NOT NULL,
      due_date INTEGER,
      assigned_to TEXT,
      location_lat REAL,
      location_lng REAL,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      synced_at INTEGER,
      sync_status TEXT NOT NULL,
      version INTEGER NOT NULL DEFAULT 1,
      is_deleted INTEGER NOT NULL DEFAULT 0,
      metadata TEXT
    )
  ''';
  
  static const String syncStatusTable = '''
    CREATE TABLE sync_status (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      entity_type TEXT NOT NULL,
      entity_id TEXT NOT NULL,
      operation TEXT NOT NULL,
      status TEXT NOT NULL,
      created_at INTEGER NOT NULL,
      updated_at INTEGER NOT NULL,
      error_message TEXT,
      retry_count INTEGER NOT NULL DEFAULT 0
    )
  ''';
  
  static const String createTasksIndex = '''
    CREATE INDEX idx_tasks_sync_status ON tasks(sync_status)
  ''';
  
  static const String createSyncStatusIndex = '''
    CREATE INDEX idx_sync_status_entity ON sync_status(entity_type, entity_id)
  ''';
}