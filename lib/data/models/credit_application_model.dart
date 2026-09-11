package credit_field_app.data.models;

import 'package:equatable/equatable.dart';
import '../../domain/entities/credit_application.dart';
import '../../domain/entities/sync_status.dart';

enum ApplicationStatus { pending, approved, rejected, underReview }

class CreditApplicationModel extends Equatable {
  final String id;
  final String clientId;
  final double requestedAmount;
  final String purpose;
  final int termMonths;
  final ApplicationStatus status;
  final SyncStatusEnum syncStatus;
  final int version;
  final DateTime lastModified;
  final DateTime createdAt;
  final DateTime? syncedAt;
  final String? rejectionReason;
  final double? approvedAmount;

  const CreditApplicationModel({
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

  factory CreditApplicationModel.fromJson(Map<String, dynamic> json) {
    return CreditApplicationModel(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      requestedAmount: (json['requestedAmount'] as num).toDouble(),
      purpose: json['purpose'] as String,
      termMonths: json['termMonths'] as int,
      status: _parseApplicationStatus(json['status'] as String?),
      syncStatus: _parseSyncStatus(json['syncStatus'] as String?),
      version: json['version'] as int,
      lastModified: DateTime.parse(json['lastModified'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      syncedAt: json['syncedAt'] != null 
          ? DateTime.parse(json['syncedAt'] as String) 
          : null,
      rejectionReason: json['rejectionReason'] as String?,
      approvedAmount: json['approvedAmount'] != null 
          ? (json['approvedAmount'] as num).toDouble() 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'requestedAmount': requestedAmount,
      'purpose': purpose,
      'termMonths': termMonths,
      'status': _mapModelStatus(status),
      'syncStatus': syncStatus.name,
      'version': version,
      'lastModified': lastModified.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'syncedAt': syncedAt?.toIso8601String(),
      'rejectionReason': rejectionReason,
      'approvedAmount': approvedAmount,
    };
  }

  factory CreditApplicationModel.fromEntity(CreditApplication entity) {
    return CreditApplicationModel(
      id: entity.id,
      clientId: entity.clientId,
      requestedAmount: entity.requestedAmount,
      purpose: entity.purpose,
      termMonths: entity.termMonths,
      status: _mapEntityStatus(entity.status),
      syncStatus: _parseSyncStatus(entity.syncStatus.name),
      version: entity.version,
      lastModified: entity.lastModified,
      createdAt: entity.createdAt,
      syncedAt: entity.syncedAt,
      rejectionReason: entity.rejectionReason,
      approvedAmount: entity.approvedAmount,
    );
  }

  CreditApplication toEntity() {
    return CreditApplication(
      id: id,
      clientId: clientId,
      requestedAmount: requestedAmount,
      purpose: purpose,
      termMonths: termMonths,
      status: _mapModelStatusToEntity(status),
      syncStatus: ApplicationSyncStatus.values.firstWhere(
        (e) => e.name == syncStatus.name,
        orElse: () => ApplicationSyncStatus.pending,
      ),
      version: version,
      lastModified: lastModified,
      createdAt: createdAt,
      syncedAt: syncedAt,
      rejectionReason: rejectionReason,
      approvedAmount: approvedAmount,
    );
  }

  CreditApplicationModel copyWith({
    String? id,
    String? clientId,
    double? requestedAmount,
    String? purpose,
    int? termMonths,
    ApplicationStatus? status,
    SyncStatusEnum? syncStatus,
    int? version,
    DateTime? lastModified,
    DateTime? createdAt,
    DateTime? syncedAt,
    String? rejectionReason,
    double? approvedAmount,
  }) {
    return CreditApplicationModel(
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

  static ApplicationStatus _parseApplicationStatus(String? status) {
    switch (status) {
      case 'approved':
        return ApplicationStatus.approved;
      case 'rejected':
        return ApplicationStatus.rejected;
      case 'underReview':
        return ApplicationStatus.underReview;
      default:
        return ApplicationStatus.pending;
    }
  }

  static SyncStatusEnum _parseSyncStatus(String? status) {
    switch (status) {
      case 'synced':
        return SyncStatusEnum.synced;
      case 'conflict':
        return SyncStatusEnum.conflict;
      default:
        return SyncStatusEnum.pending;
    }
  }

  static ApplicationStatus _mapEntityStatus(ApplicationStatus entityStatus) {
    switch (entityStatus) {
      case ApplicationStatus.pending:
        return ApplicationStatus.pending;
      case ApplicationStatus.approved:
        return ApplicationStatus.approved;
      case ApplicationStatus.rejected:
        return ApplicationStatus.rejected;
      case ApplicationStatus.underReview:
        return ApplicationStatus.underReview;
    }
  }

  static ApplicationStatus _mapModelStatusToEntity(ApplicationStatus modelStatus) {
    switch (modelStatus) {
      case ApplicationStatus.pending:
        return ApplicationStatus.pending;
      case ApplicationStatus.approved:
        return ApplicationStatus.approved;
      case ApplicationStatus.rejected:
        return ApplicationStatus.rejected;
      case ApplicationStatus.underReview:
        return ApplicationStatus.underReview;
    }
  }

  static String _mapModelStatus(ApplicationStatus modelStatus) {
    return modelStatus.name;
  }
}