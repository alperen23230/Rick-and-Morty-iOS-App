//
//  UINavigationController+Hero.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 23.01.2021.
//

import Foundation
import UIKit
import Hero

extension UINavigationController {
    func show(_ viewController: UIViewController, navigationAnimationType: HeroDefaultAnimationType = .autoReverse(presenting: .slide(direction: .leading))) {
        viewController.hero.isEnabled = true
        hero.isEnabled = true
        hero.navigationAnimationType = navigationAnimationType
        pushViewController(viewController, animated: true)
    }
}
