//
//  TestAPI.swift
//  JXRequest
//
//  Created by Jiaxiang Li on 2021/6/29.
//

import Foundation

enum TestAPI: Request {
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
    
    var method: HttpMethod {
        switch self {
        case .getInfo:
            return HttpMethod.get
        case .getDetail:
            return HttpMethod.get
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

struct TestAPIResultA: Response {
    var a = ""
}

struct TestAPIResultB: Response {
    var b = ""
}
