//
//  GeneralAPIResponse.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 15.11.2020.
//

import Foundation

struct GeneralAPIResponse<T: Decodable>: Decodable {
    let pageInfo: PageInfo
    let results: [T]
    
    enum CodingKeys: String, CodingKey {
        case pageInfo = "info"
        case results = "results"
    }
}
