package lib.data.models;

import 'dart:convert';
import 'package:lib/core/constants/app_constants.dart';
import 'package:lib/domain/entities/transaction.dart';

class TransactionModel {
  final String id;
  final String? externalId;
  final double amount;
  final String currency;
  final String transactionType;
  final String description;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;
  final String syncStatus;
  final String? hash;

  TransactionModel({
    required this.id,
    this.externalId,
    required this.amount,
    required this.currency,
    required this.transactionType,
    required this.description,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.syncStatus,
    this.hash,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json[DatabaseColumns.id] as String,
      externalId: json[DatabaseColumns.externalId] as String?,
      amount: (json[DatabaseColumns.amount] as num).toDouble(),
      currency: json[DatabaseColumns.currency] as String,
      transactionType: json[DatabaseColumns.transactionType] as String,
      description: json[DatabaseColumns.description] as String,
      metadata: json[DatabaseColumns.metadata] != null
          ? jsonDecode(json[DatabaseColumns.metadata] as String) as Map<String, dynamic>
          : null,
      createdAt: DateTime.parse(json[DatabaseColumns.createdAt] as String),
      updatedAt: DateTime.parse(json[DatabaseColumns.updatedAt] as String),
      version: json[DatabaseColumns.version] as int,
      syncStatus: json[DatabaseColumns.syncStatus] as String,
      hash: json[DatabaseColumns.hash] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      DatabaseColumns.id: id,
      DatabaseColumns.externalId: externalId,
      DatabaseColumns.amount: amount,
      DatabaseColumns.currency: currency,
      DatabaseColumns.transactionType: transactionType,
      DatabaseColumns.description: description,
      DatabaseColumns.metadata: metadata != null ? jsonEncode(metadata) : null,
      DatabaseColumns.createdAt: createdAt.toIso8601String(),
      DatabaseColumns.updatedAt: updatedAt.toIso8601String(),
      DatabaseColumns.version: version,
      DatabaseColumns.syncStatus: syncStatus,
      DatabaseColumns.hash: hash,
    };
  }

  Map<String, dynamic> toMap() {
    return toJson();
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel.fromJson(map);
  }

  Transaction toEntity() {
    return Transaction(
      id: id,
      externalId: externalId,
      amount: amount,
      currency: currency,
      transactionType: transactionType,
      description: description,
      metadata: metadata,
      createdAt: createdAt,
      updatedAt: updatedAt,
      version: version,
      syncStatus: syncStatus,
    );
  }

  factory TransactionModel.fromEntity(Transaction entity) {
    return TransactionModel(
      id: entity.id,
      externalId: entity.externalId,
      amount: entity.amount,
      currency: entity.currency,
      transactionType: entity.transactionType,
      description: entity.description,
      metadata: entity.metadata,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      version: entity.version,
      syncStatus: entity.syncStatus,
      hash: entity.hash,
    );
  }

  TransactionModel copyWith({
    String? id,
    String? externalId,
    double? amount,
    String? currency,
    String? transactionType,
    String? description,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
    String? syncStatus,
    String? hash,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      externalId: externalId ?? this.externalId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      transactionType: transactionType ?? this.transactionType,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      syncStatus: syncStatus ?? this.syncStatus,
      hash: hash ?? this.hash,
    );
  }

  @override
  String toString() {
    return 'TransactionModel(id: $id, amount: $amount $currency, type: $transactionType, syncStatus: $syncStatus)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransactionModel &&
        other.id == id &&
        other.externalId == externalId &&
        other.amount == amount &&
        other.currency == currency &&
        other.transactionType == transactionType &&
        other.description == description &&
        other.version == version &&
        other.syncStatus == syncStatus;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      externalId,
      amount,
      currency,
      transactionType,
      description,
      version,
      syncStatus,
    );
  }
}