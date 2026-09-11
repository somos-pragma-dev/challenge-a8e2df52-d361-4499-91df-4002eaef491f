import 'package:equatable/equatable.dart';

class AppConfig extends Equatable {
  final String baseUrl;
  final int syncIntervalMinutes;
  final int maxRetryAttempts;
  final int retryDelaySeconds;
  final int connectionTimeoutMs;
  final int receiveTimeoutMs;
  final bool enableLogging;
  final int maxBatchSize;
  final int conflictResolutionBatchSize;

  const AppConfig({
    this.baseUrl = 'https://api.creditofield.example.com/v1',
    this.syncIntervalMinutes = 15,
    this.maxRetryAttempts = 3,
    this.retryDelaySeconds = 5,
    this.connectionTimeoutMs = 30000,
    this.receiveTimeoutMs = 30000,
    this.enableLogging = true,
    this.maxBatchSize = 100,
    this.conflictResolutionBatchSize = 50,
  });

  String get clientsEndpoint => '$baseUrl/clients';
  String get creditApplicationsEndpoint => '$baseUrl/credit-applications';
  String get syncEndpoint => '$baseUrl/sync';
  String get conflictResolutionEndpoint => '$baseUrl/sync/conflicts';

  Duration get syncInterval => Duration(minutes: syncIntervalMinutes);
  Duration get retryDelay => Duration(seconds: retryDelaySeconds);
  Duration get connectionTimeout => Duration(milliseconds: connectionTimeoutMs);
  Duration get receiveTimeout => Duration(milliseconds: receiveTimeoutMs);

  AppConfig copyWith({
    String? baseUrl,
    int? syncIntervalMinutes,
    int? maxRetryAttempts,
    int? retryDelaySeconds,
    int? connectionTimeoutMs,
    int? receiveTimeoutMs,
    bool? enableLogging,
    int? maxBatchSize,
    int? conflictResolutionBatchSize,
  }) {
    return AppConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      syncIntervalMinutes: syncIntervalMinutes ?? this.syncIntervalMinutes,
      maxRetryAttempts: maxRetryAttempts ?? this.maxRetryAttempts,
      retryDelaySeconds: retryDelaySeconds ?? this.retryDelaySeconds,
      connectionTimeoutMs: connectionTimeoutMs ?? this.connectionTimeoutMs,
      receiveTimeoutMs: receiveTimeoutMs ?? this.receiveTimeoutMs,
      enableLogging: enableLogging ?? this.enableLogging,
      maxBatchSize: maxBatchSize ?? this.maxBatchSize,
      conflictResolutionBatchSize: conflictResolutionBatchSize ?? this.conflictResolutionBatchSize,
    );
  }

  @override
  List<Object?> get props => [
        baseUrl,
        syncIntervalMinutes,
        maxRetryAttempts,
        retryDelaySeconds,
        connectionTimeoutMs,
        receiveTimeoutMs,
        enableLogging,
        maxBatchSize,
        conflictResolutionBatchSize,
      ];
}