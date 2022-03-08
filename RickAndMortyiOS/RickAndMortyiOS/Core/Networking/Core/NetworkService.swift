//
//  NetworkService.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 15.11.2020.
//

import Foundation
import Combine

class NetworkService: NetworkServiceProtocol {
    
    var cancellables = Set<AnyCancellable>()
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
    
    func fetchWithURLRequest<T: NetworkRequestProtocol>(_ request: T) -> AnyPublisher<T.ResponseType, Error> {
        var urlRequest = URLRequest(url: request.endpoint.url)
        urlRequest.httpMethod = request.method.rawValue
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError({ $0 as Error })
            .flatMap({ result -> AnyPublisher<T.ResponseType, Error> in
                guard let urlResponse = result.response as? HTTPURLResponse, (200...299).contains(urlResponse.statusCode) else {
                    return Just(result.data)
                        .decode(type: APIError.self, decoder: self.customDecoder).tryMap({ errorModel in
                            throw errorModel
                        })
                        .eraseToAnyPublisher()
                }
                return Just(result.data).decode(type: T.ResponseType.self, decoder: self.customDecoder)
                    .eraseToAnyPublisher()
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetch<T: NetworkRequestProtocol>(_ request: T) async throws -> T.ResponseType {
        print(request.endpoint.url)
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
