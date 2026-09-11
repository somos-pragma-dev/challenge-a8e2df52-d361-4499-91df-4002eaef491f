package offline_field_app.core.network;

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

enum ConnectionStatus {
  connected,
  disconnected,
  connecting,
}

class ConnectionState extends Equatable {
  final ConnectionStatus status;
  final List<ConnectivityResult> availableTechnologies;
  final DateTime timestamp;
  final bool wasOffline;

  const ConnectionState({
    required this.status,
    required this.availableTechnologies,
    required this.timestamp,
    this.wasOffline = false,
  });

  factory ConnectionState.initial() => ConnectionState(
        status: ConnectionStatus.disconnected,
        availableTechnologies: [],
        timestamp: DateTime.now(),
      );

  factory ConnectionState.fromConnectivityResult(
    List<ConnectivityResult> results,
    bool wasOffline,
  ) {
    final hasConnection = results.isNotEmpty &&
        !results.every((r) => r == ConnectivityResult.none);

    ConnectionStatus status;
    if (hasConnection) {
      status = ConnectionStatus.connected;
    } else {
      status = ConnectionStatus.disconnected;
    }

    return ConnectionState(
      status: status,
      availableTechnologies: results,
      timestamp: DateTime.now(),
      wasOffline: wasOffline,
    );
  }

  bool get isConnected => status == ConnectionStatus.connected;
  bool get isDisconnected => status == ConnectionStatus.disconnected;
  bool get isConnecting => status == ConnectionStatus.connecting;

  String get technologyDescription {
    if (availableTechnologies.isEmpty) return 'None';
    return availableTechnologies
        .map((r) => r.name)
        .join(', ');
  }

  @override
  List<Object?> get props => [status, availableTechnologies, timestamp, wasOffline];
}

abstract class ReactiveConnectivityService {
  Stream<ConnectionState> get connectionStateStream;
  Future<ConnectionState> get currentState;
  Stream<bool> get isConnectedStream;
  Future<bool> get isConnected;
  Future<void> checkConnection();
  void dispose();
}

class ReactiveConnectivityServiceImpl implements ReactiveConnectivityService {
  final Connectivity _connectivity;
  final StreamController<ConnectionState> _stateController;
  final StreamController<bool> _connectedController;
  ConnectionState _currentState;
  bool _isDisposed = false;

  ReactiveConnectivityServiceImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity(),
        _stateController = StreamController<ConnectionState>.broadcast(),
        _connectedController = StreamController<bool>.broadcast(),
        _currentState = ConnectionState.initial() {
    _initializeListener();
  }

  void _initializeListener() {
    _connectivity.onConnectivityChanged.listen(
      _handleConnectivityChange,
      onError: (error) {
        _emitErrorState(error);
      },
    );
  }

  Future<void> _handleConnectivityChange(List<ConnectivityResult> results) async {
    if (_isDisposed) return;

    final previousState = _currentState;
    final wasOffline = previousState.isDisconnected;
    
    _currentState = ConnectionState.fromConnectivityResult(
      results,
      wasOffline,
    );

    if (!_stateController.isClosed) {
      _stateController.add(_currentState);
    }

    if (!_connectedController.isClosed) {
      _connectedController.add(_currentState.isConnected);
    }
  }

  void _emitErrorState(dynamic error) {
    if (_isDisposed) return;
    
    _currentState = ConnectionState(
      status: ConnectionStatus.disconnected,
      availableTechnologies: [],
      timestamp: DateTime.now(),
      wasOffline: true,
    );

    if (!_stateController.isClosed) {
      _stateController.add(_currentState);
    }
    if (!_connectedController.isClosed) {
      _connectedController.add(false);
    }
  }

  @override
  Stream<ConnectionState> get connectionStateStream => _stateController.stream;

  @override
  Future<ConnectionState> get currentState async {
    if (_isDisposed) return ConnectionState.initial();
    
    final results = await _connectivity.checkConnectivity();
    final wasOffline = _currentState.isDisconnected;
    return ConnectionState.fromConnectivityResult(results, wasOffline);
  }

  @override
  Stream<bool> get isConnectedStream => _connectedController.stream;

  @override
  Future<bool> get isConnected async {
    if (_isDisposed) return false;
    
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty &&
        !results.every((r) => r == ConnectivityResult.none);
  }

  @override
  Future<void> checkConnection() async {
    if (_isDisposed) return;
    
    try {
      final results = await _connectivity.checkConnectivity();
      await _handleConnectivityChange(results);
    } catch (e) {
      _emitErrorState(e);
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    if (!_stateController.isClosed) {
      _stateController.close();
    }
    if (!_connectedController.isClosed) {
      _connectedController.close();
    }
  }
}

class ConnectivityServiceFactory {
  static ReactiveConnectivityService create() {
    return ReactiveConnectivityServiceImpl();
  }
}