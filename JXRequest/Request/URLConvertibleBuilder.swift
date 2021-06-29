//
//  URLConvertibleBuilder.swift
//  JXRequest
//
//  Created by Jiaxiang Li on 2021/6/29.
//

import Foundation
import Alamofire

struct URLConvertibleBuilder: URLRequestConvertible {
    
    fileprivate var request: Request
    
    fileprivate var requestURL: URL {
        return request.baseUrl.appendingPathComponent(request.path)
    }
    
    fileprivate var urlRequest: URLRequest {
        var urlRequest = URLRequest.init(url: requestURL)
        urlRequest.method = HTTPMethod.init(rawValue: request.method.rawValue)
        urlRequest.timeoutInterval = request.timeoutInterval
        request.headers.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return urlRequest
    }
    
    fileprivate var encoding: ParameterEncoding {
        switch request.method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    init(request: Request) {
        self.request = request
    }
    
    func asURLRequest() throws -> URLRequest {
        return try encoding.encode(urlRequest, with: request.parameters)
    }
}
