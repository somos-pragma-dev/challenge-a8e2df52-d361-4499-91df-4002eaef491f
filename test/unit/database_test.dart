import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:credit_field_app/core/database/app_database.dart';
import 'package:credit_field_app/core/error/failures.dart';

void main() {
  late AppDatabase database;

  setUpAll(() async {
    database = AppDatabase._internal();
    await database.initialize();
  });

  tearDownAll(() async {
    await database.close();
  });

  group('Client Operations', () {
    test('should insert a new client and retrieve it', () async {
      final clientId = 'test-client-${DateTime.now().millisecondsSinceEpoch}';
      final clientCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'Juan',
        lastName: 'Pérez',
        email: const Value('juan.perez@test.com'),
        phone: const Value('+521234567890'),
        address: const Value('Calle Principal 123'),
        identificationNumber: const Value('ABC123456'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );

      final insertResult = await database.insertClient(clientCompanion);
      expect(insertResult, greaterThan(0));

      final retrievedClient = await database.getClientById(clientId);
      expect(retrievedClient, isNotNull);
      expect(retrievedClient!.firstName, equals('Juan'));
      expect(retrievedClient.lastName, equals('Pérez'));
      expect(retrievedClient.syncStatus, equals('pending'));

      await database.deleteClient(clientId);
    });

    test('should update an existing client', () async {
      final clientId = 'test-client-update-${DateTime.now().millisecondsSinceEpoch}';
      final clientCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'María',
        lastName: 'Gómez',
        email: const Value('maria.gomez@test.com'),
        phone: const Value('+521234567891'),
        address: const Value('Avenida Secundaria 456'),
        identificationNumber: const Value('DEF789012'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );

      await database.insertClient(clientCompanion);

      final updatedCompanion = ClientsTableCompanion(
        id: Value(clientId),
        firstName: const Value('María Actualizada'),
        lastName: const Value('Gómez Actualizado'),
        email: Value('maria.updated@test.com'),
        phone: const Value('+521234567892'),
        address: const Value('Nueva Dirección 789'),
        identificationNumber: const Value('DEF789012'),
        syncStatus: const Value('pending'),
        version: const Value(2),
        lastModified: Value(DateTime.now()),
        createdAt: Value(DateTime.now()),
        syncedAt: const Value(null),
      );

      final updateResult = await database.updateClient(updatedCompanion);
      expect(updateResult, isTrue);

      final updatedClient = await database.getClientById(clientId);
      expect(updatedClient!.firstName, equals('María Actualizada'));
      expect(updatedClient.version, equals(2));

      await database.deleteClient(clientId);
    });

    test('should delete a client', () async {
      final clientId = 'test-client-delete-${DateTime.now().millisecondsSinceEpoch}';
      final clientCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'Carlos',
        lastName: 'López',
        email: const Value('carlos.lopez@test.com'),
        phone: const Value('+521234567893'),
        address: const Value('Calle Test 111'),
        identificationNumber: const Value('GHI345678'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );

      await database.insertClient(clientCompanion);
      final deleteResult = await database.deleteClient(clientId);
      expect(deleteResult, equals(1));

      final deletedClient = await database.getClientById(clientId);
      expect(deletedClient, isNull);
    });

    test('should retrieve all pending clients', () async {
      final clientId1 = 'test-pending-1-${DateTime.now().millisecondsSinceEpoch}';
      final clientId2 = 'test-pending-2-${DateTime.now().millisecondsSinceEpoch}';
      final clientId3 = 'test-synced-${DateTime.now().millisecondsSinceEpoch}';

      final companion1 = ClientsTableCompanion.insert(
        id: clientId1,
        firstName: 'Pending',
        lastName: 'One',
        email: const Value('pending1@test.com'),
        phone: const Value('+521111111111'),
        address: const Value('Address 1'),
        identificationNumber: const Value('P1'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );

      final companion2 = ClientsTableCompanion.insert(
        id: clientId2,
        firstName: 'Pending',
        lastName: 'Two',
        email: const Value('pending2@test.com'),
        phone: const Value('+521222222222'),
        address: const Value('Address 2'),
        identificationNumber: const Value('P2'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );

      final companion3 = ClientsTableCompanion.insert(
        id: clientId3,
        firstName: 'Synced',
        lastName: 'One',
        email: const Value('synced@test.com'),
        phone: const Value('+523333333333'),
        address: const Value('Address 3'),
        identificationNumber: const Value('S1'),
        syncStatus: 'synced',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: Value(DateTime.now()),
      );

      await database.insertClient(companion1);
      await database.insertClient(companion2);
      await database.insertClient(companion3);

      final pendingClients = await database.getPendingClients();
      expect(pendingClients.length, equals(2));
      expect(pendingClients.every((c) => c.syncStatus == 'pending'), isTrue);

      await database.deleteClient(clientId1);
      await database.deleteClient(clientId2);
      await database.deleteClient(clientId3);
    });

    test('should update clients sync status in batch', () async {
      final clientId1 = 'test-batch-1-${DateTime.now().millisecondsSinceEpoch}';
      final clientId2 = 'test-batch-2-${DateTime.now().millisecondsSinceEpoch}';

      final companion1 = ClientsTableCompanion.insert(
        id: clientId1,
        firstName: 'Batch',
        lastName: 'One',
        email: const Value('batch1@test.com'),
        phone: const Value('+521111111111'),
        address: const Value('Address 1'),
        identificationNumber: const Value('B1'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );

      final companion2 = ClientsTableCompanion.insert(
        id: clientId2,
        firstName: 'Batch',
        lastName: 'Two',
        email: const Value('batch2@test.com'),
        phone: const Value('+521222222222'),
        address: const Value('Address 2'),
        identificationNumber: const Value('B2'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );

      await database.insertClient(companion1);
      await database.insertClient(companion2);

      await database.updateClientsSyncStatus([clientId1, clientId2], 'synced');

      final client1 = await database.getClientById(clientId1);
      final client2 = await database.getClientById(clientId2);

      expect(client1!.syncStatus, equals('synced'));
      expect(client2!.syncStatus, equals('synced'));

      await database.deleteClient(clientId1);
      await database.deleteClient(clientId2);
    });
  });

  group('Credit Application Operations', () {
    test('should insert and retrieve credit application', () async {
      final clientId = 'test-client-for-app-${DateTime.now().millisecondsSinceEpoch}';
      final appId = 'test-app-${DateTime.now().millisecondsSinceEpoch}';

      final clientCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'Test',
        lastName: 'Client',
        email: const Value('test@client.com'),
        phone: const Value('+521234567890'),
        address: const Value('Test Address'),
        identificationNumber: const Value('TC'),
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
        purpose: 'Personal',
        termMonths: 24,
        status: 'pending',
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
        rejectionReason: const Value(null),
        approvedAmount: const Value(null),
      );

      final insertResult = await database.insertCreditApplication(appCompanion);
      expect(insertResult, greaterThan(0));

      final retrievedApp = await database.getCreditApplicationById(appId);
      expect(retrievedApp, isNotNull);
      expect(retrievedApp!.requestedAmount, equals(50000.0));
      expect(retrievedApp.termMonths, equals(24));

      await database.deleteCreditApplication(appId);
      await database.deleteClient(clientId);
    });

    test('should retrieve applications by client id', () async {
      final clientId = 'test-client-apps-${DateTime.now().millisecondsSinceEpoch}';
      final appId1 = 'test-app-1-${DateTime.now().millisecondsSinceEpoch}';
      final appId2 = 'test-app-2-${DateTime.now().millisecondsSinceEpoch}';

      final clientCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'Multi',
        lastName: 'App Client',
        email: const Value('multi@app.com'),
        phone: const Value('+521234567890'),
        address: const Value('Address'),
        identificationNumber: const Value('MAC'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );
      await database.insertClient(clientCompanion);

      await database.insertCreditApplication(CreditApplicationsTableCompanion.insert(
        id: appId1,
        clientId: clientId,
        requestedAmount: 10000.0,
        purpose: 'Business',
        termMonths: 12,
        status: 'approved',
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
        rejectionReason: const Value(null),
        approvedAmount: const Value(10000.0),
      ));

      await database.insertCreditApplication(CreditApplicationsTableCompanion.insert(
        id: appId2,
        clientId: clientId,
        requestedAmount: 25000.0,
        purpose: 'Home',
        termMonths: 36,
        status: 'pending',
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
        rejectionReason: const Value(null),
        approvedAmount: const Value(null),
      ));

      final applications = await database.getCreditApplicationsByClientId(clientId);
      expect(applications.length, equals(2));

      await database.deleteCreditApplication(appId1);
      await database.deleteCreditApplication(appId2);
      await database.deleteClient(clientId);
    });

    test('should get pending credit applications', () async {
      final clientId = 'test-client-pending-${DateTime.now().millisecondsSinceEpoch}';
      final appId = 'test-app-pending-${DateTime.now().millisecondsSinceEpoch}';

      final clientCompanion = ClientsTableCompanion.insert(
        id: clientId,
        firstName: 'Pending',
        lastName: 'App Client',
        email: const Value('pending@app.com'),
        phone: const Value('+521234567890'),
        address: const Value('Address'),
        identificationNumber: const Value('PAC'),
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
      );
      await database.insertClient(clientCompanion);

      await database.insertCreditApplication(CreditApplicationsTableCompanion.insert(
        id: appId,
        clientId: clientId,
        requestedAmount: 15000.0,
        purpose: 'Education',
        termMonths: 18,
        status: 'pending',
        syncStatus: 'pending',
        version: 1,
        lastModified: DateTime.now(),
        createdAt: DateTime.now(),
        syncedAt: const Value(null),
        rejectionReason: const Value(null),
        approvedAmount: const Value(null),
      ));

      final pendingApps = await database.getPendingCreditApplications();
      expect(pendingApps.any((app) => app.id == appId), isTrue);

      await database.deleteCreditApplication(appId);
      await database.deleteClient(clientId);
    });
  });

  group('Sync Log Operations', () {
    test('should insert and retrieve sync log', () async {
      final logCompanion = SyncLogTableCompanion.insert(
        entityType: 'client',
        entityId: 'sync-test-entity-${DateTime.now().millisecondsSinceEpoch}',
        operation: 'create',
        payload: '{"name": "Test Entity"}',
        status: 'pending',
        retryCount: 0,
        errorMessage: const Value(null),
        createdAt: DateTime.now(),
        processedAt: const Value(null),
      );

      final insertResult = await database.insertSyncLog(logCompanion);
      expect(insertResult, greaterThan(0));
    });

    test('should retrieve pending sync logs', () async {
      final logCompanion = SyncLogTableCompanion.insert(
        entityType: 'credit_application',
        entityId: 'sync-test-ca-${DateTime.now().millisecondsSinceEpoch}',
        operation: 'update',
        payload: '{"status": "approved"}',
        status: 'pending',
        retryCount: 0,
        errorMessage: const Value(null),
        createdAt: DateTime.now(),
        processedAt: const Value(null),
      );

      await database.insertSyncLog(logCompanion);
      final pendingLogs = await database.getPendingSyncLogs();
      expect(pendingLogs.isNotEmpty, isTrue);
    });
  });
}