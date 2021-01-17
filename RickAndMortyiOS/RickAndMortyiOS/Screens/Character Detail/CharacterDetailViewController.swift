//
//  CharacterDetailViewController.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 17.01.2021.
//

import UIKit
import SDWebImage

class CharacterDetailViewController: UIViewController {
    
    var character: Character
    
    @UsesAutoLayout
    var characterImageView = UIImageView()
    
    init(character: Character) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImage()
        configureViewLayout()
        configureNavBar()
        
        
    }
    
    private func configureNavBar() {
       // navigationController?.navigationBar.prefersLargeTitles = false
        title = character.name
    }
    
    private func configureImage () {
       
        characterImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        guard let imageURL = URL(string: character.imageURL) else { return }
        characterImageView.sd_setImage(with: imageURL)
        view.addSubview(characterImageView)
        
    }
    
    private func configureViewLayout() {
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: view.topAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
}
