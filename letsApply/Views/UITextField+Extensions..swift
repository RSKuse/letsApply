//
//  UITextField+Extensions..swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/11.
//

import Foundation
import UIKit

extension UITextField {
    func configureTextField(placeholder: String, keyboardType: UIKeyboardType = .default, isSecure: Bool = false) {
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecure
        self.borderStyle = .roundedRect
        self.autocapitalizationType = .none // Disable auto-capitalization
        self.returnKeyType = .done // Enable "Done" key
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
