import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
  Future<ConnectivityResult> get connectivityResult;
  Future<List<ConnectivityResult>> get connectivityResults;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  final StreamController<bool> _connectivityStreamController;
  bool _lastKnownState = false;
  
  NetworkInfoImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity(),
        _connectivityStreamController = StreamController<bool>.broadcast() {
    _initConnectivityListener();
  }

  void _initConnectivityListener() {
    _connectivity.onConnectivityChanged.listen((results) {
      final isConnected = _checkConnectivity(results);
      if (isConnected != _lastKnownState) {
        _lastKnownState = isConnected;
        _connectivityStreamController.add(isConnected);
      }
    });
  }

  bool _checkConnectivity(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return false;
    }
    return results.any((result) => result != ConnectivityResult.none);
  }

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return _checkConnectivity(results);
  }

  @override
  Stream<bool> get onConnectivityChanged => _connectivityStreamController.stream;

  @override
  Future<ConnectivityResult> get connectivityResult async {
    final results = await _connectivity.checkConnectivity();
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return ConnectivityResult.none;
    }
    return results.first;
  }

  @override
  Future<List<ConnectivityResult>> get connectivityResults async {
    final results = await _connectivity.checkConnectivity();
    return results;
  }

  Future<NetworkType> getNetworkType() async {
    final result = await connectivityResult;
    switch (result) {
      case ConnectivityResult.wifi:
        return NetworkType.wifi;
      case ConnectivityResult.mobile:
        return NetworkType.mobile;
      case ConnectivityResult.ethernet:
        return NetworkType.ethernet;
      case ConnectivityResult.bluetooth:
        return NetworkType.bluetooth;
      case ConnectivityResult.vpn:
        return NetworkType.vpn;
      case ConnectivityResult.other:
        return NetworkType.other;
      case ConnectivityResult.none:
      default:
        return NetworkType.none;
    }
  }

  bool isWifiConnected(List<ConnectivityResult> results) {
    return results.contains(ConnectivityResult.wifi);
  }

  bool isMobileDataConnected(List<ConnectivityResult> results) {
    return results.contains(ConnectivityResult.mobile);
  }

  void dispose() {
    _connectivityStreamController.close();
  }
}

enum NetworkType {
  wifi,
  mobile,
  ethernet,
  bluetooth,
  vpn,
  other,
  none,
}

extension NetworkTypeExtension on NetworkType {
  String get displayName {
    switch (this) {
      case NetworkType.wifi:
        return 'WiFi';
      case NetworkType.mobile:
        return 'Datos Móviles';
      case NetworkType.ethernet:
        return 'Ethernet';
      case NetworkType.bluetooth:
        return 'Bluetooth';
      case NetworkType.vpn:
        return 'VPN';
      case NetworkType.other:
        return 'Otra';
      case NetworkType.none:
        return 'Sin conexión';
    }
  }

  bool get isAvailable => this != NetworkType.none;
  bool get isHighSpeed => this == NetworkType.wifi || this == NetworkType.ethernet;
}