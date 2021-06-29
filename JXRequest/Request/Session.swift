//
//  Session.swift
//  JXRequest
//
//  Created by Jiaxiang Li on 2021/6/25.
//

import Foundation
import Alamofire

class Session: SessionProtocol {
    public static let shared = Session.init()
    
    public func send<T: Decodable>(request: Request, completion:@escaping(Result<T, Error>) ->Void) {
        let builder = URLConvertibleBuilder.init(request: request)
        self.send(builder, model: request.response as! T, completion: completion)
    }
}
