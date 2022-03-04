//
//  NetworkRequestProtocol.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 4.03.2022.
//

protocol NetworkRequestProtocol {
    associatedtype ResponseType: Decodable
    
    var endpoint: Endpoint { get }
    var method: HTTPMethod { get }
}
