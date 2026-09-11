package lib.domain.entities;

import 'package:equatable/equatable.dart';

enum ClientSyncStatus { pending, synced, conflict }

class Client extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String identificationNumber;
  final ClientSyncStatus syncStatus;
  final int version;
  final DateTime lastModified;
  final DateTime createdAt;
  final DateTime? syncedAt;

  const Client({
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

  String get fullName => '$firstName $lastName';

  bool get hasPendingSync => syncStatus == ClientSyncStatus.pending;

  bool get hasConflict => syncStatus == ClientSyncStatus.conflict;

  bool get isSynced => syncStatus == ClientSyncStatus.synced;

  Client copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    String? identificationNumber,
    ClientSyncStatus? syncStatus,
    int? version,
    DateTime? lastModified,
    DateTime? createdAt,
    DateTime? syncedAt,
  }) {
    return Client(
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

  Client incrementVersion() {
    return copyWith(
      version: version + 1,
      lastModified: DateTime.now(),
    );
  }

  Client markAsPending() {
    return copyWith(
      syncStatus: ClientSyncStatus.pending,
      lastModified: DateTime.now(),
    );
  }

  Client markAsSynced() {
    return copyWith(
      syncStatus: ClientSyncStatus.synced,
      syncedAt: DateTime.now(),
    );
  }

  Client markAsConflict() {
    return copyWith(
      syncStatus: ClientSyncStatus.conflict,
      lastModified: DateTime.now(),
    );
  }

  static Client create({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String address,
    required String identificationNumber,
  }) {
    final now = DateTime.now();
    return Client(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      address: address,
      identificationNumber: identificationNumber,
      syncStatus: ClientSyncStatus.pending,
      version: 1,
      lastModified: now,
      createdAt: now,
    );
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