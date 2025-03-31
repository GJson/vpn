import Flutter
import NetworkExtension

@objc public class VPNPlugin: NSObject, FlutterPlugin {
    private let vpnManager = NEVPNManager.shared()
    private var channel: FlutterMethodChannel?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.ws.vpn/vpn", binaryMessenger: registrar.messenger())
        let instance = VPNPlugin()
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        // 监听VPN状态变化
        NotificationCenter.default.addObserver(
            instance,
            selector: #selector(vpnStatusDidChange(_:)),
            name: NSNotification.Name.NEVPNStatusDidChange,
            object: nil
        )
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "connect":
            connect(call, result: result)
        case "disconnect":
            disconnect(result: result)
        case "checkStatus":
            checkStatus(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func connect(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let ovpnConfig = args["ovpn"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS",
                              message: "Missing OVPN configuration",
                              details: nil))
            return
        }
        
        let tunnelProtocol = NETunnelProviderProtocol()
        tunnelProtocol.providerBundleIdentifier = "com.ws.vpn.VPNExtension"
        tunnelProtocol.serverAddress = "VPN Server"
        tunnelProtocol.providerConfiguration = ["ovpn": ovpnConfig]
        
        vpnManager.protocolConfiguration = tunnelProtocol
        vpnManager.localizedDescription = "WS VPN"
        vpnManager.isEnabled = true
        
        do {
            try vpnManager.saveToPreferences { error in
                if let error = error {
                    result(FlutterError(code: "SAVE_ERROR",
                                      message: error.localizedDescription,
                                      details: nil))
                    return
                }
                
                self.vpnManager.loadFromPreferences { error in
                    if let error = error {
                        result(FlutterError(code: "LOAD_ERROR",
                                          message: error.localizedDescription,
                                          details: nil))
                        return
                    }
                    
                    do {
                        try self.vpnManager.connection.startVPNTunnel()
                        result(nil)
                    } catch {
                        result(FlutterError(code: "START_ERROR",
                                          message: error.localizedDescription,
                                          details: nil))
                    }
                }
            }
        } catch {
            result(FlutterError(code: "SAVE_ERROR",
                              message: error.localizedDescription,
                              details: nil))
        }
    }
    
    private func disconnect(result: @escaping FlutterResult) {
        vpnManager.connection.stopVPNTunnel()
        result(nil)
    }
    
    private func checkStatus(result: @escaping FlutterResult) {
        result(vpnManager.connection.status == .connected)
    }
    
    @objc private func vpnStatusDidChange(_ notification: Notification) {
        guard let connection = notification.object as? NEVPNConnection else { return }
        
        var status: String
        switch connection.status {
        case .connected:
            status = "connected"
        case .connecting:
            status = "connecting"
        case .disconnecting:
            status = "disconnecting"
        case .disconnected:
            status = "disconnected"
        case .invalid:
            status = "error"
        case .reasserting:
            status = "connecting"
        @unknown default:
            status = "error"
        }
        
        channel?.invokeMethod("updateStatus", arguments: status)
    }
} 