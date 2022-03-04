//
//  Location.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 15.11.2020.
//

import Foundation

struct Location: Decodable, Hashable  {
    let uuid = UUID()
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let created: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case type = "type"
        case dimension = "dimension"
        case created = "created"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
