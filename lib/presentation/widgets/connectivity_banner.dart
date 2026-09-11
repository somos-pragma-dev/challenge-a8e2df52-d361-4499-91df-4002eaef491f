package presentation.widgets;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/network/network_info.dart';
import '../../core/constants/app_constants.dart';

class ConnectivityBanner extends StatefulWidget {
  final Widget? child;
  final bool showBanner;
  final Duration animationDuration;

  const ConnectivityBanner({
    super.key,
    this.child,
    this.showBanner = true,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner> {
  StreamSubscription? _connectivitySubscription;
  NetworkStatus _currentStatus = NetworkStatus.connected;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _initConnectivityListener();
  }

  void _initConnectivityListener() {
    final networkInfo = context.read<NetworkInfo>();
    _connectivitySubscription = networkInfo.onConnectivityChanged.listen(
      (status) {
        setState(() {
          _currentStatus = status;
          _isVisible = status == NetworkStatus.disconnected ||
              status == NetworkStatus.connecting;
        });
      },
      onError: (error) {
        debugPrint('Error en listener de conectividad: $error');
      },
    );
    
    networkInfo.checkConnectivity().then((_) {
      if (mounted) {
        setState(() {
          _isVisible = _currentStatus == NetworkStatus.disconnected ||
              _currentStatus == NetworkStatus.connecting;
        });
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSlide(
          duration: widget.animationDuration,
          curve: Curves.easeInOut,
          offset: _isVisible && widget.showBanner 
              ? Offset.zero 
              : const Offset(0, -1),
          child: AnimatedOpacity(
            duration: widget.animationDuration,
            opacity: _isVisible && widget.showBanner ? 1.0 : 0.0,
            child: _buildBanner(context),
          ),
        ),
        if (widget.child != null) widget.child!,
      ],
    );
  }

  Widget _buildBanner(BuildContext context) {
    final theme = Theme.of(context);
    final isConnecting = _currentStatus == NetworkStatus.connecting;
    final isDisconnected = _currentStatus == NetworkStatus.disconnected;
    
    Color backgroundColor;
    Color textColor;
    IconData icon;
    String message;
    
    if (isConnecting) {
      backgroundColor = Colors.orange.shade100;
      textColor = Colors.orange.shade800;
      icon = Icons.wifi_find;
      message = 'Conectando...';
    } else if (isDisconnected) {
      backgroundColor = Colors.red.shade100;
      textColor = Colors.red.shade800;
      icon = Icons.wifi_off;
      message = 'Sin conexión - Modo offline';
    } else {
      backgroundColor = Colors.green.shade100;
      textColor = Colors.green.shade800;
      icon = Icons.wifi;
      message = 'Conectado';
    }
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (isConnecting)
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            else
              Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (isDisconnected)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: textColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'OFFLINE',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}