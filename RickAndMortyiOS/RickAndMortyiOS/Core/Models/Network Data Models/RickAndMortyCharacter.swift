//
//  Character.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 5.12.2020.
//

import Foundation

struct RickAndMortyCharacter: Decodable, Hashable {
    let uuid = UUID()
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let imageURL: String
    let created: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case status = "status"
        case species = "species"
        case gender = "gender"
        case imageURL = "image"
        case created = "created"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
