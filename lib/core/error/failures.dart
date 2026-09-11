import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;
  final dynamic originalError;

  const Failure({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  List<Object?> get props => [message, code, originalError];
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.originalError,
  });

  factory NetworkFailure.noConnection() => const NetworkFailure(
        message: 'No hay conexión a internet disponible',
        code: 1001,
      );

  factory NetworkFailure.timeout() => const NetworkFailure(
        message: 'La solicitud ha excedido el tiempo de espera',
        code: 1002,
      );

  factory NetworkFailure.serverError(int? statusCode) => NetworkFailure(
        message: 'Error del servidor: ${statusCode ?? 'desconocido'}',
        code: statusCode ?? 500,
      );

  factory NetworkFailure.unknown([String? details]) => NetworkFailure(
        message: details ?? 'Error de red desconocido',
        code: 1000,
      );
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required super.message,
    super.code,
    super.originalError,
  });

  factory DatabaseFailure.insertError() => const DatabaseFailure(
        message: 'Error al insertar datos en la base de datos local',
        code: 2001,
      );

  factory DatabaseFailure.updateError() => const DatabaseFailure(
        message: 'Error al actualizar datos en la base de datos local',
        code: 2002,
      );

  factory DatabaseFailure.deleteError() => const DatabaseFailure(
        message: 'Error al eliminar datos de la base de datos local',
        code: 2003,
      );

  factory DatabaseFailure.queryError() => const DatabaseFailure(
        message: 'Error al consultar la base de datos local',
        code: 2004,
      );

  factory DatabaseFailure.unknown([String? details]) => DatabaseFailure(
        message: details ?? 'Error de base de datos desconocido',
        code: 2000,
      );
}

class SyncFailure extends Failure {
  final String? entityType;
  final String? entityId;

  const SyncFailure({
    required super.message,
    super.code,
    super.originalError,
    this.entityType,
    this.entityId,
  });

  factory SyncFailure.pendingChanges() => const SyncFailure(
        message: 'Hay cambios pendientes por sincronizar',
        code: 3001,
      );

  factory SyncFailure.conflictDetected(String entityType, String entityId) => SyncFailure(
        message: 'Conflicto detectado en $entityType con ID $entityId',
        code: 3002,
        entityType: entityType,
        entityId: entityId,
      );

  factory SyncFailure.uploadFailed(String entityType, String entityId) => SyncFailure(
        message: 'Error al subir $entityType con ID $entityId al servidor',
        code: 3003,
        entityType: entityType,
        entityId: entityId,
      );

  factory SyncFailure.downloadFailed() => const SyncFailure(
        message: 'Error al descargar datos del servidor',
        code: 3004,
      );

  factory SyncFailure.resolveFailed() => const SyncFailure(
        message: 'Error al resolver conflictos de sincronización',
        code: 3005,
      );

  factory SyncFailure.unknown([String? details]) => SyncFailure(
        message: details ?? 'Error de sincronización desconocido',
        code: 3000,
      );
}

class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    required super.message,
    super.code,
    super.originalError,
    this.fieldErrors,
  });

  factory ValidationFailure.required(String fieldName) => ValidationFailure(
        message: 'El campo $fieldName es requerido',
        code: 4001,
        fieldErrors: {fieldName: 'required'},
      );

  factory ValidationFailure.invalidFormat(String fieldName, String expected) => ValidationFailure(
        message: 'El campo $fieldName tiene formato inválido. Se espera: $expected',
        code: 4002,
        fieldErrors: {fieldName: 'invalid_format'},
      );

  factory ValidationFailure.invalidValue(String fieldName, String reason) => ValidationFailure(
        message: 'El campo $fieldName tiene valor inválido: $reason',
        code: 4003,
        fieldErrors: {fieldName: 'invalid_value'},
      );

  @override
  List<Object?> get props => [...super.props, fieldErrors];
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
    super.originalError,
  });

  factory CacheFailure.notFound() => const CacheFailure(
        message: 'Datos no encontrados en caché',
        code: 5001,
      );

  factory CacheFailure.expired() => const CacheFailure(
        message: 'Los datos en caché han expirado',
        code: 5002,
      );

  factory CacheFailure.writeError() => const CacheFailure(
        message: 'Error al escribir en caché',
        code: 5003,
      );

  factory CacheFailure.unknown([String? details]) => CacheFailure(
        message: details ?? 'Error de caché desconocido',
        code: 5000,
      );
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
    super.originalError,
  });

  factory UnknownFailure.fromException(dynamic error) => UnknownFailure(
        message: 'Error inesperado: ${error.toString()}',
        code: 9999,
        originalError: error,
      );
}