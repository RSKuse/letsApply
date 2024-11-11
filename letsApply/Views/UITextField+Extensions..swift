//
//  UITextField+Extensions..swift
//  letsApply
//
//  Created by Reuben Simphiwe Kuse on 2024/11/11.
//

import Foundation
import UIKit

extension UITextField {
    func dismissKeyboardOnDone() {
        self.delegate = self as? UITextFieldDelegate
        self.returnKeyType = .done
        self.addTarget(self, action: #selector(resignFirstResponder), for: .editingDidEndOnExit)
    }
}

extension UIView {
    func anchorTo(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, paddingTop: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top { topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true }
        if let leading = leading { leadingAnchor.constraint(equalTo: leading, constant: 20).isActive = true }
        if let trailing = trailing { trailingAnchor.constraint(equalTo: trailing, constant: -20).isActive = true }
    }
}
