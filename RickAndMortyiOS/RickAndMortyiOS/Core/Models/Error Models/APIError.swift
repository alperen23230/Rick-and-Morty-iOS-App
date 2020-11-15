//
//  APIError.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 15.11.2020.
//

import Foundation

struct APIError: Decodable, Error {
    let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case errorMessage = "error"
    }
}
