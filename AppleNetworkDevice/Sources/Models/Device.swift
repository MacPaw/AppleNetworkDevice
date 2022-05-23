//
//  Device.swift
//  AppleNetworkDevice
//
//  Created by Sergii Kryvoblotskyi on 5/23/22.
//

import AppKit

private let deviceInfo = NSDictionary(contentsOf: Bundle.main.url(forResource: "macModels", withExtension: "plist")!)!
private let mobileDevices: [MobileDevice] = {
    let data = try! Data(contentsOf: Bundle.main.url(forResource: "iphoneModels", withExtension: "json")!)
    let decoder = JSONDecoder()
    return try! decoder.decode([MobileDevice].self, from: data)
}()

func deviceDescriptionForModel(model: String) -> String? {
    guard let info = deviceInfo[model] as? NSDictionary, let richDescription = info["Detail"] as? String else {
        return nil
    }
    return richDescription
}

@objc class Device: NSObject {
    
    let serviceName: String
    
    @objc let title: String
    @objc dynamic var desc: String
    @objc dynamic var image: NSImage
    @objc dynamic var richDescription: String?
    
    init(serviceName: String, model: String) {
        let workspace = NSWorkspace.shared
        let typeIdentifier = ANLaunchService.deviceTypeIdentifier(fromModelCode: model)
        self.serviceName = serviceName
        self.title = serviceName
        self.desc = workspace.localizedDescription(forType: typeIdentifier) ?? ""
        self.image = workspace.icon(forFileType: typeIdentifier)
        
        
        let mobileDeviceReference = mobileDevices.first(where: { $0.target?.lowercased() == model.lowercased() })
        if let richDescription = deviceDescriptionForModel(model: model) {
            self.richDescription = richDescription
        } else if let mobileDeviceModel = mobileDeviceReference?.product_type, let richDescription = deviceDescriptionForModel(model: mobileDeviceModel) {
            self.richDescription = richDescription
        } else {
            self.richDescription = "Model: \(model)"
        }
    }
    
    func updateWithDeviceModel(model: String) {
        let workspace = NSWorkspace.shared
        let typeIdentifier = ANLaunchService.deviceTypeIdentifier(fromModelCode: model)
        self.desc = workspace.localizedDescription(forType: typeIdentifier) ?? ""
        self.image = workspace.icon(forFileType: typeIdentifier)
        
        let mobileDeviceReference = mobileDevices.first(where: { $0.target?.lowercased() == model.lowercased() })
        if let richDescription = deviceDescriptionForModel(model: model) {
            self.richDescription = richDescription
        } else if let mobileDeviceModel = mobileDeviceReference?.product_type, let richDescription = deviceDescriptionForModel(model: mobileDeviceModel) {
            self.richDescription = richDescription
        } else {
            self.richDescription = nil
        }
    }
}
