//
//  TKRequestBuilder.swift
//  TKNetwork
//
//  Created by Rida TOUKRICHTE on 14/01/2025.
//

import Foundation

public protocol TKRequest {
    
    init(baseURL: URL, path: String)
    
    @discardableResult
    func set(method: HTTPMethods) -> Self
    
    @discardableResult
    func set(path: String) -> Self
    
    @discardableResult
    func set(headers: [String: String]?) -> Self
    
    @discardableResult
    func set(parameters: TKRequestParameters?) -> Self
    
    func build() throws -> URLRequest
}
