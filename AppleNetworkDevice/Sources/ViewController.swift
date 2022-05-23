//
//  ViewController.swift
//  AppleNetworkDevice
//
//  Created by Sergii Kryvoblotskyi on 5/22/22.
//

import Cocoa
import GCXMulticastDNSKit
import Network


final class ViewController: NSViewController {

    @objc dynamic var devices: [Device] = []
    @objc dynamic var sortDescriptors: [NSSortDescriptor] = [.init(key: "desc", ascending: true)]
    
    private var services: [NetService] = []
    private var browsers: [NetServiceBrowser] = []
        
    private let servicesToBrowse = ["_companion-link._tcp.", "_rdlink._tcp.", "_airport._tcp."]
    private let servicesToMonitor = ["_device-info._tcp.", "_airplay._tcp."]

    override func viewDidLoad() {
        super.viewDidLoad()
        servicesToBrowse.map {
            let browser = NetServiceBrowser()
            browser.delegate = self
            browser.searchForServices(ofType: $0, inDomain: "local.")
            return browser
        }.forEach { browsers.append($0) }
    }
}

extension ViewController: NetServiceBrowserDelegate {
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        servicesToMonitor
        .map { type -> NetService in
            let service = NetService(domain: "local.", type: type, name: service.name)
            service.delegate = self
            return service
        }.forEach {
            $0.startMonitoring()
            services.append($0)
        }
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        if let index = devices.firstIndex(where: { $0.serviceName == service.name }) {
            devices.remove(at: index)
        }
        if let index = services.firstIndex(where: { $0 == service }) {
            services.remove(at: index)
        }
    }
}

extension ViewController: NetServiceDelegate {

    func netService(_ sender: NetService, didUpdateTXTRecord data: Data) {
        guard let deviceModel = self.extractModelFromTXTRecord(recordData: data) else {
            return
        }
        if let existingDevice = self.devices.first(where: { $0.serviceName == sender.name }) {
            existingDevice.updateWithDeviceModel(model: deviceModel)
        } else {
            let device = Device(serviceName: sender.name, model: deviceModel)
            devices.append(device)
        }
    }
    
    private func extractModelFromTXTRecord(recordData: Data) -> String? {
        let txtDictionary = NetService.dictionary(fromTXTRecord: recordData)
        //Check for other keys here
        guard let modelData = txtDictionary["model"], let model = String(data: modelData, encoding: .utf8) else {
            return nil
        }
        return model
    }
}
