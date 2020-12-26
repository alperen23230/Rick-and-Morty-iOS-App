//
//  Constants.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 31.10.2020.
//

import Foundation
import UIKit

enum SFSymbols {
    static let locationsSymbol = UIImage(systemName: "globe")
    static let charactersSymbol = UIImage(systemName: "person.3")
    static let episodesSymbol = UIImage(systemName: "tv")
    static let characterFilterSymbol = UIImage(systemName: "line.horizontal.3.decrease.circle")
    static let statusSymbol = UIImage(systemName: "circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 8, weight: .regular, scale: .default))
}

enum ScreenSize {
    static let width        = UIScreen.main.bounds.size.width
    static let height       = UIScreen.main.bounds.size.height
    static let maxLength    = max(ScreenSize.width, ScreenSize.height)
    static let minLength    = min(ScreenSize.width, ScreenSize.height)
}
