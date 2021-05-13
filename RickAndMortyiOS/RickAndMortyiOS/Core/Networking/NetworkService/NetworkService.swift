//
//  NetworkService.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 15.11.2020.
//

import Foundation
import Combine

enum HTTPTypes: String {
    case GET = "GET", POST = "POST"
}

protocol NetworkServiceProtocol: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
    var customDecoder: JSONDecoder { get }
    func fetchWithURLRequest<T: Decodable>(_ urlRequest: URLRequest) -> AnyPublisher<T, Error>
}

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

    func fetchWithURLRequest<T: Decodable>(_ urlRequest: URLRequest) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError({ $0 as Error })
            .flatMap({ result -> AnyPublisher<T, Error> in
            guard let urlResponse = result.response as? HTTPURLResponse, (200...299).contains(urlResponse.statusCode) else {
                return Just(result.data)
                    .decode(type: APIError.self, decoder: self.customDecoder).tryMap({ errorModel in
                    throw errorModel
                })
                    .eraseToAnyPublisher()
            }
            return Just(result.data).decode(type: T.self, decoder: self.customDecoder)
                .eraseToAnyPublisher()
        })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
