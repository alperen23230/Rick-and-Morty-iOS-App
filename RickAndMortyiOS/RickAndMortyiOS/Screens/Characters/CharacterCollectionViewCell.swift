//
//  CharacterCollectionViewCell.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 6.12.2020.
//

import UIKit
import SDWebImage
import Hero
import TinyConstraints

final class CharacterCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = "CharacterCollectionViewCell"
    
    private let characterImageView = UIImageView()
    private let nameLabel = UILabel()
    private let labelsVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        return stackView
    }()
    private let statusHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.alignment = .center
        return stackView
    }()
    private let statusLabel = UILabel()
    private let statusImageView = UIImageView(image: SFSymbols.statusSymbol)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Just… no")
    }
    
    private func addSubviews() {
        contentView.addSubview(characterImageView)
        characterImageView.edgesToSuperview(excluding: .bottom, insets: .left(8) + .right(8) + .top(8))
        characterImageView.aspectRatio(1)
        
        contentView.addSubview(labelsVerticalStackView)
        labelsVerticalStackView.topToBottom(of: characterImageView).constant = 8
        labelsVerticalStackView.edgesToSuperview(excluding: [.top, .bottom], insets: .left(8) + .right(8))
        
        labelsVerticalStackView.addArrangedSubview(nameLabel)
        labelsVerticalStackView.addArrangedSubview(statusHorizontalStackView)
        
        statusHorizontalStackView.addArrangedSubview(statusImageView)
        statusImageView.size(.init(width: 8, height: 8))
        statusHorizontalStackView.addArrangedSubview(statusLabel)
    }
    
    private func configureContents() {
        layer.cornerRadius = 10
        clipsToBounds = true
        contentView.backgroundColor = .rickBlue
        
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        nameLabel.textColor = .white
        
        statusLabel.font = .preferredFont(forTextStyle: .callout)
        statusLabel.adjustsFontSizeToFitWidth = true
        statusLabel.textColor = .secondaryLabel
        
        characterImageView.clipsToBounds = true
        characterImageView.layer.cornerRadius = 10
        characterImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
    }
    
    func set(with character: RickAndMortyCharacter) {
        characterImageView.heroID = character.uuid.uuidString
        nameLabel.heroID = character.name
        nameLabel.text = character.name
        statusImageView.tintColor = character.statusColor
        statusLabel.text = "\(character.status.rawValue) - \(character.species)"
        guard let imageURL = URL(string: character.imageUrl) else { return }
        characterImageView.sd_setImage(with: imageURL)
    }
}
