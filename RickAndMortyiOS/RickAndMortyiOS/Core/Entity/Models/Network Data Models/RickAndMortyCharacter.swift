//
//  Character.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 5.12.2020.
//

import Foundation
import UIKit

struct RickAndMortyCharacter: Decodable, Hashable {
    let uuid = UUID()
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let gender: String
    let imageUrl: String
    let created: Date
    var statusColor: UIColor {
        switch status {
        case .alive:
            return .green
        case .dead:
            return .red
        case .unknown:
            return .gray
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case status = "status"
        case species = "species"
        case gender = "gender"
        case imageUrl = "image"
        case created = "created"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

// MARK: - CharacterStatus Enum
extension RickAndMortyCharacter {
    enum CharacterStatus: String, Decodable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "unknown"
    }
}
