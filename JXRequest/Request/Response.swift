//
//  Response.swift
//  JXRequest
//
//  Created by Jiaxiang Li on 2021/6/29.
//

import Foundation

protocol Response: Decodable {
    var message: String { get }
    var code: Int { get }
}

extension Response {
    var message: String {
        return ""
    }
    
    var code: Int {
        return 0
    }
}
