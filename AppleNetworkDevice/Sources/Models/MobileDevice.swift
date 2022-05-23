//
//  MobileDevice.swift
//  AppleNetworkDevice
//
//  Created by Sergii Kryvoblotskyi on 5/23/22.
//

import Foundation

struct MobileDevice: Codable {
    
    let target: String?
    let target_type: String?
    let target_variant: String?
    let platform: String?
    let product_type: String?
    let product_description: String?
    let compatible_device_fallback: String?
}
