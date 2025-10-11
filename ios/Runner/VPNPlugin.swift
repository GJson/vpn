import Flutter
// 暂时注释掉 NetworkExtension 引用
// import NetworkExtension

@objc public class VPNPlugin: NSObject, FlutterPlugin {
    // 模拟 VPN 功能
    private var channel: FlutterMethodChannel?
    private var mockStatus: String = "disconnected"
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.ws.vpn/vpn", binaryMessenger: registrar.messenger())
        let instance = VPNPlugin()
        instance.channel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "connect":
            mockConnect(call, result: result)
        case "disconnect":
            mockDisconnect(result: result)
        case "checkStatus":
            mockCheckStatus(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func mockConnect(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        mockStatus = "connecting"
        channel?.invokeMethod("updateStatus", arguments: mockStatus)
        
        // 模拟连接延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.mockStatus = "connected"
            self.channel?.invokeMethod("updateStatus", arguments: self.mockStatus)
            result(nil)
        }
    }
    
    private func mockDisconnect(result: @escaping FlutterResult) {
        mockStatus = "disconnecting"
        channel?.invokeMethod("updateStatus", arguments: mockStatus)
        
        // 模拟断开连接延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.mockStatus = "disconnected"
            self.channel?.invokeMethod("updateStatus", arguments: self.mockStatus)
            result(nil)
        }
    }
    
    private func mockCheckStatus(result: @escaping FlutterResult) {
        result(mockStatus == "connected")
    }
} 