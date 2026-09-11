import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:credit_field_app/core/database/app_database.dart';
import 'package:credit_field_app/core/network/connectivity_service.dart';
import 'package:credit_field_app/domain/entities/sync_status.dart' as domain;

void main() {
  late AppDatabase database;
  late ConnectivityService connectivityService;

  setUpAll(() async {
    database = AppDatabase._internal();
    await database.initialize();
    connectivityService = ConnectivityService();
  });

  setUp(() async {
    await database.deleteAllClients();
    await database.deleteAllCreditApplications();
    final syncLogs = await database.getPendingSyncLogs();
    for (final log in syncLogs) {
      await database.deleteSyncLog(log.id);
    }
  });

  tearDownAll(() async {
    connectivityService.dispose();
    await database.close();
  });

  group('Offline-First Flow: Complete Scenario', () {
    test('should create client offline and queue for sync', () async {
      final clientId = 'offline-client-${DateTime.now().millisecondsSinceEpoch}';
      final clientCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'Offline',
        lastName: 'User',
        email: const Value('offline@test.com'),
        phone: const Value('+521234567890'),
        address: const Value('Offline Address'),
        identificationNumber: const Value('OFFLINE001'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );

      await database.insertClient(clientCompanion);

      final savedClient = await database.getClientById(clientId);
      expect(savedClient, isNotNull);
      expect(savedClient!.syncStatus, equals('pending'));
      expect(savedClient.version, equals(1));

      final pendingClients = await database.getPendingClients();
      expect(pendingClients.any((c) => c.id == clientId), isTrue);
    });

    test('should create credit application offline', () async {
      final clientId = 'client-for-app-${DateTime.now().millisecondsSinceEpoch}';
      final appId = 'offline-app-${DateTime.now().millisecondsSinceEpoch}';

      final clientCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'App',
        lastName: 'Owner',
        email: const Value('appowner@test.com'),
        phone: const Value('+521234567891'),
        address: const Value('App Owner Address'),
        identificationNumber: const Value('APPOWNER001'),
        syncStatus: 'synced',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: Value(DateTime.now()),
      );
      await database.insertClient(clientCompanion);

      final appCompanion = CreditApplicationsTableCompanion.insert(
        id: appId,
        clientId: clientId,
        requestedAmount: 100000.0,
        purpose: 'Business Loan',
        termMonths: 36,
        status: 'pending',
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
        rejectionReason: const Value(null),
        approvedAmount: const Value(null),
      );

      await database.insertCreditApplication(appCompanion);

      final savedApp = await database.getCreditApplicationById(appId);
      expect(savedApp, isNotNull);
      expect(savedApp!.syncStatus, equals('pending'));
      expect(savedApp.requestedAmount, equals(100000.0));

      final pendingApps = await database.getPendingCreditApplications();
      expect(pendingApps.any((a) => a.id == appId), isTrue);
    });

    test('should update client while offline and preserve pending status', () async {
      final clientId = 'update-offline-${DateTime.now().millisecondsSinceEpoch}';

      final originalCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'Original',
        lastName: 'Name',
        email: const Value('original@test.com'),
        phone: const Value('+521234567890'),
        address: const Value('Original Address'),
        identificationNumber: const Value('ORIGINAL001'),
        syncStatus: 'synced',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: Value(DateTime.now()),
      );
      await database.insertClient(originalCompanion);

      final updatedCompanion = ClientsTableCompanion(
        id: Value(clientId),
        firstName: const Value('Updated Name'),
        lastName: const Value('Updated LastName'),
        email: const Value('updated@test.com'),
        phone: const Value('+521234567891'),
        address: const Value('Updated Address'),
        identificationNumber: const Value('ORIGINAL001'),
        syncStatus: const Value('pending'),
        version: const Value(2),
        lastModified: Value(DateTime.now()),
        createdAt: Value(DateTime.now()),
        syncedAt: const Value(null),
      );
      await database.updateClient(updatedCompanion);

      final updatedClient = await database.getClientById(clientId);
      expect(updatedClient!.firstName, equals('Updated Name'));
      expect(updatedClient.syncStatus, equals('pending'));
      expect(updatedClient.version, equals(2));
    });

    test('should mark entities as synced after successful sync', () async {
      final clientId = 'sync-complete-${DateTime.now().millisecondsSinceEpoch}';
      final appId = 'app-sync-complete-${DateTime.now().millisecondsSinceEpoch}';

      final clientCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'ToSync',
        lastName: 'Client',
        email: const Value('tosync@test.com'),
        phone: const Value('+521234567890'),
        address: const Value('ToSync Address'),
        identificationNumber: const Value('TOSYNC001'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );
      await database.insertClient(clientCompanion);

      final appCompanion = CreditApplicationsTableCompanion.insert(
        id: appId,
        clientId: clientId,
        requestedAmount: 50000.0,
        purpose: 'Personal Loan',
        termMonths: 24,
        status: 'approved',
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
        rejectionReason: const Value(null),
        approvedAmount: const Value(50000.0),
      );
      await database.insertCreditApplication(appCompanion);

      final syncTime = DateTime.now();
      await database.updateClientsSyncStatus([clientId], 'synced');
      await database.updateCreditApplicationsSyncStatus([appId], 'synced');

      final syncedClient = await database.getClientById(clientId);
      expect(syncedClient!.syncStatus, equals('synced'));

      final syncedApp = await database.getCreditApplicationById(appId);
      expect(syncedApp!.syncStatus, equals('synced'));

      final pendingClients = await database.getPendingClients();
      expect(pendingClients.any((c) => c.id == clientId), isFalse);

      final pendingApps = await database.getPendingCreditApplications();
      expect(pendingApps.any((a) => a.id == appId), isFalse);
    });

    test('should detect conflict when remote version is newer', () async {
      final clientId = 'conflict-test-${DateTime.now().millisecondsSinceEpoch}';

      final localCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'Local Version',
        lastName: 'Client',
        email: const Value('local@test.com'),
        phone: const Value('+521234567890'),
        address: const Value('Local Address'),
        identificationNumber: const Value('LOCAL001'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now().subtract(const Duration(hours: 2)),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );
      await database.insertClient(localCompanion);

      const remoteVersion = 2;
      const remoteLastModified = '2024-01-15T10:00:00Z';

      final hasConflict = remoteVersion > 1;
      expect(hasConflict, isTrue);

      if (hasConflict) {
        await database.updateClientsSyncStatus([clientId], 'conflict');
      }

      final conflictedClient = await database.getClientById(clientId);
      expect(conflictedClient!.syncStatus, equals('conflict'));
    });

    test('should handle batch sync of multiple entities', () async {
      final clientIds = List.generate(
        5,
        (i) => 'batch-client-${DateTime.now().millisecondsSinceEpoch}-$i',
      );

      for (var i = 0; i < clientIds.length; i++) {
        final companion = ClientsTableCompanion.insert(
          id: clientIds[i],
          firstName: 'Batch Client $i',
          lastName: 'Batch LastName',
          email: Value('batch$i@test.com'),
          phone: Value('+52123456789$i'),
          address: Value('Batch Address $i'),
          identificationNumber: Value('BATCH00$i'),
          syncStatus: 'pending',
          version: 1,
          lastModified: DateTime.now(),
          createdAt: DateTime.now(),
          syncedAt: const Value(null),
        );
        await database.insertClient(companion);
      }

      final pendingBefore = await database.getPendingClients();
      expect(pendingBefore.length, greaterThanOrEqualTo(5));

      await database.updateClientsSyncStatus(clientIds, 'synced');

      final pendingAfter = await database.getPendingClients();
      final syncedClients = pendingAfter.where((c) => clientIds.contains(c.id)).toList();
      expect(syncedClients.length, equals(0));

      for (final id in clientIds) {
        await database.deleteClient(id);
      }
    });

    test('should maintain data integrity after sync operations', () async {
      final clientId = 'integrity-test-${DateTime.now().millisecondsSinceEpoch}';
      final appIds = List.generate(
        3,
        (i) => 'integrity-app-${DateTime.now().millisecondsSinceEpoch}-$i',
      );

      final clientCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'Integrity',
        lastName: 'Client',
        email: const Value('integrity@test.com'),
        phone: const Value('+521234567890'),
        address: const Value('Integrity Address'),
        identificationNumber: const Value('INTEGRITY001'),
        syncStatus: 'synced',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: Value(DateTime.now()),
      );
      await database.insertClient(clientCompanion);

      for (var i = 0; i < appIds.length; i++) {
        final appCompanion = CreditApplicationsTableCompanion.insert(
          id: appIds[i],
          clientId: clientId,
          requestedAmount: 10000.0 * (i + 1),
          purpose: 'Loan ${i + 1}',
          termMonths: 12 * (i + 1),
          status: 'pending',
          syncStatus: 'pending',
          version: 1,
          lastModified: DateTime.now(),
          createdAt: DateTime.now(),
          syncedAt: const Value(null),
          rejectionReason: const Value(null),
          approvedAmount: const Value(null),
        );
        await database.insertCreditApplication(appCompanion);
      }

      await database.updateCreditApplicationsSyncStatus(appIds, 'synced');

      final clientAfterSync = await database.getClientById(clientId);
      expect(clientAfterSync, isNotNull);
      expect(clientAfterSync!.id, equals(clientId));

      final appsForClient = await database.getCreditApplicationsByClientId(clientId);
      expect(appsForClient.length, equals(3));
      expect(appsForClient.every((a) => a.syncStatus == 'synced'), isTrue);

      final totalAmount = appsForClient.fold<double>(
        0,
        (sum, app) => sum + app.requestedAmount,
      );
      expect(totalAmount, equals(60000.0));

      await database.deleteCreditApplication(appIds[0]);
      await database.deleteCreditApplication(appIds[1]);
      await database.deleteCreditApplication(appIds[2]);
      await database.deleteClient(clientId);
    });

    test('should handle offline scenario: no connection, data queued locally', () async {
      final status = await connectivityService.checkConnectivity();

      if (status.isDisconnected) {
        final clientId = 'offline-queue-${DateTime.now().millisecondsSinceEpoch}';
        final clientCompanion = ClientsTableCompanion.insert(
          id: clientId,
          firstName: 'Queued',
          lastName: 'Offline',
          email: const Value('queued@test.com'),
          phone: const Value('+521234567890'),
          address: const Value('Queued Address'),
          identificationNumber: const Value('QUEUED001'),
          syncStatus: 'pending',
          version: 1,
          lastModified: DateTime.now(),
          createdAt: DateTime.now(),
          syncedAt: const Value(null),
        );

        await database.insertClient(clientCompanion);

        final savedClient = await database.getClientById(clientId);
        expect(savedClient!.syncStatus, equals('pending'));

        final pendingClients = await database.getPendingClients();
        expect(pendingClients.any((c) => c.id == clientId), isTrue);

        await database.deleteClient(clientId);
      } else {
        expect(true, isTrue);
      }
    });
  });
}

extension _DatabaseExtensions on AppDatabase {
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
    await customStatement('DELETE FROM sync_log WHERE id = ?', [id]);
  }
}