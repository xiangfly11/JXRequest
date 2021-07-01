//
//  Response.swift
//  JXRequest
//
//  Created by Jiaxiang Li on 2021/6/29.
//

import Foundation

protocol JXResponse: Decodable {
    var message: String { get }
    var code: Int { get }
}

extension JXResponse {
    var message: String {
        return ""
    }
    
    var code: Int {
        return 0
    }
}
