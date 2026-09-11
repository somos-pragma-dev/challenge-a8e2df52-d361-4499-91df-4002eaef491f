import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

enum ConnectionStatus { connected, disconnected, unknown }

class ConnectivityStatus extends Equatable {
  final ConnectionStatus status;
  final DateTime timestamp;
  final String? networkType;

  const ConnectivityStatus({
    required this.status,
    required this.timestamp,
    this.networkType,
  });

  bool get isConnected => status == ConnectionStatus.connected;
  bool get isDisconnected => status == ConnectionStatus.disconnected;

  @override
  List<Object?> get props => [status, timestamp, networkType];
}

class ConnectivityService {
  final Connectivity _connectivity;
  final StreamController<ConnectivityStatus> _statusController;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity(),
        _statusController = StreamController<ConnectivityStatus>.broadcast();

  Stream<ConnectivityStatus> get statusStream => _statusController.stream;

  Future<ConnectivityStatus> checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return _mapConnectivityResults(results);
    } catch (e) {
      return ConnectivityStatus(
        status: ConnectionStatus.unknown,
        timestamp: DateTime.now(),
        networkType: null,
      );
    }
  }

  Future<void> startListening() async {
    final initialStatus = await checkConnectivity();
    _statusController.add(initialStatus);

    _subscription = _connectivity.onConnectivityChanged.listen(
      (results) {
        final status = _mapConnectivityResults(results);
        _statusController.add(status);
      },
      onError: (error) {
        _statusController.add(
          ConnectivityStatus(
            status: ConnectionStatus.unknown,
            timestamp: DateTime.now(),
            networkType: null,
          ),
        );
      },
    );
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  ConnectivityStatus _mapConnectivityResults(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return ConnectivityStatus(
        status: ConnectionStatus.disconnected,
        timestamp: DateTime.now(),
        networkType: 'none',
      );
    }

    final primaryResult = results.first;
    String networkType;

    switch (primaryResult) {
      case ConnectivityResult.wifi:
        networkType = 'wifi';
        break;
      case ConnectivityResult.mobile:
        networkType = 'mobile';
        break;
      case ConnectivityResult.ethernet:
        networkType = 'ethernet';
        break;
      case ConnectivityResult.vpn:
        networkType = 'vpn';
        break;
      case ConnectivityResult.other:
        networkType = 'other';
        break;
      default:
        networkType = 'unknown';
    }

    return ConnectivityStatus(
      status: ConnectionStatus.connected,
      timestamp: DateTime.now(),
      networkType: networkType,
    );
  }

  Future<bool> hasActiveConnection() async {
    final status = await checkConnectivity();
    return status.isConnected;
  }

  void dispose() {
    stopListening();
    _statusController.close();
  }
}