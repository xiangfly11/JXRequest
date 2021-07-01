//
//  TestAPI.swift
//  JXRequest
//
//  Created by Jiaxiang Li on 2021/6/29.
//

import Foundation

enum TestAPI: JXRequest {
    case getInfo
    case getDetail(page: Int)
}


extension TestAPI {
    var path: String {
        switch self {
        case .getDetail:
            return "getDetail"
        case .getInfo:
            return "getInfo"
        }
    }
    
    var method: JXHTTPMethod {
        switch self {
        case .getInfo:
            return JXHTTPMethod.get
        case .getDetail:
            return JXHTTPMethod.get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getInfo:
            return ["page" : 1]
        case .getDetail(let page):
            return ["page": page]
        }
    }
    
    var response: Decodable {
        switch self {
        case .getInfo:
            return TestAPIResultA.init()
        case .getDetail(_):
            return TestAPIResultB.init()
        }
    }
}

struct TestAPIResultA: JXResponse {
    var a = ""
}

struct TestAPIResultB: JXResponse {
    var b = ""
}
