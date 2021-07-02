//
//  Request.swift
//  JXRequest
//
//  Created by Jiaxiang Li on 2021/6/24.
//

import Foundation

public protocol JXRequest {
    
    var response: Decodable { get }
    
    var headers: [String: String] { get }
    
    var baseUrl: URL { get }
    
    var path: String { get }
    
    var parameters: [String: Any]? { get }
    
    var method: JXRequestMethod { get }
    
    var token: String? { get }
    
    var code: Int? { get }
    
    var timeoutInterval: TimeInterval { get }
    
    var apiKey: String? { get }
    
    var deviceKey: String? { get }
    
    var hashValue: Int { get }
}


public extension JXRequest {
    var baseUrl: URL {
        guard let urlStr = JXEnviroment.shared.baseUrl else {
            return URL.init(string: "")!
        }
        return urlStr
    }
    
    var response: Decodable? {
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
        return 10
    }
    
    var apiKey: String? {
        return nil
    }
    
    var deviceKey: String? {
         return nil
    }
    
    var hashValue: Int {
        var hashValue = 0
        parameters?.forEach({ (key, value) in
            hashValue = hashValue + key.hashValue
        })
        hashValue = hashValue + baseUrl.absoluteString.hashValue
        hashValue = hashValue + path.hashValue
        return hashValue
    }
    
}
