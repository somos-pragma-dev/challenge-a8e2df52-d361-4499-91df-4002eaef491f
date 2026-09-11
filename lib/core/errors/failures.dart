import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final Map<String, dynamic>? metadata;
  
  const Failure({
    required this.message,
    this.code,
    this.metadata,
  });
  
  @override
  List<Object?> get props => [message, code, metadata];
}

class OfflineFailure extends Failure {
  const OfflineFailure({
    super.message = 'No hay conexión a internet disponible',
    super.code = 'OFFLINE_001',
    super.metadata,
  });
  
  factory OfflineFailure.database(String details) {
    return OfflineFailure(
      message: 'Error de base de datos: $details',
      code: 'OFFLINE_DB_001',
      metadata: {'details': details},
    );
  }
  
  factory OfflineFailure.networkUnavailable() {
    return const OfflineFailure(
      message: 'La red no está disponible. Por favor, verifique su conexión.',
      code: 'OFFLINE_NET_001',
    );
  }
}

class SyncFailure extends Failure {
  const SyncFailure({
    super.message = 'Error durante la sincronización de datos',
    super.code = 'SYNC_001',
    super.metadata,
  });
  
  factory SyncFailure.timeout() {
    return const SyncFailure(
      message: 'Tiempo de espera agotado durante la sincronización',
      code: 'SYNC_TIMEOUT_001',
    );
  }
  
  factory SyncFailure.serverError(String details) {
    return SyncFailure(
      message: 'Error del servidor: $details',
      code: 'SYNC_SERVER_001',
      metadata: {'server_details': details},
    );
  }
  
  factory SyncFailure.unauthorized() {
    return const SyncFailure(
      message: 'No autorizado para sincronizar. Inicie sesión novamente.',
      code: 'SYNC_AUTH_001',
    );
  }
  
  factory SyncFailure.batchFailed(int failedCount, int totalCount) {
    return SyncFailure(
      message: 'Sincronización parcial: $failedCount de $totalCount elementos fallaron',
      code: 'SYNC_BATCH_001',
      metadata: {'failed': failedCount, 'total': totalCount},
    );
  }
}

class ConflictFailure extends Failure {
  final String entityId;
  final String localVersion;
  final String serverVersion;
  
  const ConflictFailure({
    required this.message,
    required this.code,
    required this.entityId,
    required this.localVersion,
    required this.serverVersion,
    super.metadata,
  });
  
  factory ConflictFailure.detected(String entityId, Map<String, dynamic> localData, Map<String, dynamic> serverData) {
    return ConflictFailure(
      message: 'Conflicto detectado en la entidad $entityId',
      code: 'CONFLICT_001',
      entityId: entityId,
      localVersion: localData['version']?.toString() ?? 'unknown',
      serverVersion: serverData['version']?.toString() ?? 'unknown',
      metadata: {
        'local_data': localData,
        'server_data': serverData,
      },
    );
  }
  
  factory ConflictFailure.unresolved(String entityId) {
    return ConflictFailure(
      message: 'Conflicto no resuelto para la entidad $entityId',
      code: 'CONFLICT_UNRESOLVED_001',
      entityId: entityId,
      localVersion: 'unknown',
      serverVersion: 'unknown',
    );
  }
  
  @override
  List<Object?> get props => [...super.props, entityId, localVersion, serverVersion];
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({
    super.message = 'Error de base de datos local',
    super.code = 'DB_001',
    super.metadata,
  });
  
  factory DatabaseFailure.notFound(String table, String id) {
    return DatabaseFailure(
      message: 'Registro no encontrado en $table: $id',
      code: 'DB_NOT_FOUND_001',
      metadata: {'table': table, 'id': id},
    );
  }
  
  factory DatabaseFailure.constraintViolation(String details) {
    return DatabaseFailure(
      message: 'Violación de restricción: $details',
      code: 'DB_CONSTRAINT_001',
      metadata: {'details': details},
    );
  }
  
  factory DatabaseFailure.transactionFailed(String details) {
    return DatabaseFailure(
      message: 'Transacción fallida: $details',
      code: 'DB_TRANSACTION_001',
      metadata: {'details': details},
    );
  }
}

class ValidationFailure extends Failure {
  final Map<String, List<String>> fieldErrors;
  
  const ValidationFailure({
    required super.message,
    required this.code,
    required this.fieldErrors,
    super.metadata,
  });
  
  factory ValidationFailure.invalidAmount(String currency, double amount) {
    return ValidationFailure(
      message: 'Monto inválido para la moneda $currency',
      code: 'VALIDATION_AMOUNT_001',
      fieldErrors: {
        'amount': ['El monto debe ser mayor a 0 y menor al máximo permitido para $currency'],
      },
      metadata: {'currency': currency, 'amount': amount},
    );
  }
  
  factory ValidationFailure.requiredFields(List<String> fields) {
    return ValidationFailure(
      message: 'Campos requeridos faltantes: ${fields.join(', ')}',
      code: 'VALIDATION_REQUIRED_001',
      fieldErrors: {
        for (final field in fields) field: ['Este campo es requerido'],
      },
    );
  }
  
  @override
  List<Object?> get props => [...super.props, fieldErrors];
}