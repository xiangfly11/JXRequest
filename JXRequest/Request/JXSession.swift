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
    
    private var sessionConfiguration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.af.default
        configuration.allowsCellularAccess = JXEnviroment.shared.allowCellure
        return configuration
    }
    
    private var session: Session {
        let eventMonitors = JXEnviroment.shared.printLog ? [JXLogger.init()] : []
        let session = Session.init(configuration: sessionConfiguration,  requestQueue: callbackQueue, eventMonitors: eventMonitors)
        
        return session
    }
    
    private var dataRequests: [Request] = [Request]()
    private var callbackQueue: DispatchQueue {
        return DispatchQueue(label: "com.jx.background", qos: .background)
    }
    
    init() {
        if JXEnviroment.shared.printLog {
            
        }
    }
    
    //MARK: Public Method
    public func send<T: Decodable>(request: JXRequest) -> Observable<T> {
        let builder = JXURLConvertibleBuilder.init(request: request)
        
        return Observable<T>.create {[weak self] (obsever) in
            guard let self = self else {
                return Disposables.create()
            }
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
    
    public func download(request: JXRequest) -> Observable<Progress> {
        let builder = JXURLConvertibleBuilder.init(request: request)
        return Observable<Progress>.create { [weak self] (observer) in
            guard let self = self else {
                return Disposables.create()
            }
            let downloadRequest = self.downlod(builder) { progress in
                observer.onNext(progress)
            }
            return Disposables.create {
                downloadRequest.cancel()
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
        let dataRequest = session.request(urlRequest)
        dataRequest.responseDecodable(of: T.self, queue: callbackQueue) { (result) in
            if let value = result.value {
                completion(Result.success(value))
            } else if let error = result.error {
                completion(Result.failure(error))
            }
        }
        return dataRequest
    }
    
    private func downlod(_ urlRequest: JXURLConvertibleBuilder, progressHandler: @escaping(Progress) -> Void) -> DownloadRequest {
        let downloadRequest = session.download(urlRequest)
        downloadRequest.downloadProgress { progress in
            progressHandler(progress)
        }
        self.dataRequests.append(downloadRequest)
        return downloadRequest
    }
    
    private func cancelAllRequests(completion: @escaping() -> Void) {
        self.dataRequests.forEach { (request) in
            request.cancel()
        }
        
        for request in self.dataRequests {
            request.cancel()
        }
        
        self.dataRequests.removeAll()
    }
    
    private func setDataRequestKey(request: JXRequest, dataRequest: Request) {
        objc_setAssociatedObject(dataRequest, &DataRequestKey, request.hashValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func getDataRequestKey(dataRequest: Request) -> Int {
        guard let key = objc_getAssociatedObject(dataRequest, &DataRequestKey) as? Int else {
            return 0
        }
        return key
    }
    
}
