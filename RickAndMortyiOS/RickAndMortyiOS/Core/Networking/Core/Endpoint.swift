//
//  NetworkRoutes.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 15.11.2020.
//

import Foundation

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

// MARK: - Base URL
extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "rickandmortyapi.com"
        components.path = "/" + path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        
        return url
    }
}

// MARK: - Endpoints
extension Endpoint {
    static func getLocations(for name: String, page: Int) -> Self {
        Endpoint(
            path: "api/location/",
            queryItems: [URLQueryItem(name: "page", value: String(page)),
                         URLQueryItem(name: "name", value: name)]
        )
    }
    static func getEpisodes(for name: String, page: Int) -> Self {
        Endpoint(
            path: "api/episode/",
            queryItems: [URLQueryItem(name: "page", value: String(page)),
                         URLQueryItem(name: "name", value: name)]
        )
    }
    static func getCharacters(name: String, status: String, gender: String, page: Int) -> Self {
        Endpoint(
            path: "api/character/",
            queryItems: [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "name", value: name),
                URLQueryItem(name: "status", value: status),
                URLQueryItem(name: "gender", value: gender),
            ]
        )
    }
}
