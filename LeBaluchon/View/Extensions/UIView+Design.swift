//
//  UIView+Design.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 07/12/2022.
//

import UIKit

extension UIView {

    func currencyDesign() {
        layer.masksToBounds = true
        layer.cornerRadius = 8

        layer.shadowColor = CGColor(genericCMYKCyan: 50, magenta: 0, yellow: 80, black: 15, alpha: 1)
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
    }

}
