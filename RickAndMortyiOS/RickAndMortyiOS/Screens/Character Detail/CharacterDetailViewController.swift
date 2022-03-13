//
//  CharacterDetailViewController.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 17.01.2021.
//

import UIKit
import SDWebImage

class CharacterDetailViewController: UIViewController {
    //UI Variables
    @UsesAutoLayout
    var characterImageView = UIImageView()
    @UsesAutoLayout
    var nameLabel = UILabel()
    @UsesAutoLayout
    private var genderLabel = UILabel()
    @UsesAutoLayout
    private var speciesLabel = UILabel()
    @UsesAutoLayout
    private var labelsStackView = UIStackView()
    //Variables
    private var character: RickAndMortyCharacter
    
    init(character: RickAndMortyCharacter) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImage()
        configureLabels()
        configureViewLayout()
        configureNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableHero()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disableHero()
    }
    
    private func configureNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        title = character.name
    }
    
    private func configureImage () {
        characterImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        guard let imageURL = URL(string: character.imageUrl) else { return }
        characterImageView.sd_setImage(with: imageURL)
        view.addSubview(characterImageView)
    }
    
    private func configureLabels() {
        nameLabel.text = "Name: \(character.name)"
        nameLabel.font = .preferredFont(forTextStyle: .title1)
        nameLabel.textColor = .rickBlue
        
        genderLabel.text = "Gender: \(character.gender)"
        genderLabel.font = .preferredFont(forTextStyle: .title2)
        genderLabel.textColor = .rickGreen
        
        speciesLabel.text = "Species: \(character.species)"
        speciesLabel.font = .preferredFont(forTextStyle: .title2)
        speciesLabel.textColor = .rickGreen
        
        labelsStackView.axis = .vertical
        labelsStackView.alignment = .leading
        labelsStackView.spacing   = 4.0
        
        labelsStackView.addArrangedSubview(nameLabel)
        labelsStackView.addArrangedSubview(genderLabel)
        labelsStackView.addArrangedSubview(speciesLabel)
        
        view.addSubview(labelsStackView)
    }
    
    private func configureViewLayout() {
        view.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            labelsStackView.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 8.0),
            labelsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0),
            labelsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0),
        ])
    }
}
