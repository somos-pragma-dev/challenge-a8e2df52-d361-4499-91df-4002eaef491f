import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;

  const Failure({
    required this.message,
    this.code,
    this.metadata,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? const _DefaultTimestamp();

  @override
  List<Object?> get props => [message, code, metadata, timestamp];

  String get failureType => runtimeType.toString();
  
  String get userFriendlyMessage => message;
  
  bool get isRecoverable => this is CacheFailure || this is NetworkFailure;
  
  Map<String, dynamic> toMap() {
    return {
      'type': failureType,
      'message': message,
      'code': code,
      'metadata': metadata,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class _DefaultTimestamp implements DateTime {
  const _DefaultTimestamp();

  DateTime get _now => DateTime.now();
  
  @override
  int get year => _now.year;
  
  @override
  int get month => _now.month;
  
  @override
  int get day => _now.day;
  
  @override
  int get hour => _now.hour;
  
  @override
  int get minute => _now.minute;
  
  @override
  int get second => _now.second;
  
  @override
  int get millisecond => _now.millisecond;
  
  @override
  int get microsecond => _now.microsecond;
  
  @override
  int get weekday => _now.weekday;
  
  @override
  bool get isUtc => _now.isUtc;
  
  @override
  String get timeZoneName => _now.timeZoneName;
  
  @override
  Duration get timeZoneOffset => _now.timeZoneOffset;
  
  @override
  int get millisecondsSinceEpoch => _now.millisecondsSinceEpoch;
  
  @override
  int get microsecondsSinceEpoch => _now.microsecondsSinceEpoch;
  
  @override
  DateTime add(Duration duration) => _now.add(duration);
  
  @override
  DateTime subtract(Duration duration) => _now.subtract(duration);
  
  @override
  Duration difference(DateTime other) => _now.difference(other);
  
  @override
  bool isAfter(DateTime other) => _now.isAfter(other);
  
  @override
  bool isBefore(DateTime other) => _now.isBefore(other);
  
  @override
  bool isAtSameMomentAs(DateTime other) => _now.isAtSameMomentAs(other);
  
  @override
  int compareTo(DateTime other) => _now.compareTo(other);
  
  @override
  String toIso8601String() => _now.toIso8601String();
  
  @override
  DateTime toLocal() => _now.toLocal();
  
  @override
  DateTime toUtc() => _now.toUtc();
  
  @override
  String toString() => _now.toString();
}

class ServerFailure extends Failure {
  final int? statusCode;
  
  const ServerFailure({
    required super.message,
    super.code,
    super.metadata,
    super.timestamp,
    this.statusCode,
  });

  @override
  List<Object?> get props => [...super.props, statusCode];
  
  @override
  bool get isRecoverable => statusCode != null && 
      statusCode! >= 500 && statusCode! < 600;
}

class CacheFailure extends Failure {
  final String? cacheKey;
  
  const CacheFailure({
    required super.message,
    super.code,
    super.metadata,
    super.timestamp,
    this.cacheKey,
  });

  @override
  List<Object?> get props => [...super.props, cacheKey];
}

class NetworkFailure extends Failure {
  final bool isConnectionError;
  final bool isTimeout;
  
  const NetworkFailure({
    required super.message,
    super.code,
    super.metadata,
    super.timestamp,
    this.isConnectionError = false,
    this.isTimeout = false,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    isConnectionError,
    isTimeout,
  ];
  
  @override
  String get userFriendlyMessage {
    if (isConnectionError) {
      return 'No hay conexión a internet. Los datos se guardarán localmente.';
    }
    if (isTimeout) {
      return 'La conexión tardó demasiado. Por favor, intente más tarde.';
    }
    return message;
  }
}

class ValidationFailure extends Failure {
  final Map<String, List<String>> fieldErrors;
  
  const ValidationFailure({
    required super.message,
    super.code,
    super.metadata,
    super.timestamp,
    this.fieldErrors = const {},
  });

  @override
  List<Object?> get props => [...super.props, fieldErrors];
  
  String getFieldError(String fieldName) {
    return fieldErrors[fieldName]?.join(', ') ?? '';
  }
}

class SyncFailure extends Failure {
  final String? entityId;
  final String? operation;
  final int retryCount;
  
  const SyncFailure({
    required super.message,
    super.code,
    super.metadata,
    super.timestamp,
    this.entityId,
    this.operation,
    this.retryCount = 0,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    entityId,
    operation,
    retryCount,
  ];
  
  @override
  bool get isRecoverable => retryCount < 3;
}

class ConflictFailure extends Failure {
  final String entityId;
  final dynamic localVersion;
  final dynamic remoteVersion;
  final String conflictType;
  
  const ConflictFailure({
    required super.message,
    required this.entityId,
    required this.localVersion,
    required this.remoteVersion,
    required this.conflictType,
    super.code,
    super.metadata,
    super.timestamp,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    entityId,
    localVersion,
    remoteVersion,
    conflictType,
  ];
  
  @override
  String get userFriendlyMessage {
    return 'Conflicto detectado en los datos. Por favor, revise las diferencias.';
  }
}

class PermissionFailure extends Failure {
  final String permission;
  
  const PermissionFailure({
    required super.message,
    required this.permission,
    super.code,
    super.metadata,
    super.timestamp,
  });

  @override
  List<Object?> get props => [...super.props, permission];
}