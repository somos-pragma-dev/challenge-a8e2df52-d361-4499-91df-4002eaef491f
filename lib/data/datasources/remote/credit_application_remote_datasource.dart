package lib.data.datasources.remote;

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../models/credit_application_model.dart';
import '../../../core/config/app_config.dart';
import '../../../core/error/failures.dart';
import '../../../core/network/connectivity_service.dart';

abstract class CreditApplicationRemoteDatasource {
  Future<Either<Failure, List<CreditApplicationModel>>> fetchAllApplications();
  Future<Either<Failure, CreditApplicationModel>> fetchApplicationById(String id);
  Future<Either<Failure, CreditApplicationModel>> fetchApplicationsByClientId(String clientId);
  Future<Either<Failure, CreditApplicationModel>> createApplication(CreditApplicationModel application);
  Future<Either<Failure, CreditApplicationModel>> updateApplication(CreditApplicationModel application);
  Future<Either<Failure, bool>> deleteApplication(String id);
  Future<Either<Failure, List<CreditApplicationModel>>> syncApplications(List<CreditApplicationModel> applications);
  Future<Either<Failure, Map<String, dynamic>>> resolveConflicts(
    String entityType,
    List<Map<String, dynamic>> conflicts,
  );
}

class CreditApplicationRemoteDatasourceImpl implements CreditApplicationRemoteDatasource {
  final Dio _dio;
  final AppConfig _appConfig;
  final ConnectivityService _connectivityService;

  CreditApplicationRemoteDatasourceImpl(
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
  Future<Either<Failure, List<CreditApplicationModel>>> fetchAllApplications() async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.get(_appConfig.creditApplicationsEndpoint);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        final applications = data.map((json) => CreditApplicationModel.fromJson(json)).toList();
        return Right(applications);
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al obtener solicitudes: $e'));
    }
  }

  @override
  Future<Either<Failure, CreditApplicationModel>> fetchApplicationById(String id) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.get('${_appConfig.creditApplicationsEndpoint}/$id');
      
      if (response.statusCode == 200) {
        final application = CreditApplicationModel.fromJson(response.data['data'] ?? response.data);
        return Right(application);
      } else if (response.statusCode == 404) {
        return const Left(DatabaseFailure.notFound());
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al obtener solicitud: $e'));
    }
  }

  @override
  Future<Either<Failure, CreditApplicationModel>> fetchApplicationsByClientId(String clientId) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.get(
        _appConfig.creditApplicationsEndpoint,
        queryParameters: {'clientId': clientId},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        if (data.isEmpty) {
          return const Left(DatabaseFailure.notFound());
        }
        final application = CreditApplicationModel.fromJson(data.first);
        return Right(application);
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al obtener solicitudes del cliente: $e'));
    }
  }

  @override
  Future<Either<Failure, CreditApplicationModel>> createApplication(CreditApplicationModel application) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.post(
        _appConfig.creditApplicationsEndpoint,
        data: application.toJson(),
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final createdApplication = CreditApplicationModel.fromJson(response.data['data'] ?? response.data);
        return Right(createdApplication);
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al crear solicitud: $e'));
    }
  }

  @override
  Future<Either<Failure, CreditApplicationModel>> updateApplication(CreditApplicationModel application) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.put(
        '${_appConfig.creditApplicationsEndpoint}/${application.id}',
        data: application.toJson(),
      );
      
      if (response.statusCode == 200) {
        final updatedApplication = CreditApplicationModel.fromJson(response.data['data'] ?? response.data);
        return Right(updatedApplication);
      } else if (response.statusCode == 404) {
        return const Left(DatabaseFailure.notFound());
      } else {
        return Left(NetworkFailure.serverError(response.statusCode));
      }
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al actualizar solicitud: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteApplication(String id) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final response = await _dio.delete('${_appConfig.creditApplicationsEndpoint}/$id');
      
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
      return Left(NetworkFailure.unknown('Error al eliminar solicitud: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CreditApplicationModel>>> syncApplications(
    List<CreditApplicationModel> applications,
  ) async {
    try {
      final connectivity = await _connectivityService.hasActiveConnection();
      if (!connectivity) {
        return Left(NetworkFailure.noConnection());
      }

      final batchSize = _appConfig.maxBatchSize;
      final List<CreditApplicationModel> syncedApplications = [];

      for (var i = 0; i < applications.length; i += batchSize) {
        final batch = applications.skip(i).take(batchSize).toList();
        final payload = batch.map((a) => a.toJson()).toList();

        final response = await _dio.post(
          _appConfig.syncEndpoint,
          data: {'creditApplications': payload},
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = 
            response.data['data'] ?? 
            response.data['creditApplications'] ?? 
            [];
          syncedApplications.addAll(
            data.map((json) => CreditApplicationModel.fromJson(json)),
          );
        } else if (response.statusCode == 409) {
          return Left(SyncFailure.conflictDetected('credit_application', batch.first.id));
        } else {
          return Left(NetworkFailure.serverError(response.statusCode));
        }
      }

      return Right(syncedApplications);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        return Left(SyncFailure.conflictDetected('credit_application', ''));
      }
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(NetworkFailure.unknown('Error al sincronizar solicitudes: $e'));
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