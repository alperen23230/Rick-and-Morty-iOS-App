//
//  NetworkService.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 15.11.2020.
//

import Foundation

class NetworkService: NetworkServiceProtocol {

    let customDecoder = JSONDecoder()
    
    init() {
        setCustomDecoder()
    }
    
    func setCustomDecoder() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        customDecoder.dateDecodingStrategy = .formatted(formatter)
    }
    
    func fetch<T: NetworkRequestProtocol>(_ request: T) async throws -> T.ResponseType {
        var urlRequest = URLRequest(url: request.endpoint.url)
        urlRequest.httpMethod = request.method.rawValue
        let data: T.ResponseType = try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else { return }
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    guard let data = data else {
                        continuation.resume(throwing: CustomError.dataIsNil)
                        return
                    }
                    do {
                        guard let urlResponse = response as? HTTPURLResponse,
                              (200...299).contains(urlResponse.statusCode) else {
                                  let decodedErrorResponse = try self.customDecoder.decode(APIError.self, from: data)
                                  continuation.resume(throwing: decodedErrorResponse)
                                  return
                              }
                        let decodedData = try self.customDecoder.decode(T.ResponseType.self, from: data)
                        continuation.resume(returning: decodedData)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
            .resume()
        }
        return data
    }
}
