import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/transaction.dart';
import '../models/transaction_model.dart';

class TransactionRemoteDatasource {
  final Dio _dio;
  final NetworkInfo _networkInfo;

  TransactionRemoteDatasource({
    required Dio dio,
    required NetworkInfo networkInfo,
  })  : _dio = dio,
        _networkInfo = networkInfo;

  Future<bool> get isConnected => _networkInfo.isConnected;

  Future<TransactionModel> createTransaction(TransactionModel model) async {
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        throw const OfflineException.noConnectivity();
      }

      final response = await _dio.post(
        AppConstants.getApiUrl('/transactions'),
        data: model.toServerMap(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TransactionModel.fromServerMap(response.data);
      }

      throw NetworkException.serverError(
        response.statusCode ?? 500,
        'Failed to create transaction on server',
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<TransactionModel?> getTransactionById(String externalId) async {
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        throw const OfflineException.noConnectivity();
      }

      final response = await _dio.get(
        AppConstants.getApiUrl('/transactions/$externalId'),
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        ),
      );

      if (response.statusCode == 200) {
        return TransactionModel.fromServerMap(response.data);
      } else if (response.statusCode == 404) {
        return null;
      }

      throw NetworkException.serverError(
        response.statusCode ?? 500,
        'Failed to get transaction from server',
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<TransactionModel>> getAllTransactions({
    int page = 1,
    int pageSize = AppConstants.defaultPageSize,
  }) async {
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        throw const OfflineException.noConnectivity();
      }

      final response = await _dio.get(
        AppConstants.getApiUrl('/transactions'),
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['items'] ?? response.data;
        return data.map((json) => TransactionModel.fromServerMap(json)).toList();
      }

      throw NetworkException.serverError(
        response.statusCode ?? 500,
        'Failed to get transactions from server',
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<TransactionModel> updateTransaction(TransactionModel model) async {
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        throw const OfflineException.noConnectivity();
      }

      final response = await _dio.put(
        AppConstants.getApiUrl('/transactions/${model.externalId ?? model.id}'),
        data: model.toServerMap(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'If-Match': model.version.toString(),
          },
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        ),
      );

      if (response.statusCode == 200) {
        return TransactionModel.fromServerMap(response.data);
      } else if (response.statusCode == 409) {
        throw SyncConflictException.detected(
          entityId: model.id,
          localData: model.toMap(),
          serverData: response.data,
          conflictStrategy: AppConstants.conflictStrategyLastWriteWins,
        );
      }

      throw NetworkException.serverError(
        response.statusCode ?? 500,
        'Failed to update transaction on server',
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> deleteTransaction(String externalId) async {
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        throw const OfflineException.noConnectivity();
      }

      final response = await _dio.delete(
        AppConstants.getApiUrl('/transactions/$externalId'),
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw NetworkException.serverError(
          response.statusCode ?? 500,
          'Failed to delete transaction on server',
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<TransactionModel>> syncBatch(
    List<TransactionModel> models,
  ) async {
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        throw const OfflineException.noConnectivity();
      }

      final response = await _dio.post(
        AppConstants.getApiUrl('/transactions/batch'),
        data: {
          'operations': models.map((m) => m.toServerMap()).toList(),
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeout * 2),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout * 2),
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'] ?? [];
        return data.map((json) => TransactionModel.fromServerMap(json)).toList();
      }

      throw NetworkException.serverError(
        response.statusCode ?? 500,
        'Failed to sync batch to server',
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> checkServerVersion() async {
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        throw const OfflineException.noConnectivity();
      }

      final response = await _dio.get(
        AppConstants.getApiUrl('/version'),
        options: Options(
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
        ),
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }

      throw NetworkException.serverError(
        response.statusCode ?? 500,
        'Failed to check server version',
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  AppException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException.timeout();
      case DioExceptionType.connectionError:
        return const OfflineException.noConnectivity();
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 500;
        if (statusCode == 401) {
          return NetworkException.unauthorized();
        } else if (statusCode == 404) {
          return NetworkException.notFound(e.requestOptions.uri.toString());
        }
        return NetworkException.serverError(
          statusCode,
          e.response?.data?['message'] ?? 'Unknown server error',
        );
      case DioExceptionType.cancel:
        return const AppException(message: 'Request cancelled', code: 'CANCELLED');
      default:
        return AppException(
          message: e.message ?? 'Unknown network error',
          code: 'NETWORK_ERROR',
          originalError: e,
        );
    }
  }
}