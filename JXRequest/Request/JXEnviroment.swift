//
//  Enviroment.swift
//  JXRequest
//
//  Created by Jiaxiang Li on 2021/6/28.
//

import Foundation

enum JXNetworkEnviroment {
    case test
    case pubTest
    case publish
}

class JXEnviroment {
    static let shared: JXEnviroment = JXEnviroment.init()
    var networkEnviroment: JXNetworkEnviroment {
        return .test
    }
    var baseUrl: URL? {
        switch networkEnviroment {
        case .test:
            return URL.init(string: "https://cover-api.fm-dev.thecover.cn")
        case .pubTest:
            return URL.init(string: "https://api-pre.thecover.cn/")
        case .publish:
            return URL.init(string: "https://api.thecover.cn/")
        }
    }
    
    var printLog: Bool {
        return true
    }
}
