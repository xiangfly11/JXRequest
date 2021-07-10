//
//  JXLogger.swift
//  JXRequest
//
//  Created by Jiaxiang Li on 2021/7/2.
//

import Foundation
import Alamofire

class JXLogger: EventMonitor {
    let queue: DispatchQueue = DispatchQueue(label: "com.jx.JXLogger")
    
    func requestDidFinish(_ request: Request) {
        print(request.description)
    }
    
    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        guard let data = response.data else {
            return
        }
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                print(json)
            }
        } catch let error {
            print("Failed to print network response: \(error.localizedDescription)")
        }
        
    }
}
