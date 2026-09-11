library;

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

part 'app_database.g.dart';

class ClientsTable extends Table {
  TextColumn get id => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get identificationNumber => text()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastModified => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class CreditApplicationsTable extends Table {
  TextColumn get id => text()();
  TextColumn get clientId => text().references(ClientsTable, #id)();
  RealColumn get requestedAmount => real()();
  TextColumn get purpose => text()();
  IntColumn get termMonths => integer()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastModified => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  TextColumn get rejectionReason => text().nullable()();
  TextColumn get approvedAmount => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncLogTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()();
  TextColumn get payload => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get processedAt => dateTime().nullable()();
}

@DriftDatabase(tables: [ClientsTable, CreditApplicationsTable, SyncLogTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());

  static AppDatabase? _instance;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'credit_field_db');
  }

  static AppDatabase get instance {
    _instance ??= AppDatabase._internal();
    return _instance!;
  }

  @override
  int get schemaVersion => 1;

  Future<void> initialize() async {
    await database.ensureOpen();
  }

  Future<List<ClientsTableData>> getAllClients() => select(clientsTable).get();

  Stream<List<ClientsTableData>> watchAllClients() => select(clientsTable).watch();

  Future<ClientsTableData?> getClientById(String id) {
    return (select(clientsTable)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertClient(ClientsTableCompanion client) {
    return into(clientsTable).insert(client);
  }

  Future<bool> updateClient(ClientsTableCompanion client) {
    return update(clientsTable).replace(client);
  }

  Future<int> deleteClient(String id) {
    return (delete(clientsTable)..where((t) => t.id.equals(id))).go();
  }

  Future<List<ClientsTableData>> getPendingClients() {
    return (select(clientsTable)..where((t) => t.syncStatus.equals('pending'))).get();
  }

  Stream<List<ClientsTableData>> watchPendingClients() {
    return (select(clientsTable)..where((t) => t.syncStatus.equals('pending'))).watch();
  }

  Future<List<CreditApplicationsTableData>> getAllCreditApplications() {
    return select(creditApplicationsTable).get();
  }

  Stream<List<CreditApplicationsTableData>> watchAllCreditApplications() {
    return select(creditApplicationsTable).watch();
  }

  Future<List<CreditApplicationsTableData>> getCreditApplicationsByClientId(String clientId) {
    return (select(creditApplicationsTable)..where((t) => t.clientId.equals(clientId))).get();
  }

  Future<CreditApplicationsTableData?> getCreditApplicationById(String id) {
    return (select(creditApplicationsTable)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertCreditApplication(CreditApplicationsTableCompanion application) {
    return into(creditApplicationsTable).insert(application);
  }

  Future<bool> updateCreditApplication(CreditApplicationsTableCompanion application) {
    return update(creditApplicationsTable).replace(application);
  }

  Future<int> deleteCreditApplication(String id) {
    return (delete(creditApplicationsTable)..where((t) => t.id.equals(id))).go();
  }

  Future<List<CreditApplicationsTableData>> getPendingCreditApplications() {
    return (select(creditApplicationsTable)..where((t) => t.syncStatus.equals('pending'))).get();
  }

  Stream<List<CreditApplicationsTableData>> watchPendingCreditApplications() {
    return (select(creditApplicationsTable)..where((t) => t.syncStatus.equals('pending'))).watch();
  }

  Future<int> insertSyncLog(SyncLogTableCompanion logEntry) {
    return into(syncLogTable).insert(logEntry);
  }

  Future<List<SyncLogTableData>> getPendingSyncLogs() {
    return (select(syncLogTable)..where((t) => t.status.equals('pending'))).get();
  }

  Future<int> updateSyncLogStatus(int id, String status, {String? errorMessage}) async {
    return (update(syncLogTable)..where((t) => t.id.equals(id))).write(
      SyncLogTableCompanion(
        status: Value(status),
        errorMessage: Value(errorMessage),
        processedAt: Value(status == 'completed' || status == 'failed' ? DateTime.now() : null),
      ),
    );
  }

  Future<void> updateClientsSyncStatus(List<String> ids, String status) async {
    await (update(clientsTable)..where((t) => t.id.isIn(ids))).write(
      ClientsTableCompanion(
        syncStatus: Value(status),
        syncedAt: Value(status == 'synced' ? DateTime.now() : null),
      ),
    );
  }

  Future<void> updateCreditApplicationsSyncStatus(List<String> ids, String status) async {
    await (update(creditApplicationsTable)..where((t) => t.id.isIn(ids))).write(
      CreditApplicationsTableCompanion(
        syncStatus: Value(status),
        syncedAt: Value(status == 'synced' ? DateTime.now() : null),
      ),
    );
  }

  Future<void> deleteAllClients() async {
    final clients = await getAllClients();
    for (final client in clients) {
      await deleteClient(client.id);
    }
  }

  Future<void> deleteAllCreditApplications() async {
    final apps = await getAllCreditApplications();
    for (final app in apps) {
      await deleteCreditApplication(app.id);
    }
  }

  Future<void> deleteSyncLog(int id) async {
    await (delete(syncLogTable)..where((t) => t.id.equals(id))).go();
  }

  Future<void> close() async {
    await database.close();
    _instance = null;
  }
}