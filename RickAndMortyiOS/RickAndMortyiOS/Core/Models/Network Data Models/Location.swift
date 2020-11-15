//
//  Location.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 15.11.2020.
//

import Foundation

struct Location: Decodable, Hashable  {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let created: Date
}
