package field_app.data.datasources.remote;

import 'package:dio/dio.dart';
import 'package:field_app/data/models/task_model.dart';
import 'package:field_app/core/errors/exceptions.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> getTaskById(String id);
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<List<TaskModel>> syncTasks(List<TaskModel> tasks);
  Future<List<TaskModel>> getTasksSince(DateTime? since);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final Dio _dio;

  TaskRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await _dio.get('/tasks');
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => TaskModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e, '/tasks');
    }
  }

  @override
  Future<TaskModel> getTaskById(String id) async {
    try {
      final response = await _dio.get('/tasks/$id');
      final data = response.data['data'] ?? response.data;
      return TaskModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e, '/tasks/$id');
    }
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    try {
      final response = await _dio.post('/tasks', data: task.toJson());
      final data = response.data['data'] ?? response.data;
      return TaskModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e, '/tasks');
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      final response = await _dio.put('/tasks/${task.id}', data: task.toJson());
      final data = response.data['data'] ?? response.data;
      return TaskModel.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e, '/tasks/${task.id}');
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      await _dio.delete('/tasks/$id');
    } on DioException catch (e) {
      throw _handleDioError(e, '/tasks/$id');
    }
  }

  @override
  Future<List<TaskModel>> syncTasks(List<TaskModel> tasks) async {
    try {
      final response = await _dio.post(
        '/tasks/sync',
        data: {'tasks': tasks.map((t) => t.toJson()).toList()},
      );
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => TaskModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e, '/tasks/sync');
    }
  }

  @override
  Future<List<TaskModel>> getTasksSince(DateTime? since) async {
    try {
      final queryParams = <String, dynamic>{};
      if (since != null) {
        queryParams['since'] = since.toIso8601String();
      }
      final response = await _dio.get('/tasks', queryParameters: queryParams);
      final List<dynamic> data = response.data['data'] ?? response.data;
      return data.map((json) => TaskModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e, '/tasks');
    }
  }

  AppException _handleDioError(DioException e, String endpoint) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Timeout connecting to server',
          url: endpoint,
          isConnectionError: false,
          isTimeout: true,
          isSslError: false,
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'No internet connection',
          url: endpoint,
          isConnectionError: true,
          isTimeout: false,
          isSslError: false,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Server error';
        return ServerException(
          message: message,
          statusCode: statusCode,
          endpoint: endpoint,
        );
      default:
        return NetworkException(
          message: e.message ?? 'Unknown error',
          url: endpoint,
          isConnectionError: false,
          isTimeout: false,
          isSslError: false,
        );
    }
  }
}