//
//  TKRequestBuilder.swift
//  TKNetwork
//
//  Created by Rida TOUKRICHTE on 14/01/2025.
//

import Foundation

public final class TKRequestBuilder: TKRequest {
    
    var baseURL: URL
    var path: String
    var method: HTTPMethods = .get
    var headers: [String: String]?
    var parameters: TKRequestParameters?
    
    public init(baseURL: URL, path: String) {
        self.baseURL = baseURL
        self.path = path
    }
    
    @discardableResult
    public func set(method: HTTPMethods) -> Self {
        self.method = method
        return self
    }
    
    @discardableResult
    public func set(path: String) -> Self {
        self.path = path
        return self
    }
    
    @discardableResult
    public func set(headers: [String : String]?) -> Self {
        self.headers = headers
        return self
    }
    
    @discardableResult
    public func set(parameters: TKRequestParameters?) -> Self {
        self.parameters = parameters
        return self
    }
    
    public func build() throws -> URLRequest {
        var url = baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 50)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        setupBody(for: &urlRequest)
        
        return urlRequest
    }
    
    
    private func setupBody(for request: inout URLRequest) {
        if let params = parameters {
            switch params {
            case .body(let bodyParams):
                setupRequestBody(bodyParams, for: &request)
                
            case .url(let urlParams):
                setupRequestURLBody(urlParams, for: &request)
            }
        }
    }
    
    private func setupRequestBody(_ parameters: [String: Any]?, for request: inout URLRequest) {
        if let parameters = parameters {
            let data = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = data
        }
    }
    
    private func setupRequestURLBody(_ parameters: [String: String]?, for request: inout URLRequest) {
        if let parameters = parameters, let url = request.url, var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            
            urlComponents.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
            
            request.url = urlComponents.url
        }
    }
    
}
