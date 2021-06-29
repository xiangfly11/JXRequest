//
//  Session.swift
//  JXRequest
//
//  Created by Jiaxiang Li on 2021/6/25.
//

import Foundation
import Alamofire
import RxSwift

class Session: SessionProtocol {
    public static let shared = Session.init()
    
    public func send<T: Decodable>(request: Request, completion:@escaping(Result<T, Error>) ->Void) {
        let builder = URLConvertibleBuilder.init(request: request)
        self.send(builder, model: request.response as! T, completion: completion)
    }
    
    public func send<T: Decodable>(request: Request) -> Observable<T> {
        return Observable<T>.create {[weak self] (obsever) in
            guard let self = self else {
                return Disposables.create {
                    
                }
            }
            let builder = URLConvertibleBuilder.init(request: request)
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
}
