package credit_field_app.data.models;

import 'package:equatable/equatable.dart';

import '../../domain/entities/client.dart' as entity;
import '../../domain/entities/sync_status.dart';

class ClientModel extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String identificationNumber;
  final SyncStatus syncStatus;
  final int version;
  final DateTime lastModified;
  final DateTime createdAt;
  final DateTime? syncedAt;

  const ClientModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.identificationNumber,
    required this.syncStatus,
    required this.version,
    required this.lastModified,
    required this.createdAt,
    this.syncedAt,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      identificationNumber: json['identificationNumber'] as String? ?? '',
      syncStatus: _parseSyncStatus(json['syncStatus'] as String?),
      version: json['version'] as int? ?? 1,
      lastModified: json['lastModified'] != null
          ? DateTime.parse(json['lastModified'] as String)
          : DateTime.now(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      syncedAt: json['syncedAt'] != null
          ? DateTime.parse(json['syncedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'identificationNumber': identificationNumber,
      'syncStatus': syncStatus.name,
      'version': version,
      'lastModified': lastModified.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'syncedAt': syncedAt?.toIso8601String(),
    };
  }

  factory ClientModel.fromEntity(entity.Client client) {
    return ClientModel(
      id: client.id,
      firstName: client.firstName,
      lastName: client.lastName,
      email: client.email,
      phone: client.phone,
      address: client.address,
      identificationNumber: client.identificationNumber,
      syncStatus: _mapEntitySyncStatus(client.syncStatus),
      version: client.version,
      lastModified: client.lastModified,
      createdAt: client.createdAt,
      syncedAt: client.syncedAt,
    );
  }

  entity.Client toEntity() {
    return entity.Client(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      address: address,
      identificationNumber: identificationNumber,
      syncStatus: _mapModelSyncStatus(syncStatus),
      version: version,
      lastModified: lastModified,
      createdAt: createdAt,
      syncedAt: syncedAt,
    );
  }

  Map<String, dynamic> toRemote() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'identificationNumber': identificationNumber,
      'version': version,
      'lastModified': lastModified.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ClientModel.fromRemote(Map<String, dynamic> json) {
    return ClientModel.fromJson(json);
  }

  ClientModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    String? identificationNumber,
    SyncStatus? syncStatus,
    int? version,
    DateTime? lastModified,
    DateTime? createdAt,
    DateTime? syncedAt,
  }) {
    return ClientModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      identificationNumber: identificationNumber ?? this.identificationNumber,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      lastModified: lastModified ?? this.lastModified,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  static SyncStatus _parseSyncStatus(String? status) {
    switch (status) {
      case 'synced':
        return SyncStatus.synced;
      case 'conflict':
        return SyncStatus.conflict;
      case 'pending':
      default:
        return SyncStatus.pending;
    }
  }

  static SyncStatus _mapEntitySyncStatus(entity.ClientSyncStatus status) {
    switch (status) {
      case entity.ClientSyncStatus.synced:
        return SyncStatus.synced;
      case entity.ClientSyncStatus.conflict:
        return SyncStatus.conflict;
      case entity.ClientSyncStatus.pending:
      default:
        return SyncStatus.pending;
    }
  }

  static entity.ClientSyncStatus _mapModelSyncStatus(SyncStatus status) {
    switch (status) {
      case SyncStatus.synced:
        return entity.ClientSyncStatus.synced;
      case SyncStatus.conflict:
        return entity.ClientSyncStatus.conflict;
      case SyncStatus.pending:
      default:
        return entity.ClientSyncStatus.pending;
    }
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phone,
        address,
        identificationNumber,
        syncStatus,
        version,
        lastModified,
        createdAt,
        syncedAt,
      ];
}