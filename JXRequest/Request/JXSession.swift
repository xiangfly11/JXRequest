//
//  Session.swift
//  JXRequest
//
//  Created by Jiaxiang Li on 2021/6/25.
//

import Foundation
import Alamofire
import RxSwift

class JXSession {
    public static let shared = JXSession.init()
    
    private var callbackQueue: DispatchQueue {
        return DispatchQueue(label: "com.jx.background", qos: .background)
    }
    
    //MARK: Public Method
    public func send<T: Decodable>(request: JXRequest) -> Observable<T> {
        return Observable<T>.create {[weak self] (obsever) in
            guard let self = self else {
                return Disposables.create {
                    
                }
            }
            let builder = JXURLConvertibleBuilder.init(request: request)
            self.send(builder, model: request.response as! T) { (result: Result<T, Error>) in
                switch result {
                case .success(let data):
                    obsever.onNext(data)
                    obsever.onCompleted()
                case .failure(let error):
                    obsever.onError(error)
                }
            }
            return Disposables.create {
                
            }
        }
    }
    
    public func cancelAllRequests() -> Observable<Bool> {
        return Observable<Bool>.create { [weak self] (observer) in
            guard let self = self else {
                return Disposables.create()
            }
            
            self.cancelAllRequests {
                observer.onNext(true)
            }
            
            return Disposables.create()
        }
        
    }
    
    //MARK: Private Method
    private func send<T: Decodable>(_ urlRequest: JXURLConvertibleBuilder, model: T, completion: @escaping(Result<T, Error>) -> Void) {
        
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
    
    private func cancelAllRequests(completion: @escaping() -> Void) {
        AF.cancelAllRequests {
            completion()
        }
    }
    
}
