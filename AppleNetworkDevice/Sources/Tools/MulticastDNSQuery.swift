//
//  MulticastDNSQuery.swift
//  AppleNetworkDevice
//
//  Created by Sergii Kryvoblotskyi on 5/22/22.
//

import Foundation
import dnssd

final class MulticastDNSQuery {
    
    private let ipAddress: String
    
    init(ipAddress: String) {
        self.ipAddress = ipAddress
    }
    
    func resolveLocalName(callback: @escaping DNSServiceQueryRecordReply) {
        var service: DNSServiceRef?
        let reversedIp = self.ipAddress.components(separatedBy: ".").reversed().joined(separator: ".")
        let query = reversedIp + ".in-addr.arpa."
        DNSServiceQueryRecord(&service, kDNSServiceFlagsForceMulticast | kDNSServiceFlagsTimeout, 0, query, UInt16(kDNSServiceType_PTR), UInt16(kDNSServiceClass_IN), callback, nil)
        DNSServiceSetDispatchQueue(service, .global())
        DNSServiceProcessResult(service)
        DNSServiceRefDeallocate(service)
    }
}
