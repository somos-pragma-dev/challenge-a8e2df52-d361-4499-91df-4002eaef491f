package lib.domain.entities;

import 'package:equatable/equatable.dart';

enum SyncOperationType {
  create,
  update,
  delete,
}

enum SyncEntityType {
  transaction,
  user,
  config,
  settings,
}

class SyncRecord extends Equatable {
  final String id;
  final SyncOperationType operationType;
  final SyncEntityType entityType;
  final String entityId;
  final String payloadHash;
  final DateTime timestamp;
  final bool synced;
  final int retryCount;
  final String? errorMessage;
  final DateTime? lastAttemptAt;

  const SyncRecord({
    required this.id,
    required this.operationType,
    required this.entityType,
    required this.entityId,
    required this.payloadHash,
    required this.timestamp,
    required this.synced,
    this.retryCount = 0,
    this.errorMessage,
    this.lastAttemptAt,
  });

  SyncRecord copyWith({
    String? id,
    SyncOperationType? operationType,
    SyncEntityType? entityType,
    String? entityId,
    String? payloadHash,
    DateTime? timestamp,
    bool? synced,
    int? retryCount,
    String? errorMessage,
    DateTime? lastAttemptAt,
  }) {
    return SyncRecord(
      id: id ?? this.id,
      operationType: operationType ?? this.operationType,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      payloadHash: payloadHash ?? this.payloadHash,
      timestamp: timestamp ?? this.timestamp,
      synced: synced ?? this.synced,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'operationType': operationType.name,
      'entityType': entityType.name,
      'entityId': entityId,
      'payloadHash': payloadHash,
      'timestamp': timestamp.toIso8601String(),
      'synced': synced ? 1 : 0,
      'retryCount': retryCount,
      'errorMessage': errorMessage,
      'lastAttemptAt': lastAttemptAt?.toIso8601String(),
    };
  }

  factory SyncRecord.fromMap(Map<String, dynamic> map) {
    return SyncRecord(
      id: map['id'] as String,
      operationType: SyncOperationType.values.firstWhere(
        (e) => e.name == map['operationType'],
        orElse: () => SyncOperationType.create,
      ),
      entityType: SyncEntityType.values.firstWhere(
        (e) => e.name == map['entityType'],
        orElse: () => SyncEntityType.transaction,
      ),
      entityId: map['entityId'] as String,
      payloadHash: map['payloadHash'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      synced: (map['synced'] as int) == 1,
      retryCount: map['retryCount'] as int? ?? 0,
      errorMessage: map['errorMessage'] as String?,
      lastAttemptAt: map['lastAttemptAt'] != null
          ? DateTime.parse(map['lastAttemptAt'] as String)
          : null,
    );
  }

  bool get canRetry => retryCount < 3 && !synced;

  bool get isStale =>
      !synced &&
      DateTime.now().difference(timestamp).inHours > 24;

  SyncRecord incrementRetry({String? error}) {
    return copyWith(
      retryCount: retryCount + 1,
      lastAttemptAt: DateTime.now(),
      errorMessage: error,
    );
  }

  SyncRecord markAsSynced() {
    return copyWith(
      synced: true,
      lastAttemptAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        operationType,
        entityType,
        entityId,
        payloadHash,
        timestamp,
        synced,
        retryCount,
        errorMessage,
        lastAttemptAt,
      ];

  @override
  bool get stringify => true;
}