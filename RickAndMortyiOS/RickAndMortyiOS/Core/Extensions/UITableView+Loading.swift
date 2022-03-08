//
//  UITableView+Loading.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 26.12.2020.
//

import Foundation
import UIKit

extension UITableView {
    func setLoading() { 
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.color = .rickBlue
        self.backgroundView = activityIndicatorView
        activityIndicatorView.startAnimating()
        self.separatorStyle = .none
    }
}
