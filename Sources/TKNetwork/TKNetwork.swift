// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Combine

public protocol TKNetworkProtocol {
    func makeRequest<T: Codable>(with builder: TKRequestBuilder, type: T.Type) throws -> Future<T, APIError>
}

public class TKNetwork: TKNetworkProtocol {
    
    public init() {
        
    }
    
    public func makeRequest<T>(with builder: TKRequestBuilder, type: T.Type) throws -> Future<T, APIError> where T: Codable {
        
        return Future { promise in
            do {
                let request = try builder.build()
                
                URLSession.shared.dataTaskPublisher(for: request)
                    .tryMap { (data, response) in
                        guard let httpResponse = response as? HTTPURLResponse
                        else {
                            throw APIError.requestFailed
                        }
                        
                        if (200...299 ~= httpResponse.statusCode) {
                            return data
                        }
                        else {
                            throw APIError.unknownError("Bad response code")
                        }
                    }
                    .decode(type: T.self, decoder: JSONDecoder())
                    .receive(on: DispatchQueue.global(qos: .background))
//                    .mapError { error -> APIError in
//                        if error is DecodingError {
//                            throw APIError.decodingError
//                            //return promise(APIError.decodingError)
//                        }
//                        else if let error = error as? APIError {
//                            throw error
//                            //return promise(.failure(error))
//                        }
//                        else {
//                            throw APIError.unknownError("Unknown error !")
//                            //return promise(.failure(APIError.unknownError("Unknown error !")))
//                        }
//                    }
            }
            catch {
                return promise(.failure(APIError.badUrl))
            }
        }
    }
}
