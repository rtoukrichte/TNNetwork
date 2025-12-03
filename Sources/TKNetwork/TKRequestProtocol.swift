//
//  TKRequestProtocol.swift
//  TKNetwork
//
//  Created by Rida TOUKRICHTE on 14/01/2025.
//

import Foundation

public protocol TKRequestProtocol {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethods { get }
    var headers: [String: String]? { get }
    var parameters: TKRequestParameters? { get }
}



