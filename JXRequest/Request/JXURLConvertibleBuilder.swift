//
//  URLConvertibleBuilder.swift
//  JXRequest
//
//  Created by Jiaxiang Li on 2021/6/29.
//

import Foundation
import Alamofire

struct JXURLConvertibleBuilder: URLRequestConvertible {
    
    private var request: JXRequest
    
    private var requestURL: URL {
        return request.baseUrl.appendingPathComponent(request.path)
    }
    
    private var urlRequest: URLRequest {
        var urlRequest = URLRequest.init(url: requestURL)
        switch request.method {
        case .send(let method):
            urlRequest.method = HTTPMethod.init(rawValue: method.rawValue)
        default:
            break
        }
        urlRequest.timeoutInterval = request.timeoutInterval
        request.headers.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return urlRequest
    }
    
    private var parameters: [String: Any] {
        var parameters = [String: Any]()
        if let requestParameters = request.parameters {
            parameters = requestParameters
        }
        if let token = request.token, !token.isEmpty {
            parameters["token"] = token
        }
        
        if let code = request.code {
            parameters["code"] = code
        }
        
        if let apiKey = request.apiKey, !apiKey.isEmpty {
            parameters["apiKey"] = apiKey
        }
        
        if let deviceKey = request.deviceKey, !deviceKey.isEmpty {
            parameters["deviceKey"] = deviceKey
        }
        
        return parameters
    }
    
    private var encoding: ParameterEncoding {
        switch request.method {
        case .send(let method):
            switch method {
            case .get:
                return URLEncoding.default
            case .post:
                return JSONEncoding.default
            }
        default:
            return URLEncoding.default
        }
    }
    
    init(request: JXRequest) {
        self.request = request
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let _ = URLComponents(url: requestURL, resolvingAgainstBaseURL: true) else {
            throw JXRequestError.invalidBaseURL(requestURL)
        }
        return try encoding.encode(urlRequest, with: parameters)
    }
}
