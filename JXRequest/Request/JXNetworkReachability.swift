//
//  JXNetworkReachability.swift
//  JXRequest
//
//  Created by Jiaxiang Li on 2021/7/2.
//

import Foundation
import Alamofire

class JXNetworkReachability {
    static let shared: JXNetworkReachability = JXNetworkReachability.init()
    
    private let manager: NetworkReachabilityManager?
    
    var isReachable: Bool {
        guard let m = manager else {
            return false
        }
        
        return m.isReachable
    }
    
    init() {
        manager = NetworkReachabilityManager.init()
    }
}
