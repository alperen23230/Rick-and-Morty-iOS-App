//
//  NetworkServiceProtocol.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 4.03.2022.
//

import Foundation
import Combine

protocol NetworkServiceProtocol: AnyObject {
    var customDecoder: JSONDecoder { get }
    
    func fetch<T: NetworkRequestProtocol>(_ request: T) async throws -> T.ResponseType
}
