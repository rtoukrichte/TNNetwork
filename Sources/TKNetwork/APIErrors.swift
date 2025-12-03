//
//  NetworkErrors.swift
//  TKNetwork
//
//  Created by Rida TOUKRICHTE on 14/01/2025.
//

import Foundation

public enum APIError: Error {
    case noConnectionInternet
    case serverError
    case badUrl
    case decodingError
    case unknownError(String)
    case requestFailed
}
