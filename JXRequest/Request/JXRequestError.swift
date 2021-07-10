//
//  RequestError.swift
//  JXRequest
//
//  Created by Jiaxiang Li on 2021/7/1.
//

import Foundation

public enum JXRequestError: Error {
    /// Indicates `baseURL` of a type that conforms `Request` is invalid.
    case invalidBaseURL(URL)

    /// Indicates `URLRequest` built by `Request.buildURLRequest` is unexpected.
    case unexpectedURLRequest(URLRequest)
}
