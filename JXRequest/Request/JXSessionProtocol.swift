//
//  SessionProtocol.swift
//  JXRequest
//
//  Created by Jiaxiang Li on 2021/6/29.
//

import Foundation
import Alamofire

protocol JXSessionProtocol {
    
    var callbackQueue: DispatchQueue { get }
    
    func send<T: Decodable>(_ urlRequest: JXURLConvertibleBuilder, model: T, completion: @escaping(Result<T, Error>) -> Void)
}

extension JXSessionProtocol {
    
    var callbackQueue: DispatchQueue {
        return DispatchQueue(label: "com.jx.background", qos: .background)
    }
    
    func send<T: Decodable>(_ urlRequest: JXURLConvertibleBuilder, model: T, completion: @escaping(Result<T, Error>) -> Void) {
        
        let requestPublisher = AF.request(urlRequest).publishDecodable(type: model as! T.Type)
        let _ = requestPublisher.subscribe(on: callbackQueue)
            .receive(on: RunLoop.main)
            .sink { result in
                if let value = result.value {
                    completion(Result.success(value))
                } else if let error = result.error {
                    completion(Result.failure(error))
                }
            }
    }
}
