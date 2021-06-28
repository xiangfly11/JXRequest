//
//  Request.swift
//  JXRequest
//
//  Created by Jiaxiang Li on 2021/6/24.
//

import Foundation

public protocol Request {
    
    associatedtype Response
    
    var headers: [String: String] { get }
    
    var baseUrlStr: URL { get }
    
    var path: String { get }
    
    var parameters: [String: Any]? { get }
    
    var method: HttpMethod { get }
    
    var token: String? { get }
    
    var code: Int? { get }

}


public extension Request {
    var baseUrlString: URL {
        guard let urlStr = Enviroment.test.baseUrl else {
            return URL.init(string: "")!
        }
        return urlStr
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
}
