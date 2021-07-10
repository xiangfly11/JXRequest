//
//  HttpMethod.swift
//  JXRequest
//
//  Created by Jiaxiang Li on 2021/6/24.
//

import Foundation

public enum JXHTTPMethod: String {
    case get = "GET"
    case post = "POST"
}


public enum JXRequestMethod {
    case send(JXHTTPMethod)
    case download
    case upload
}
