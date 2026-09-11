class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  
  const AppException({
    required this.message,
    this.code,
    this.originalError,
  });
  
  @override
  String toString() => 'AppException: $message (code: $code)';
}

class OfflineException extends AppException {
  const OfflineException({
    super.message = 'Operación no disponible sin conexión',
    super.code = 'OFFLINE_EX_001',
    super.originalError,
  });
  
  factory OfflineException.noConnectivity() {
    return const OfflineException(
      message: 'No hay conexión a internet. La operación se guardará localmente.',
      code: 'OFFLINE_EX_CONNECTIVITY_001',
    );
  }
  
  factory OfflineException.database(String operation) {
    return OfflineException(
      message: 'Error de base de datos: $operation',
      code: 'OFFLINE_EX_DB_001',
    );
  }
}

class SyncConflictException extends AppException {
  final String entityId;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> serverData;
  final String conflictStrategy;
  
  const SyncConflictException({
    required super.message,
    required this.code,
    required this.entityId,
    required this.localData,
    required this.serverData,
    required this.conflictStrategy,
    super.originalError,
  });
  
  factory SyncConflictException.detected({
    required String entityId,
    required Map<String, dynamic> localData,
    required Map<String, dynamic> serverData,
  }) {
    return SyncConflictException(
      message: 'Conflicto detectado al sincronizar $entityId',
      code: 'SYNC_CONFLICT_EX_001',
      entityId: entityId,
      localData: localData,
      serverData: serverData,
      conflictStrategy: 'pending',
    );
  }
  
  factory SyncConflictException.unresolved({
    required String entityId,
    required Map<String, dynamic> localData,
    required Map<String, dynamic> serverData,
  }) {
    return SyncConflictException(
      message: 'Conflicto no resuelto para $entityId. Requiere intervención manual.',
      code: 'SYNC_CONFLICT_EX_UNRESOLVED_001',
      entityId: entityId,
      localData: localData,
      serverData: serverData,
      conflictStrategy: 'manual_required',
    );
  }
  
  Map<String, dynamic> toConflictData() {
    return {
      'entity_id': entityId,
      'local_data': localData,
      'server_data': serverData,
      'strategy': conflictStrategy,
      'detected_at': DateTime.now().toIso8601String(),
    };
  }
}

class IdempotencyException extends AppException {
  final String operationHash;
  final String? existingRecordId;
  
  const IdempotencyException({
    required super.message,
    required this.code,
    required this.operationHash,
    this.existingRecordId,
    super.originalError,
  });
  
  factory IdempotencyException.duplicateOperation({
    required String operationHash,
    required String existingId,
  }) {
    return IdempotencyException(
      message: 'Operación duplicada detectada. El registro existente es: $existingId',
      code: 'IDEMPOTENCY_EX_DUPLICATE_001',
      operationHash: operationHash,
      existingRecordId: existingId,
    );
  }
  
  factory IdempotencyException.hashMismatch({
    required String operationHash,
    required String expectedHash,
  }) {
    return IdempotencyException(
      message: 'El hash de operación no coincide. Expected: $expectedHash, Got: $operationHash',
      code: 'IDEMPOTENCY_EX_HASH_001',
      operationHash: operationHash,
    );
  }
}

class ValidationException extends AppException {
  final Map<String, List<String>> fieldErrors;
  
  const ValidationException({
    required super.message,
    required super.code,
    required this.fieldErrors,
    super.originalError,
  });
  
  factory ValidationException.invalidAmount({
    required String currency,
    required double amount,
    required double maxAmount,
  }) {
    return ValidationException(
      message: 'Monto $amount $currency excede el máximo permitido: $maxAmount',
      code: 'VALIDATION_EX_AMOUNT_001',
      fieldErrors: {
        'amount': ['El monto debe estar entre 0 y $maxAmount para $currency'],
      },
    );
  }
  
  factory ValidationException.invalidType({
    required String type,
    required List<String> validTypes,
  }) {
    return ValidationException(
      message: 'Tipo de transacción inválido: $type. Tipos válidos: ${validTypes.join(', ')}',
      code: 'VALIDATION_EX_TYPE_001',
      fieldErrors: {
        'transaction_type': ['Debe ser uno de: ${validTypes.join(', ')}'],
      },
    );
  }
}

class NetworkException extends AppException {
  final int? statusCode;
  
  const NetworkException({
    required super.message,
    required super.code,
    this.statusCode,
    super.originalError,
  });
  
  factory NetworkException.timeout() {
    return const NetworkException(
      message: 'Tiempo de espera agotado',
      code: 'NETWORK_EX_TIMEOUT_001',
      statusCode: 408,
    );
  }
  
  factory NetworkException.serverError(int code, String details) {
    return NetworkException(
      message: 'Error del servidor: $details',
      code: 'NETWORK_EX_SERVER_001',
      statusCode: code,
    );
  }
  
  factory NetworkException.unauthorized() {
    return const NetworkException(
      message: 'No autorizado. Por favor, inicie sesión nuevamente.',
      code: 'NETWORK_EX_AUTH_001',
      statusCode: 401,
    );
  }
  
  factory NetworkException.notFound(String endpoint) {
    return NetworkException(
      message: 'Recurso no encontrado: $endpoint',
      code: 'NETWORK_EX_NOT_FOUND_001',
      statusCode: 404,
    );
  }
}