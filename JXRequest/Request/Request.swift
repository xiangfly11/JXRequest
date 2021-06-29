//
//  Request.swift
//  JXRequest
//
//  Created by Jiaxiang Li on 2021/6/24.
//

import Foundation

public protocol Request {
    
    var response: Codable { get }
    
    var headers: [String: String] { get }
    
    var baseUrl: URL { get }
    
    var path: String { get }
    
    var parameters: [String: Any]? { get }
    
    var method: HttpMethod { get }
    
    var token: String? { get }
    
    var code: Int? { get }
    
    var timeoutInterval: TimeInterval { get }

}


public extension Request {
    var baseUrl: URL {
        guard let urlStr = Enviroment.test.baseUrl else {
            return URL.init(string: "")!
        }
        return urlStr
    }
    
    var response: Codable? {
        return nil
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var headers: [String: String] {
        return ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8"]
    }
    
    var token: String? {
        return nil
    }
    
    var code: Int? {
        return nil
    }
    
    var timeoutInterval: TimeInterval {
        return 6
    }
}
