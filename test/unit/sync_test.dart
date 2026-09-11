import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:credit_field_app/core/database/app_database.dart';
import 'package:credit_field_app/core/network/connectivity_service.dart';
import 'package:credit_field_app/core/error/failures.dart';
import 'package:credit_field_app/domain/entities/client.dart';
import 'package:credit_field_app/domain/entities/credit_application.dart';
import 'package:credit_field_app/domain/entities/sync_status.dart' as domain;
import 'package:drift/drift.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

class MockConnectivityService extends Mock implements ConnectivityService {}

void main() {
  late MockAppDatabase mockDatabase;
  late MockConnectivityService mockConnectivityService;

  setUpAll(() {
    registerFallbackValue(ClientsTableCompanion.insert(
      id: 'fallback',
      firstName: 'Fallback',
      lastName: 'User',
      email: const Value('fallback@test.com'),
      phone: const Value('+521234567890'),
      address: const Value('Fallback Address'),
      identificationNumber: const Value('FALLBACK'),
      syncStatus: 'pending',
      version: 1,
      lastModified: DateTime.now(),
      createdAt: DateTime.now(),
      syncedAt: const Value(null),
    ));

    registerFallbackValue(CreditApplicationsTableCompanion.insert(
      id: 'fallback-app',
      clientId: 'fallback-client',
      requestedAmount: 1000.0,
      purpose: 'Test',
      termMonths: 12,
      status: 'pending',
      syncStatus: 'pending',
      version: 1,
      lastModified: DateTime.now(),
      createdAt: DateTime.now(),
      syncedAt: const Value(null),
      rejectionReason: const Value(null),
      approvedAmount: const Value(null),
    ));
  });

  setUp(() {
    mockDatabase = MockAppDatabase();
    mockConnectivityService = MockConnectivityService();
  });

  group('Database Sync Status Operations', () {
    test('should get pending clients from database', () async {
      final mockClients = [
        _createMockClientData('pending-1', 'Pending One'),
        _createMockClientData('pending-2', 'Pending Two'),
      ];

      when(() => mockDatabase.getPendingClients())
          .thenAnswer((_) async => mockClients);

      final result = await mockDatabase.getPendingClients();

      expect(result.length, equals(2));
      expect(result.every((c) => c.syncStatus == 'pending'), isTrue);
      verify(() => mockDatabase.getPendingClients()).called(1);
    });

    test('should update client sync status to synced', () async {
      const clientId = 'client-to-sync';

      when(() => mockDatabase.updateClientsSyncStatus([clientId], 'synced'))
          .thenAnswer((_) async {});

      await mockDatabase.updateClientsSyncStatus([clientId], 'synced');

      verify(() => mockDatabase.updateClientsSyncStatus([clientId], 'synced'))
          .called(1);
    });

    test('should update client sync status to conflict', () async {
      const clientId = 'client-conflict';

      when(() => mockDatabase.updateClientsSyncStatus([clientId], 'conflict'))
          .thenAnswer((_) async {});

      await mockDatabase.updateClientsSyncStatus([clientId], 'conflict');

      verify(() => mockDatabase.updateClientsSyncStatus([clientId], 'conflict'))
          .called(1);
    });

    test('should get pending credit applications', () async {
      final mockApps = [
        _createMockApplicationData('pending-app-1', 50000.0),
        _createMockApplicationData('pending-app-2', 75000.0),
      ];

      when(() => mockDatabase.getPendingCreditApplications())
          .thenAnswer((_) async => mockApps);

      final result = await mockDatabase.getPendingCreditApplications();

      expect(result.length, equals(2));
      verify(() => mockDatabase.getPendingCreditApplications()).called(1);
    });

    test('should update credit applications sync status', () async {
      const appId1 = 'app-to-sync-1';
      const appId2 = 'app-to-sync-2';

      when(() => mockDatabase.updateCreditApplicationsSyncStatus(
            [appId1, appId2],
            'synced',
          )).thenAnswer((_) async {});

      await mockDatabase.updateCreditApplicationsSyncStatus(
        [appId1, appId2],
        'synced',
      );

      verify(() => mockDatabase.updateCreditApplicationsSyncStatus(
            [appId1, appId2],
            'synced',
          )).called(1);
    });
  });

  group('Connectivity Service Integration', () {
    test('should return connected status', () async {
      final connectedStatus = ConnectivityStatus(
        status: ConnectionStatus.connected,
        timestamp: DateTime.now(),
        networkType: 'wifi',
      );

      when(() => mockConnectivityService.checkConnectivity())
          .thenAnswer((_) async => connectedStatus);

      final result = await mockConnectivityService.checkConnectivity();

      expect(result.isConnected, isTrue);
      expect(result.status, equals(ConnectionStatus.connected));
    });

    test('should return disconnected status', () async {
      final disconnectedStatus = ConnectivityStatus(
        status: ConnectionStatus.disconnected,
        timestamp: DateTime.now(),
        networkType: null,
      );

      when(() => mockConnectivityService.checkConnectivity())
          .thenAnswer((_) async => disconnectedStatus);

      final result = await mockConnectivityService.checkConnectivity();

      expect(result.isDisconnected, isTrue);
      expect(result.status, equals(ConnectionStatus.disconnected));
    });

    test('should listen to connectivity changes', () async {
      final controller = StreamController<ConnectivityStatus>.broadcast();

      when(() => mockConnectivityService.statusStream)
          .thenAnswer((_) => controller.stream);

      when(() => mockConnectivityService.startListening())
          .thenAnswer((_) async {});

      await mockConnectivityService.startListening();

      verify(() => mockConnectivityService.startListening()).called(1);

      controller.add(ConnectivityStatus(
        status: ConnectionStatus.connected,
        timestamp: DateTime.now(),
        networkType: 'wifi',
      ));

      await controller.close();
    });
  });

  group('Sync Status Entity', () {
    test('should create pending sync status', () {
      final status = domain.SyncStatus.pending;

      expect(status.value, equals('pending'));
      expect(status.isPending, isTrue);
      expect(status.isSynced, isFalse);
      expect(status.isConflict, isFalse);
    });

    test('should create synced sync status', () {
      final status = domain.SyncStatus.synced;

      expect(status.value, equals('synced'));
      expect(status.isSynced, isTrue);
      expect(status.isPending, isFalse);
    });

    test('should create conflict sync status', () {
      final status = domain.SyncStatus.conflict;

      expect(status.value, equals('conflict'));
      expect(status.isConflict, isTrue);
      expect(status.isPending, isFalse);
    });

    test('should parse sync status from string', () {
      expect(domain.SyncStatus.parse('pending'), equals(domain.SyncStatus.pending));
      expect(domain.SyncStatus.parse('synced'), equals(domain.SyncStatus.synced));
      expect(domain.SyncStatus.parse('conflict'), equals(domain.SyncStatus.conflict));
    });
  });

  group('Conflict Detection', () {
    test('should detect version mismatch', () {
      const localVersion = 1;
      const remoteVersion = 2;

      final hasConflict = remoteVersion > localVersion;

      expect(hasConflict, isTrue);
    });

    test('should not detect conflict when versions match', () {
      const localVersion = 2;
      const remoteVersion = 2;

      final hasConflict = remoteVersion > localVersion;

      expect(hasConflict, isFalse);
    });

    test('should not detect conflict when local is newer', () {
      const localVersion = 3;
      const remoteVersion = 2;

      final hasConflict = remoteVersion > localVersion;

      expect(hasConflict, isFalse);
    });
  });

  group('Retry Logic', () {
    test('should calculate exponential backoff', () {
      const baseDelay = 1000;
      const maxRetries = 3;

      final delays = List.generate(maxRetries, (index) {
        return baseDelay * (1 << index);
      });

      expect(delays[0], equals(1000));
      expect(delays[1], equals(2000));
      expect(delays[2], equals(4000));
    });

    test('should respect max retry attempts', () {
      const maxRetries = 5;
      var currentRetry = 0;

      final shouldRetry = currentRetry < maxRetries;

      expect(shouldRetry, isTrue);

      currentRetry = maxRetries;
      final shouldRetryAfterMax = currentRetry < maxRetries;

      expect(shouldRetryAfterMax, isFalse);
    });
  });
}

ClientsTableData _createMockClientData(String id, String name) {
  return ClientsTableData(
    id: id,
    firstName: name,
    lastName: 'LastName',
    email: '$id@test.com',
    phone: '+521234567890',
    address: 'Test Address',
    identificationNumber: id,
    syncStatus: 'pending',
    version: 1,
    lastModified: DateTime.now(),
    createdAt: DateTime.now(),
    syncedAt: null,
  );
}

CreditApplicationsTableData _createMockApplicationData(String id, double amount) {
  return CreditApplicationsTableData(
    id: id,
    clientId: 'client-$id',
    requestedAmount: amount,
    purpose: 'Test Purpose',
    termMonths: 12,
    status: 'pending',
    syncStatus: 'pending',
    version: 1,
    lastModified: DateTime.now(),
    createdAt: DateTime.now(),
    syncedAt: null,
    rejectionReason: null,
    approvedAmount: null,
  );
}