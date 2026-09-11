package lib.domain.entities;

import 'package:equatable/equatable.dart';
import 'base_entity.dart';

enum TransactionStatus {
  pending,
  inProgress,
  completed,
  failed,
  conflict,
}

enum TransactionType {
  payment,
  refund,
  transfer,
  deposit,
  withdrawal,
}

class Transaction extends BaseEntity {
  final String localId;
  final String? remoteId;
  final Map<String, dynamic> payload;
  final TransactionStatus status;
  final DateTime? syncedAt;
  final TransactionType type;
  final double amount;
  final String currency;
  final String? description;
  final String? hash;

  const Transaction({
    required super.id,
    required this.localId,
    this.remoteId,
    required this.payload,
    required this.status,
    required super.createdAt,
    required super.updatedAt,
    required super.version,
    this.syncedAt,
    required this.type,
    required this.amount,
    required this.currency,
    this.description,
    this.hash,
  });

  Transaction copyWith({
    String? id,
    String? localId,
    String? remoteId,
    Map<String, dynamic>? payload,
    TransactionStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    DateTime? syncedAt,
    TransactionType? type,
    double? amount,
    String? currency,
    String? description,
    String? hash,
  }) {
    return Transaction(
      id: id ?? this.id,
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      syncedAt: syncedAt ?? this.syncedAt,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      hash: hash ?? this.hash,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'localId': localId,
      'remoteId': remoteId,
      'payload': payload,
      'status': status.name,
      'syncedAt': syncedAt?.toIso8601String(),
      'type': type.name,
      'amount': amount,
      'currency': currency,
      'description': description,
      'hash': hash,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      localId: map['localId'] as String,
      remoteId: map['remoteId'] as String?,
      payload: map['payload'] as Map<String, dynamic>,
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => TransactionStatus.pending,
      ),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      version: map['version'] as int,
      syncedAt: map['syncedAt'] != null
          ? DateTime.parse(map['syncedAt'] as String)
          : null,
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.payment,
      ),
      amount: (map['amount'] as num).toDouble(),
      currency: map['currency'] as String,
      description: map['description'] as String?,
      hash: map['hash'] as String?,
    );
  }

  bool get isSynced => remoteId != null && syncedAt != null;

  bool get isPending =>
      status == TransactionStatus.pending ||
      status == TransactionStatus.inProgress;

  bool get hasConflict => status == TransactionStatus.conflict;

  String generateHash() {
    final content = '$localId${type.name}$amount$currency$createdAt';
    return content.hashCode.toString();
  }

  @override
  List<Object?> get props => [
        ...super.props,
        localId,
        remoteId,
        payload,
        status,
        syncedAt,
        type,
        amount,
        currency,
        description,
        hash,
      ];

  @override
  bool get stringify => true;
}