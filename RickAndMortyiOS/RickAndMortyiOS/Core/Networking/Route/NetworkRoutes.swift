//
//  NetworkRoutes.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 15.11.2020.
//

import Foundation

struct NetworkRoutes {
    
    static var sharedInstance = NetworkRoutes()
    
    var urlComponent = URLComponents()
    
    private init(){
        self.urlComponent.scheme = "https"
        self.urlComponent.host = "rickandmortyapi.com"
    }
    
    enum Path: String {
        case getLocations = "/api/location"
        case getEpisodes = "/api/episode/"
    }
}
