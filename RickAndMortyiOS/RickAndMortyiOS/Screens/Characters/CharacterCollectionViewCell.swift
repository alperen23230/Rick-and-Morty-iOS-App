//
//  CharacterCollectionViewCell.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 6.12.2020.
//

import Foundation
import UIKit
import SDWebImage

class CharacterCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = "CharacterViewCell"
    
    @UsesAutoLayout
    var characterImageView = UIImageView()
    @UsesAutoLayout
    var nameLabel = UILabel()
    @UsesAutoLayout
    var statusStackView = UIStackView()
    @UsesAutoLayout
    var statusLabel = UILabel()
    @UsesAutoLayout
    var statusImageView = UIImageView(image: SFSymbols.statusSymbol)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
    }
    
    private func configureCell(){
        contentView.layer.cornerRadius = 10.0
        contentView.backgroundColor = .rickBlue
        
        nameLabel.font = .preferredFont(forTextStyle: .subheadline)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.textColor = .white
        
        statusLabel.font = .preferredFont(forTextStyle: .footnote)
        statusLabel.lineBreakMode = .byTruncatingTail
        statusLabel.textColor = .secondaryLabel
        
        characterImageView.layer.masksToBounds = true
        characterImageView.layer.cornerRadius = 10.0
        characterImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        configureStatusStackView()
        
        
        addSubview(characterImageView)
        addSubview(nameLabel)
        addSubview(statusStackView)
        
        configureAutoLayoutConstraints()
    }
    
    private func configureStatusStackView() {
        statusStackView.axis  = .horizontal
        statusStackView.distribution  = .fillProportionally
        statusStackView.alignment = .center
        statusStackView.spacing   = 4.0
        
        statusStackView.addArrangedSubview(statusImageView)
        statusStackView.addArrangedSubview(statusLabel)
    }
    
    private func configureAutoLayoutConstraints() {
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            characterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            characterImageView.heightAnchor.constraint(equalTo: characterImageView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            statusImageView.heightAnchor.constraint(equalToConstant: 8.0),
            statusImageView.widthAnchor.constraint(equalToConstant: 8.0),
            
            statusStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            statusStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            statusStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            statusStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func set(with character: Character) {
        guard let imageURL = URL(string: character.imageURL) else { return }
        characterImageView.sd_setImage(with: imageURL)
        nameLabel.text = character.name
        statusImageView.tintColor = character.status == "Alive" ? .green : (character.status == "Dead" ? .red : .gray)
        statusLabel.text = "\(character.status) - \(character.species)"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Just… no")
    }
}
