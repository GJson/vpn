//
//  PacketTunnelProvider.swift
//  VPNExtension
//
//  Created by wangshu on 2025/3/28.
//

import NetworkExtension
import OpenVPNAdapter

class PacketTunnelProvider: NEPacketTunnelProvider {
    private let vpnAdapter = OpenVPNAdapter()
    private var startHandler: ((Error?) -> Void)?
    private var stopHandler: ((Error?) -> Void)?
    
    override func startTunnel(options: [String: NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        guard let protocolConfiguration = protocolConfiguration as? NETunnelProviderProtocol,
              let providerConfiguration = protocolConfiguration.providerConfiguration,
              let ovpnFileContent = providerConfiguration["ovpn"] as? String else {
            let error = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing OVPN configuration"])
            completionHandler(error)
            return
        }
        
        startHandler = completionHandler
        
        let configuration = OpenVPNConfiguration()
        configuration.fileContent = ovpnFileContent
        
        // 配置VPN适配器
        vpnAdapter.delegate = self
        
        do {
            try vpnAdapter.apply(configuration: configuration)
            try vpnAdapter.connect()
        } catch {
            completionHandler(error)
        }
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping (Error?) -> Void) {
        stopHandler = completionHandler
        vpnAdapter.disconnect()
    }
    
    override func handleAppMessage(_ messageData: Data, completionHandler: ((Data?) -> Void)?) {
        if let handler = completionHandler {
            handler(messageData)
        }
    }
    
    override func sleep(completionHandler: @escaping () -> Void) {
        // Add code here to get ready to sleep.
        completionHandler()
    }
    
    override func wake() {
        // Add code here to wake up.
    }
}

extension PacketTunnelProvider: OpenVPNAdapterDelegate {
    // 配置VPN连接
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, configureTunnelWithNetworkSettings networkSettings: NEPacketTunnelNetworkSettings?, completionHandler: @escaping (Error?) -> Void) {
        guard let networkSettings = networkSettings else {
            completionHandler(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to configure tunnel"]))
            return
        }
        
        setTunnelNetworkSettings(networkSettings) { error in
            completionHandler(error)
            if error == nil {
                self.startHandler?(nil)
                self.startHandler = nil
            }
        }
    }
    
    // 处理事件
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleEvent event: OpenVPNAdapterEvent, message: String?) {
        switch event {
        case .connected:
            NSLog("VPN Connected")
        case .disconnected:
            NSLog("VPN Disconnected")
            if let handler = stopHandler {
                handler(nil)
                stopHandler = nil
            }
        case .connecting:
            NSLog("VPN Connecting")
        case .reconnecting:
            NSLog("VPN Reconnecting")
        case .info:
            NSLog("VPN Info: \(message ?? "")")
        case .error:
            NSLog("VPN Error: \(message ?? "")")
        default:
            break
        }
    }
    
    // 处理错误
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleError error: Error) {
        NSLog("VPN Error: \(error.localizedDescription)")
    }
    
    // 处理日志消息
    func openVPNAdapter(_ openVPNAdapter: OpenVPNAdapter, handleLogMessage logMessage: String) {
        NSLog("VPN Log: \(logMessage)")
    }
}
