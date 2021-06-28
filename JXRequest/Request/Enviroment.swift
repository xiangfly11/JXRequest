//
//  Enviroment.swift
//  JXRequest
//
//  Created by Jiaxiang Li on 2021/6/28.
//

import Foundation

enum Enviroment {
    case test
    case pubTest
    case publish
}

extension Enviroment {
    var baseUrl: URL? {
        switch self {
        case .test:
            return URL.init(string: "https://cover-api.fm-dev.thecover.cn")
        case .pubTest:
            return URL.init(string: "https://api-pre.thecover.cn/")
        case .publish:
            return URL.init(string: "https://api.thecover.cn/")
        }
    }
}
