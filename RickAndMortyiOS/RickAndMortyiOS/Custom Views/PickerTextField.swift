//
//  PickerTextField.swift
//  RickAndMortyiOS
//
//  Created by Alperen Ünal on 27.12.2020.
//

import UIKit

class PickerTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
