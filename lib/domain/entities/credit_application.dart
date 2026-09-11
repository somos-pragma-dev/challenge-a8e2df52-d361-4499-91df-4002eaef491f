package lib.domain.entities;

import 'package:equatable/equatable.dart';

enum ApplicationStatus { pending, approved, rejected }

enum ApplicationSyncStatus { pending, synced, conflict }

class CreditApplication extends Equatable {
  final String id;
  final String clientId;
  final double requestedAmount;
  final String purpose;
  final int termMonths;
  final ApplicationStatus status;
  final ApplicationSyncStatus syncStatus;
  final int version;
  final DateTime lastModified;
  final DateTime createdAt;
  final DateTime? syncedAt;
  final String? rejectionReason;
  final double? approvedAmount;

  const CreditApplication({
    required this.id,
    required this.clientId,
    required this.requestedAmount,
    required this.purpose,
    required this.termMonths,
    required this.status,
    required this.syncStatus,
    required this.version,
    required this.lastModified,
    required this.createdAt,
    this.syncedAt,
    this.rejectionReason,
    this.approvedAmount,
  });

  bool get hasPendingSync => syncStatus == ApplicationSyncStatus.pending;

  bool get hasConflict => syncStatus == ApplicationSyncStatus.conflict;

  bool get isSynced => syncStatus == ApplicationSyncStatus.synced;

  bool get isPending => status == ApplicationStatus.pending;

  bool get isApproved => status == ApplicationStatus.approved;

  bool get isRejected => status == ApplicationStatus.rejected;

  bool get hasApprovedAmount => approvedAmount != null && approvedAmount! > 0;

  double get approvalRate {
    if (approvedAmount == null || requestedAmount == 0) return 0.0;
    return approvedAmount! / requestedAmount;
  }

  CreditApplication copyWith({
    String? id,
    String? clientId,
    double? requestedAmount,
    String? purpose,
    int? termMonths,
    ApplicationStatus? status,
    ApplicationSyncStatus? syncStatus,
    int? version,
    DateTime? lastModified,
    DateTime? createdAt,
    DateTime? syncedAt,
    String? rejectionReason,
    double? approvedAmount,
  }) {
    return CreditApplication(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      requestedAmount: requestedAmount ?? this.requestedAmount,
      purpose: purpose ?? this.purpose,
      termMonths: termMonths ?? this.termMonths,
      status: status ?? this.status,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      lastModified: lastModified ?? this.lastModified,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      approvedAmount: approvedAmount ?? this.approvedAmount,
    );
  }

  CreditApplication incrementVersion() {
    return copyWith(
      version: version + 1,
      lastModified: DateTime.now(),
    );
  }

  CreditApplication markAsPending() {
    return copyWith(
      syncStatus: ApplicationSyncStatus.pending,
      lastModified: DateTime.now(),
    );
  }

  CreditApplication markAsSynced() {
    return copyWith(
      syncStatus: ApplicationSyncStatus.synced,
      syncedAt: DateTime.now(),
    );
  }

  CreditApplication markAsConflict() {
    return copyWith(
      syncStatus: ApplicationSyncStatus.conflict,
      lastModified: DateTime.now(),
    );
  }

  CreditApplication approve(double amount) {
    return copyWith(
      status: ApplicationStatus.approved,
      approvedAmount: amount,
      syncStatus: ApplicationSyncStatus.pending,
      version: version + 1,
      lastModified: DateTime.now(),
    );
  }

  CreditApplication reject(String reason) {
    return copyWith(
      status: ApplicationStatus.rejected,
      rejectionReason: reason,
      syncStatus: ApplicationSyncStatus.pending,
      version: version + 1,
      lastModified: DateTime.now(),
    );
  }

  static CreditApplication create({
    required String id,
    required String clientId,
    required double requestedAmount,
    required String purpose,
    required int termMonths,
  }) {
    final now = DateTime.now();
    return CreditApplication(
      id: id,
      clientId: clientId,
      requestedAmount: requestedAmount,
      purpose: purpose,
      termMonths: termMonths,
      status: ApplicationStatus.pending,
      syncStatus: ApplicationSyncStatus.pending,
      version: 1,
      lastModified: now,
      createdAt: now,
    );
  }

  @override
  List<Object?> get props => [
        id,
        clientId,
        requestedAmount,
        purpose,
        termMonths,
        status,
        syncStatus,
        version,
        lastModified,
        createdAt,
        syncedAt,
        rejectionReason,
        approvedAmount,
      ];
}