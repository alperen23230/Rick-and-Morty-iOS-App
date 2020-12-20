//
//  UICollectionView+EmptyMessage.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 20.12.2020.
//

import Foundation
import UIKit

extension UICollectionView {
    func setEmptyMessage(message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .systemGray2
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
