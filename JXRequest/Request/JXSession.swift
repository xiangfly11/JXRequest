//
//  Session.swift
//  JXRequest
//
//  Created by Jiaxiang Li on 2021/6/25.
//

import Foundation
import Alamofire
import RxSwift

private var DataRequestKey = "com.jx.DataRequestKey"

class JXSession {
    public static let shared = JXSession.init()
    
    private var dataRequests: [DataRequest] = [DataRequest]()
    private var callbackQueue: DispatchQueue {
        return DispatchQueue(label: "com.jx.background", qos: .background)
    }
    
    //MARK: Public Method
    public func send<T: Decodable>(request: JXRequest) -> Observable<T> {
        return Observable<T>.create {[weak self] (obsever) in
            guard let self = self else {
                return Disposables.create()
            }
            
            let builder = JXURLConvertibleBuilder.init(request: request)
            let requestData = self.send(builder, model: request.response as! T) { (result: Result<T, Error>) in
                switch result {
                case .success(let data):
                    obsever.onNext(data)
                    obsever.onCompleted()
                case .failure(let error):
                    obsever.onError(error)
                }
            }
            self.setDataRequestKey(request: request, dataRequest: requestData)
            return Disposables.create {
                requestData.cancel()
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
    
    public func cancelRequest(request: JXRequest) {
        let resultArr = self.dataRequests.filter({ [weak self] dataRequest in
            guard let self = self else { return false }
            return request.hashValue == self.getDataRequestKey(dataRequest: dataRequest)
        })
        
        for (_, requestData) in resultArr.enumerated() {
            requestData.cancel()
        }
        self.dataRequests.removeAll { dataRequest in
            resultArr.contains(dataRequest)
        }
    }
    
    public func getRequestState(request: JXRequest) -> Request.State {
        let result = self.dataRequests.first {[weak self] dataRequest in
            guard let self = self else { return false }
            return request.hashValue == self.getDataRequestKey(dataRequest: dataRequest)
       }
        
        guard let state = result?.state else {
            return Request.State.cancelled
        }
        return state
    }
}

extension JXSession {
    //MARK: Private Method
    private func send<T: Decodable>(_ urlRequest: JXURLConvertibleBuilder, model: T, completion: @escaping(Result<T, Error>) -> Void) -> DataRequest {
        let dataRequest = AF.request(urlRequest)
        let requestPublisher = dataRequest.publishDecodable(type: model as! T.Type)
        
        let _ = requestPublisher.subscribe(on: callbackQueue)
            .receive(on: RunLoop.main)
            .sink { result in
                if let value = result.value {
                    completion(Result.success(value))
                } else if let error = result.error {
                    completion(Result.failure(error))
                }
            }
        self.dataRequests.append(dataRequest)
        return dataRequest
    }
    
    private func cancelAllRequests(completion: @escaping() -> Void) {
        AF.cancelAllRequests {[weak self] in
            guard let self = self else { return }
            self.dataRequests.removeAll()
            completion()
        }
    }
    
    private func getAllRequest(completion: @escaping([URLSessionTask]) -> Void) {
        AF.session.getAllTasks { tasks in
            completion(tasks)
        }
    }
    
    private func currentAllRequest(completion: @escaping([URLSessionTask]) -> Void) {
        AF.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            let tasks = dataTasks + uploadTasks + downloadTasks
            completion(tasks)
        }
    }
    
    private func setDataRequestKey(request: JXRequest, dataRequest: DataRequest) {
        objc_setAssociatedObject(dataRequest, &DataRequestKey, request.hashValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func getDataRequestKey(dataRequest: DataRequest) -> Int {
        guard let key = objc_getAssociatedObject(dataRequest, &DataRequestKey) as? Int else {
            return 0
        }
        return key
    }
    
}
