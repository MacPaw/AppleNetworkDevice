//
//  NetService.swift
//  AppleNetworkDevice
//
//  Created by Sergii Kryvoblotskyi on 5/23/22.
//

import Foundation

extension NetService {
    
    var resolvedAddress: String? {
        guard let data = addresses?.first else { return nil }
        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
        data.withUnsafeBytes { (pointer:UnsafePointer<sockaddr>) -> Void in
            guard getnameinfo(pointer, socklen_t(data.count), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 else {
                return
            }
        }
        return String(cString:hostname)
    }
}
