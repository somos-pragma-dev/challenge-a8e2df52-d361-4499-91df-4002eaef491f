import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import '../errors/exceptions.dart';

enum IdempotencyStatus {
  pending,
  processing,
  completed,
  failed,
  duplicate,
}

class IdempotencyRecord extends Equatable {
  final String operationHash;
  final String? existingRecordId;
  final IdempotencyStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final Map<String, dynamic>? resultData;
  final String? errorMessage;

  const IdempotencyRecord({
    required this.operationHash,
    this.existingRecordId,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.resultData,
    this.errorMessage,
  });

  IdempotencyRecord copyWith({
    String? operationHash,
    String? existingRecordId,
    IdempotencyStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
    Map<String, dynamic>? resultData,
    String? errorMessage,
  }) {
    return IdempotencyRecord(
      operationHash: operationHash ?? this.operationHash,
      existingRecordId: existingRecordId ?? this.existingRecordId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      resultData: resultData ?? this.resultData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'operationHash': operationHash,
      'existingRecordId': existingRecordId,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'resultData': resultData != null ? jsonEncode(resultData) : null,
      'errorMessage': errorMessage,
    };
  }

  factory IdempotencyRecord.fromMap(Map<String, dynamic> map) {
    return IdempotencyRecord(
      operationHash: map['operationHash'] as String,
      existingRecordId: map['existingRecordId'] as String?,
      status: IdempotencyStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => IdempotencyStatus.pending,
      ),
      createdAt: DateTime.parse(map['createdAt'] as String),
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'] as String)
          : null,
      resultData: map['resultData'] != null
          ? jsonDecode(map['resultData'] as String) as Map<String, dynamic>
          : null,
      errorMessage: map['errorMessage'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        operationHash,
        existingRecordId,
        status,
        createdAt,
        completedAt,
        resultData,
        errorMessage,
      ];
}

abstract class IdempotencyManager {
  Future<String> generateOperationHash(String operationType, Map<String, dynamic> payload);
  Future<bool> isOperationProcessed(String operationHash);
  Future<IdempotencyRecord?> getRecord(String operationHash);
  Future<void> markAsProcessing(String operationHash);
  Future<void> markAsCompleted(String operationHash, String recordId, Map<String, dynamic>? resultData);
  Future<void> markAsFailed(String operationHash, String errorMessage);
  Future<void> markAsDuplicate(String operationHash, String existingRecordId);
  Future<void> cleanupOldRecords(Duration maxAge);
}

class IdempotencyManagerImpl implements IdempotencyManager {
  final Map<String, IdempotencyRecord> _memoryCache = {};
  final Duration defaultMaxAge;
  final int maxCacheSize;

  IdempotencyManagerImpl({
    this.defaultMaxAge = const Duration(days: 7),
    this.maxCacheSize = 1000,
  });

  @override
  Future<String> generateOperationHash(
    String operationType,
    Map<String, dynamic> payload,
  ) async {
    final normalizedPayload = _normalizePayload(payload);
    final payloadString = jsonEncode(normalizedPayload);
    final hashInput = '$operationType:$payloadString';
    final hashBytes = utf8.encode(hashInput);
    final digest = sha256.convert(hashBytes);
    return digest.toString();
  }

  Map<String, dynamic> _normalizePayload(Map<String, dynamic> payload) {
    final normalized = Map<String, dynamic>.from(payload);
    normalized.remove('id');
    normalized.remove('createdAt');
    normalized.remove('updatedAt');
    normalized.remove('syncStatus');
    normalized.remove('version');
    final sortedKeys = normalized.keys.toList()..sort();
    final result = <String, dynamic>{};
    for (final key in sortedKeys) {
      final value = normalized[key];
      if (value is Map<String, dynamic>) {
        result[key] = _normalizePayload(value);
      } else if (value is List) {
        result[key] = value.map((e) => e is Map<String, dynamic> ? _normalizePayload(e) : e).toList();
      } else {
        result[key] = value;
      }
    }
    return result;
  }

  @override
  Future<bool> isOperationProcessed(String operationHash) async {
    final record = _memoryCache[operationHash];
    if (record != null) {
      return record.status == IdempotencyStatus.completed ||
          record.status == IdempotencyStatus.duplicate;
    }
    return false;
  }

  @override
  Future<IdempotencyRecord?> getRecord(String operationHash) async {
    return _memoryCache[operationHash];
  }

  @override
  Future<void> markAsProcessing(String operationHash) async {
    _enforceCacheLimit();
    final record = IdempotencyRecord(
      operationHash: operationHash,
      status: IdempotencyStatus.processing,
      createdAt: DateTime.now(),
    );
    _memoryCache[operationHash] = record;
  }

  @override
  Future<void> markAsCompleted(
    String operationHash,
    String recordId,
    Map<String, dynamic>? resultData,
  ) async {
    final existing = _memoryCache[operationHash];
    if (existing == null) {
      throw IdempotencyException(
        'Cannot mark non-existent operation as completed',
        operationHash: operationHash,
      );
    }
    _memoryCache[operationHash] = existing.copyWith(
      status: IdempotencyStatus.completed,
      completedAt: DateTime.now(),
      existingRecordId: recordId,
      resultData: resultData,
    );
  }

  @override
  Future<void> markAsFailed(String operationHash, String errorMessage) async {
    final existing = _memoryCache[operationHash];
    if (existing == null) {
      throw IdempotencyException(
        'Cannot mark non-existent operation as failed',
        operationHash: operationHash,
      );
    }
    _memoryCache[operationHash] = existing.copyWith(
      status: IdempotencyStatus.failed,
      completedAt: DateTime.now(),
      errorMessage: errorMessage,
    );
  }

  @override
  Future<void> markAsDuplicate(
    String operationHash,
    String existingRecordId,
  ) async {
    _enforceCacheLimit();
    final record = IdempotencyRecord(
      operationHash: operationHash,
      existingRecordId: existingRecordId,
      status: IdempotencyStatus.duplicate,
      createdAt: DateTime.now(),
      completedAt: DateTime.now(),
    );
    _memoryCache[operationHash] = record;
  }

  @override
  Future<void> cleanupOldRecords(Duration maxAge) async {
    final cutoff = DateTime.now().subtract(maxAge);
    final keysToRemove = <String>[];
    for (final entry in _memoryCache.entries) {
      if (entry.value.createdAt.isBefore(cutoff) &&
          (entry.value.status == IdempotencyStatus.completed ||
              entry.value.status == IdempotencyStatus.duplicate ||
              entry.value.status == IdempotencyStatus.failed)) {
        keysToRemove.add(entry.key);
      }
    }
    for (final key in keysToRemove) {
      _memoryCache.remove(key);
    }
  }

  void _enforceCacheLimit() {
    if (_memoryCache.length >= maxCacheSize) {
      final sortedEntries = _memoryCache.entries.toList()
        ..sort((a, b) => a.value.createdAt.compareTo(b.value.createdAt));
      final toRemove = sortedEntries.take(_memoryCache.length - maxCacheSize + 100);
      for (final entry in toRemove) {
        _memoryCache.remove(entry.key);
      }
    }
  }

  Map<String, IdempotencyRecord> getAllRecords() => Map.unmodifiable(_memoryCache);

  int get recordCount => _memoryCache.length;

  void clearCache() {
    _memoryCache.clear();
  }
}

class HashCollisionException implements Exception {
  final String hash1;
  final String hash2;
  final String message;

  HashCollisionException({
    required this.hash1,
    required this.hash2,
    required this.message,
  });

  @override
  String toString() => 'HashCollisionException: $message (hash1: $hash1, hash2: $hash2)';
}