import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

enum VpnStatus {
  disconnected,
  connecting,
  connected,
  disconnecting,
  error
}

class VpnService {
  static const _channel = MethodChannel('com.ws.vpn/vpn');
  static final VpnService _instance = VpnService._internal();
  
  factory VpnService() {
    return _instance;
  }
  
  VpnService._internal() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  final _statusController = StreamController<VpnStatus>.broadcast();
  Stream<VpnStatus> get statusStream => _statusController.stream;
  VpnStatus _currentStatus = VpnStatus.disconnected;
  VpnStatus get currentStatus => _currentStatus;

  Future<void> connect(String ovpnConfig) async {
    if (_currentStatus == VpnStatus.connecting || _currentStatus == VpnStatus.connected) {
      return;
    }

    try {
      _updateStatus(VpnStatus.connecting);
      
      if (Platform.isIOS) {
        await _channel.invokeMethod('connect', {
          'ovpn': ovpnConfig,
        });
      } else if (Platform.isAndroid) {
        await _channel.invokeMethod('connect', {
          'ovpn': ovpnConfig,
        });
      }
    } catch (e) {
      _updateStatus(VpnStatus.error);
      rethrow;
    }
  }

  Future<void> disconnect() async {
    if (_currentStatus == VpnStatus.disconnected || _currentStatus == VpnStatus.disconnecting) {
      return;
    }

    try {
      _updateStatus(VpnStatus.disconnecting);
      await _channel.invokeMethod('disconnect');
    } catch (e) {
      _updateStatus(VpnStatus.error);
      rethrow;
    }
  }

  Future<bool> get isConnected async {
    try {
      final result = await _channel.invokeMethod<bool>('checkStatus');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  void _updateStatus(VpnStatus status) {
    _currentStatus = status;
    _statusController.add(status);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'updateStatus':
        final status = _parseStatus(call.arguments as String);
        _updateStatus(status);
        break;
    }
  }

  VpnStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'connected':
        return VpnStatus.connected;
      case 'connecting':
        return VpnStatus.connecting;
      case 'disconnected':
        return VpnStatus.disconnected;
      case 'disconnecting':
        return VpnStatus.disconnecting;
      case 'error':
        return VpnStatus.error;
      default:
        return VpnStatus.error;
    }
  }

  void dispose() {
    _statusController.close();
  }
} 