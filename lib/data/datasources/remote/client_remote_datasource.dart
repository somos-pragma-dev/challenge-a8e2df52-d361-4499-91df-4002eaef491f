package lib.data.datasources.remote;

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../models/client_model.dart';
import '../../../core/config/app_config.dart';
import '../../../core/error/failures.dart';
import '../../../core/network/connectivity_service.dart';

abstract class ClientRemoteDatasource {
  Future<Either<Failure, List<ClientModel>>> fetchAllClients();
  Future<Either<Failure, ClientModel>> fetchClientById(String id);
  Future<Either<Failure, ClientModel>> createClient(ClientModel client);
  Future<Either<Failure, ClientModel>> updateClient(ClientModel client);
  Future<Either<Failure, bool>> deleteClient(String id);
  Future<Either<Failure, List<ClientModel>>> syncClients(List<ClientModel> clients);
  Future<Either<Failure, Map<String, dynamic>>> resolveConflicts(
    String entityType,
    List<Map<String, dynamic>> conflicts,
  );
}

class ClientRemoteDatasourceImpl implements ClientRemoteDatasource {
  final Dio _dio;
  final AppConfig _appConfig;
  final ConnectivityService _connectivityService;

  ClientRemoteDatasourceImpl(
    this._dio,
    this._appConfig,
    this._connectivityService,
  ) {
    _configureDio();
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: _appConfig.baseUrl,
      connectTimeout: _appConfig.connectionTimeout,
      receiveTimeout: _appConfig.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (_appConfig.enableLogging) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    }
  }

  @override
  Future<Either<Failure, List<ClientModel>>> fetchAllClients() async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.get(_appConfig.clientsEndpoint);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        final clients = data.map((json) => ClientModel.fromJson(json)).toList();
        return Right(clients);
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al obtener clientes: $e'));
    }
  }

  @override
  Future<Either<Failure, ClientModel>> fetchClientById(String id) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.get('${_appConfig.clientsEndpoint}/$id');
      
      if (response.statusCode == 200) {
        final client = ClientModel.fromJson(response.data['data'] ?? response.data);
        return Right(client);
      } else if (response.statusCode == 404) {
        return const Left(DatabaseFailure.notFound());
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al obtener cliente: $e'));
    }
  }

  @override
  Future<Either<Failure, ClientModel>> createClient(ClientModel client) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.post(
        _appConfig.clientsEndpoint,
        data: client.toJson(),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final createdClient = ClientModel.fromJson(response.data['data'] ?? response.data);
        return Right(createdClient);
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al crear cliente: $e'));
    }
  }

  @override
  Future<Either<Failure, ClientModel>> updateClient(ClientModel client) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.put(
        '${_appConfig.clientsEndpoint}/${client.id}',
        data: client.toJson(),
      );
      
      if (response.statusCode == 200) {
        final updatedClient = ClientModel.fromJson(response.data['data'] ?? response.data);
        return Right(updatedClient);
      } else if (response.statusCode == 404) {
        return const Left(DatabaseFailure.notFound());
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al actualizar cliente: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteClient(String id) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.delete('${_appConfig.clientsEndpoint}/$id');
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        return const Right(true);
      } else if (response.statusCode == 404) {
        return const Left(DatabaseFailure.notFound());
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al eliminar cliente: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ClientModel>>> syncClients(List<ClientModel> clients) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final batchSize = _appConfig.maxBatchSize;
      final List<ClientModel> syncedClients = [];

      for (var i = 0; i < clients.length; i += batchSize) {
        final batch = clients.skip(i).take(batchSize).toList();
        final payload = batch.map((c) => c.toJson()).toList();

        final response = await _dio.post(
          _appConfig.syncEndpoint,
          data: {'clients': payload},
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = response.data['data'] ?? response.data['clients'] ?? [];
          syncedClients.addAll(data.map((json) => ClientModel.fromJson(json)));
        } else if (response.statusCode == 409) {
          return Left(SyncFailure.conflictDetected('client', batch.first.id));
        } else {
          return Left(NetworkFailure.serverError(response.statusCode));
        }
      }

      return Right(syncedClients);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        return Left(SyncFailure.conflictDetected('client', ''));
      }
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al sincronizar clientes: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> resolveConflicts(
    String entityType,
    List<Map<String, dynamic>> conflicts,
  ) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.post(
        _appConfig.conflictResolutionEndpoint,
        data: {
          'entityType': entityType,
          'conflicts': conflicts,
        },
      );

      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al resolver conflictos: $e'));
    }
  }

  Failure _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure.timeout();
      case DioExceptionType.connectionError:
        return NetworkFailure.noConnection();
      case DioExceptionType.badResponse:
        return NetworkFailure.serverError(e.response?.statusCode);
      default:
        return NetworkFailure.unknown(e.message);
    }
  }
}