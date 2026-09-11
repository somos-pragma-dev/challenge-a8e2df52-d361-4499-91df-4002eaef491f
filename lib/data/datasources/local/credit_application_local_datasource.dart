package lib.data.datasources.local;

import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../models/credit_application_model.dart';
import '../../../core/database/app_database.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/credit_application.dart';

abstract class CreditApplicationLocalDatasource {
  Future<Either<Failure, List<CreditApplicationModel>>> getAllApplications();
  Stream<List<CreditApplicationModel>> watchAllApplications();
  Future<Either<Failure, CreditApplicationModel>> getApplicationById(String id);
  Future<Either<Failure, List<CreditApplicationModel>>> getApplicationsByClientId(String clientId);
  Future<Either<Failure, String>> saveApplication(CreditApplicationModel application);
  Future<Either<Failure, bool>> updateApplication(CreditApplicationModel application);
  Future<Either<Failure, bool>> deleteApplication(String id);
  Future<Either<Failure, List<CreditApplicationModel>>> getPendingApplications();
  Stream<List<CreditApplicationModel>> watchPendingApplications();
  Future<Either<Failure, void>> updateSyncStatus(String id, String status);
  Future<Either<Failure, void>> markAsSynced(String id, DateTime syncedAt);
}

class CreditApplicationLocalDatasourceImpl implements CreditApplicationLocalDatasource {
  final AppDatabase _database;
  final Uuid _uuid = const Uuid();

  CreditApplicationLocalDatasourceImpl(this._database);

  @override
  Future<Either<Failure, List<CreditApplicationModel>>> getAllApplications() async {
    try {
      final applications = await _database.getAllCreditApplications();
      final models = applications.map(_mapToModel).toList();
      return Right(models);
    } catch (e) {
      return Left(DatabaseFailure.queryError('Error al obtener solicitudes: $e'));
    }
  }

  @override
  Stream<List<CreditApplicationModel>> watchAllApplications() {
    return _database.watchAllCreditApplications().map(
      (applications) => applications.map(_mapToModel).toList(),
    );
  }

