class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;
  final StackTrace? stackTrace;
  final DateTime timestamp;

  AppException({
    required this.message,
    this.code,
    this.originalException,
    StackTrace? stackTrace,
    DateTime? timestamp,
  })  : timestamp = timestamp ?? DateTime.now(),
        stackTrace = stackTrace ?? StackTrace.current;

  @override
  String toString() => 'AppException: $message (code: $code)';
  
  Map<String, dynamic> toMap() {
    return {
      'type': runtimeType.toString(),
      'message': message,
      'code': code,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class ServerException extends AppException {
  final int? statusCode;
  final String? endpoint;
  
  ServerException({
    required super.message,
    super.code,
    super.originalException,
    super.stackTrace,
    super.timestamp,
    this.statusCode,
    this.endpoint,
  });

  @override
  String toString() => 'ServerException: $message (status: $statusCode, endpoint: $endpoint)';
  
  bool get isClientError => statusCode != null && statusCode! >= 400 && statusCode! < 500;
  bool get isServerError => statusCode != null && statusCode! >= 500;
  bool get isNotFound => statusCode == 404;
  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
}

class CacheException extends AppException {
  final String? cacheKey;
  final String operation;
  
  CacheException({
    required super.message,
    super.code,
    super.originalException,
    super.stackTrace,
    super.timestamp,
    this.cacheKey,
    this.operation = 'read',
  });

  @override
  String toString() => 'CacheException: $message (key: $cacheKey, operation: $operation)';
}

class NetworkException extends AppException {
  final String url;
  final bool isConnectionError;
  final bool isTimeout;
  final bool isSslError;
  
  NetworkException({
    required super.message,
    required this.url,
    super.code,
    super.originalException,
    super.stackTrace,
    super.timestamp,
    this.isConnectionError = false,
    this.isTimeout = false,
    this.isSslError = false,
  });

  @override
  String toString() => 'NetworkException: $message (url: $url, connection: $isConnectionError, timeout: $isTimeout)';
  
  String get userMessage {
    if (isConnectionError) {
      return 'No se pudo conectar al servidor. Verifique su conexión a internet.';
    }
    if (isTimeout) {
      return 'La solicitud tardó demasiado. Por favor, intente de nuevo.';
    }
    if (isSslError) {
      return 'Error de seguridad en la conexión. Por favor, contacte al administrador.';
    }
    return message;
  }
}

class DatabaseException extends AppException {
  final String? sql;
  final Map<String, dynamic>? queryParameters;
  
  DatabaseException({
    required super.message,
    super.code,
    super.originalException,
    super.stackTrace,
    super.timestamp,
    this.sql,
    this.queryParameters,
  });

  @override
  String toString() => 'DatabaseException: $message (sql: $sql)';
  
  bool get isConstraintViolation => code == 'constraint' || code == 'UNIQUE constraint failed';
  bool get isNotFound => code == 'NOT FOUND';
}

class ValidationException extends AppException {
  final Map<String, List<String>> fieldErrors;
  
  ValidationException({
    required super.message,
    super.code,
    super.originalException,
    super.stackTrace,
    super.timestamp,
    this.fieldErrors = const {},
  });

  @override
  String toString() => 'ValidationException: $message (fields: ${fieldErrors.keys.join(', ')})';
  
  String getFieldError(String fieldName) {
    return fieldErrors[fieldName]?.join(', ') ?? '';
  }
  
  bool hasFieldError(String fieldName) {
    return fieldErrors.containsKey(fieldName) && fieldErrors[fieldName]!.isNotEmpty;
  }
}

class SyncException extends AppException {
  final String? entityId;
  final String operation;
  final int retryCount;
  final DateTime? nextRetryAt;
  
  SyncException({
    required super.message,
    super.code,
    super.originalException,
    super.stackTrace,
    super.timestamp,
    this.entityId,
    this.operation = 'sync',
    this.retryCount = 0,
    this.nextRetryAt,
  });

  @override
  String toString() => 'SyncException: $message (entity: $entityId, operation: $operation, retry: $retryCount)';
  
  bool get canRetry => retryCount < 3;
  
  Duration? get timeUntilRetry {
    if (nextRetryAt == null) return null;
    return nextRetryAt!.difference(DateTime.now());
  }
}

class ConflictException extends AppException {
  final String entityId;
  final dynamic localData;
  final dynamic remoteData;
  final String conflictType;
  
  ConflictException({
    required super.message,
    required this.entityId,
    required this.localData,
    required this.remoteData,
    required this.conflictType,
    super.code,
    super.originalException,
    super.stackTrace,
    super.timestamp,
  });

  @override
  String toString() => 'ConflictException: $message (entity: $entityId, type: $conflictType)';
  
  Map<String, dynamic> getConflictDetails() {
    return {
      'entityId': entityId,
      'localData': localData,
      'remoteData': remoteData,
      'conflictType': conflictType,
    };
  }
}

class PermissionException extends AppException {
  final String permission;
  
  PermissionException({
    required super.message,
    required this.permission,
    super.code,
    super.originalException,
    super.stackTrace,
    super.timestamp,
  });

  @override
  String toString() => 'PermissionException: $message (permission: $permission)';
}