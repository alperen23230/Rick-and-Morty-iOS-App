//
//  NetworkServiceProtocol.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 4.03.2022.
//

import Foundation
import Combine

protocol NetworkServiceProtocol: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
    var customDecoder: JSONDecoder { get }
    
    func fetchWithURLRequest<T: NetworkRequestProtocol>(_ request: T) -> AnyPublisher<T.ResponseType, Error>
}
