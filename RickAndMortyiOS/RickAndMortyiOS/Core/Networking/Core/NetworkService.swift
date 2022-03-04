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
}
