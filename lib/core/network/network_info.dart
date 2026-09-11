import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:offline_field_app/core/errors/exceptions.dart';

enum NetworkStatus {
  online,
  offline,
  unknown,
}

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<NetworkStatus> get onConnectivityChanged;
  Future<void> checkConnectivity();
}

abstract class ConnectivityService {
  Future<bool> get isConnected;
  Stream<List<ConnectivityResult>> get onConnectivityChanged;
  Future<List<ConnectivityResult>> checkConnectivity();
}

class NetworkInfoImpl implements NetworkInfo {
  final ConnectivityService _connectivityService;
  final StreamController<NetworkStatus> _connectivityController = StreamController<NetworkStatus>.broadcast();
  
  NetworkInfoImpl({ConnectivityService? connectivityService})
      : _connectivityService = connectivityService ?? GetIt.instance<ConnectivityService>();
  
  @override
  Future<bool> get isConnected async {
    try {
      final result = await _connectivityService.checkConnectivity();
      return _isConnectedFromResult(result);
    } catch (e) {
      throw OfflineException(
        message: 'Error al verificar conectividad: $e',
        code: 'NETWORK_INFO_CHECK_001',
        originalError: e,
      );
    }
  }
  
  @override
  Stream<NetworkStatus> get onConnectivityChanged {
    _connectivityService.onConnectivityChanged.listen((results) {
      final status = _mapConnectivityResult(results);
      _connectivityController.add(status);
    });
    return _connectivityController.stream;
  }
  
  @override
  Future<void> checkConnectivity() async {
    final result = await _connectivityService.checkConnectivity();
    final status = _mapConnectivityResult(result);
    _connectivityController.add(status);
  }
  
  bool _isConnectedFromResult(List<ConnectivityResult> results) {
    return results.any((result) =>
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet);
  }
  
  NetworkStatus _mapConnectivityResult(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return NetworkStatus.offline;
    }
    if (_isConnectedFromResult(results)) {
      return NetworkStatus.online;
    }
    return NetworkStatus.unknown;
  }
  
  void dispose() {
    _connectivityController.close();
  }
}

class ConnectivityServiceImpl implements ConnectivityService {
  final Connectivity _connectivity;
  
  ConnectivityServiceImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();
  
  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return _isConnectedFromResult(result);
  }
  
  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }
  
  @override
  Future<List<ConnectivityResult>> checkConnectivity() async {
    return await _connectivity.checkConnectivity();
  }
  
  bool _isConnectedFromResult(List<ConnectivityResult> results) {
    return results.any((result) =>
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet);
  }
}