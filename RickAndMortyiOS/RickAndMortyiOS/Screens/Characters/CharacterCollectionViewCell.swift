//
//  CharacterCollectionViewCell.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 6.12.2020.
//

import Foundation
import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = "CharacterViewCell"
    
    var name: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        name = UILabel(frame: contentView.bounds)
        
        contentView.addSubview(name)
    }
    
    func configure(with character: Character) {
        name.text = character.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("Just… no")
    }
}
