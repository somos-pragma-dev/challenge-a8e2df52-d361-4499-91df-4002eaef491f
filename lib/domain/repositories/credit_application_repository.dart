package domain.repositories;

import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/credit_application.dart';

abstract class CreditApplicationRepository {
  Future<Either<Failure, List<CreditApplication>>> getCreditApplications();
  Future<Either<Failure, CreditApplication>> getCreditApplicationById(String id);
  Future<Either<Failure, List<CreditApplication>>> getCreditApplicationsByClientId(String clientId);
  Future<Either<Failure, CreditApplication>> saveCreditApplication(CreditApplication application);
  Future<Either<Failure, void>> deleteCreditApplication(String id);
  Future<Either<Failure, List<CreditApplication>>> getPendingCreditApplications();
  Stream<List<CreditApplication>> watchAllCreditApplications();
  Stream<List<CreditApplication>> watchPendingCreditApplications();
  Future<Either<Failure, CreditApplication>> approveApplication(String id, double approvedAmount);
  Future<Either<Failure, CreditApplication>> rejectApplication(String id, String reason);
  Future<Either<Failure, List<CreditApplication>>> getRemoteApplications();
  Future<Either<Failure, CreditApplication?>> getRemoteApplication(String id);
  Future<Either<Failure, CreditApplication>> syncApplication(CreditApplication application);
}

class CreditApplicationFilter extends Equatable {
  final String? clientId;
  final ApplicationSyncStatus? syncStatus;
  final ApplicationStatus? status;
  final DateTime? fromDate;
  final DateTime? toDate;
  final double? minAmount;
  final double? maxAmount;

  const CreditApplicationFilter({
    this.clientId,
    this.syncStatus,
    this.status,
    this.fromDate,
    this.toDate,
    this.minAmount,
    this.maxAmount,
  });

  @override
  List<Object?> get props => [clientId, syncStatus, status, fromDate, toDate, minAmount, maxAmount];
}

enum ApplicationSyncStatus {
  pending,
  synced,
  conflict,
}

enum ApplicationStatus {
  pending,
  approved,
  rejected,
}