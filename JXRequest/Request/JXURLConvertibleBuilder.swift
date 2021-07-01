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
        urlRequest.method = HTTPMethod.init(rawValue: request.method.rawValue)
        urlRequest.timeoutInterval = request.timeoutInterval
        request.headers.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        return urlRequest
    }
    
    private var encoding: ParameterEncoding {
        switch request.method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    init(request: JXRequest) {
        self.request = request
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let _ = URLComponents(url: requestURL, resolvingAgainstBaseURL: true) else {
            throw JXRequestError.invalidBaseURL(requestURL)
        }
        return try encoding.encode(urlRequest, with: request.parameters)
    }
}