  @override
  Future<Either<Failure, CreditApplicationModel>> getApplicationById(String id) async {
    try {
      final application = await _database.getCreditApplicationById(id);
      if (application == null) {
        return const Left(DatabaseFailure.notFound());
      }
      return Right(_mapToModel(application));
    } catch (e) {
      return Left(DatabaseFailure.queryError('Error al obtener solicitud: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CreditApplicationModel>>> getApplicationsByClientId(String clientId) async {
    try {
      final applications = await _database.getCreditApplicationsByClientId(clientId);
      final models = applications.map(_mapToModel).toList();
      return Right(models);
    } catch (e) {
      return Left(DatabaseFailure.queryError('Error al obtener solicitudes del cliente: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> saveApplication(CreditApplicationModel application) async {
    try {
      final id = application.id.isEmpty ? _uuid.v4() : application.id;
      final now = DateTime.now();
      
      final companion = CreditApplicationsTableCompanion.insert(
        id: id,
        clientId: application.clientId,
        requestedAmount: application.requestedAmount,
        purpose: application.purpose,
        termMonths: application.termMonths,
        status: application.status,
        syncStatus: const Value('pending'),
        version: const Value(1),
        lastModified: now,
        createdAt: now,
        syncedAt: const Value(null),
        rejectionReason: Value(application.rejectionReason),
        approvedAmount: Value(application.approvedAmount),
      );
      
      await _database.insertCreditApplication(companion);
      return Right(id);
    } catch (e) {
      return Left(DatabaseFailure.insertError('Error al guardar solicitud: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> updateApplication(CreditApplicationModel application) async {
    try {
      final existing = await _database.getCreditApplicationById(application.id);
      if (existing == null) {
        return const Left(DatabaseFailure.notFound());
      }

      final now = DateTime.now();
      final newVersion = existing.version + 1;
      final needsSync = application.syncStatus == 'pending' || 
                        (existing.syncStatus == 'synced' && application.syncStatus == 'pending');

      final companion = CreditApplicationsTableCompanion(
        id: Value(application.id),
        clientId: Value(application.clientId),
        requestedAmount: Value(application.requestedAmount),
        purpose: Value(application.purpose),
        termMonths: Value(application.termMonths),
        status: Value(application.status),
        syncStatus: Value(needsSync ? 'pending' : existing.syncStatus),
        version: Value(newVersion),
        lastModified: Value(now),
        createdAt: Value(existing.createdAt),
        syncedAt: Value(existing.syncedAt),
        rejectionReason: Value(application.rejectionReason),
        approvedAmount: Value(application.approvedAmount),
      );

      final result = await _database.updateCreditApplication(companion);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure.updateError('Error al actualizar solicitud: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteApplication(String id) async {
    try {
      final count = await _database.deleteCreditApplication(id);
      return Right(count > 0);
    } catch (e) {
      return Left(DatabaseFailure.deleteError('Error al eliminar solicitud: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CreditApplicationModel>>> getPendingApplications() async {
    try {
      final applications = await _database.getPendingCreditApplications();
      final models = applications.map(_mapToModel).toList();
      return Right(models);
    } catch (e) {
      return Left(DatabaseFailure.queryError('Error al obtener solicitudes pendientes: $e'));
    }
  }

  @override
  Stream<List<CreditApplicationModel>> watchPendingApplications() {
    return _database.watchPendingCreditApplications().map(
      (applications) => applications.map(_mapToModel).toList(),
    );
  }

  @override
  Future<Either<Failure, void>> updateSyncStatus(String id, String status) async {
    try {
      final existing = await _database.getCreditApplicationById(id);
      if (existing == null) {
        return const Left(DatabaseFailure.notFound());
      }

      final companion = CreditApplicationsTableCompanion(
        id: Value(id),
        clientId: Value(existing.clientId),
        requestedAmount: Value(existing.requestedAmount),
        purpose: Value(existing.purpose),
        termMonths: Value(existing.termMonths),
        status: Value(existing.status),
        syncStatus: Value(status),
        version: Value(existing.version),
        lastModified: Value(existing.lastModified),
        createdAt: Value(existing.createdAt),
        syncedAt: Value(existing.syncedAt),
        rejectionReason: Value(existing.rejectionReason),
        approvedAmount: Value(existing.approvedAmount),
      );

      await _database.updateCreditApplication(companion);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure.updateError('Error al actualizar estado de sincronización: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> markAsSynced(String id, DateTime syncedAt) async {
    try {
      final existing = await _database.getCreditApplicationById(id);
      if (existing == null) {
        return const Left(DatabaseFailure.notFound());
      }

      final companion = CreditApplicationsTableCompanion(
        id: Value(id),
        clientId: Value(existing.clientId),
        requestedAmount: Value(existing.requestedAmount),
        purpose: Value(existing.purpose),
        termMonths: Value(existing.termMonths),
        status: Value(existing.status),
        syncStatus: const Value('synced'),
        version: Value(existing.version),
        lastModified: Value(existing.lastModified),
        createdAt: Value(existing.createdAt),
        syncedAt: Value(syncedAt),
        rejectionReason: Value(existing.rejectionReason),
        approvedAmount: Value(existing.approvedAmount),
      );

      await _database.updateCreditApplication(companion);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure.updateError('Error al marcar como sincronizado: $e'));
    }
  }

  CreditApplicationModel _mapToModel(CreditApplicationsTableData data) {
    return CreditApplicationModel(
      id: data.id,
      clientId: data.clientId,
      requestedAmount: data.requestedAmount,
      purpose: data.purpose,
      termMonths: data.termMonths,
      status: data.status,
      syncStatus: data.syncStatus,
      version: data.version,
      lastModified: data.lastModified,
      createdAt: data.createdAt,
      syncedAt: data.syncedAt,
      rejectionReason: data.rejectionReason,
      approvedAmount: data.approvedAmount,
    );
  }
}