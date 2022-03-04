//
//  PageInfo.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 15.11.2020.
//

import Foundation

struct PageInfo: Decodable {
    let itemCount: Int
    let pageCount: Int
    let nextPageURL: String?
    let previousPageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case itemCount = "count"
        case pageCount = "pages"
        case nextPageURL = "next"
        case previousPageURL = "prev"
    }
}
