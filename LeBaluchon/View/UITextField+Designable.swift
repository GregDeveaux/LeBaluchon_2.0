//
//  UITextField+Designable.swift
//  LeBaluchon
//
//  Created by Greg-Mini on 30/10/2022.
//

import UIKit

@IBDesignable

class TextFieldDesignable: UITextField {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
}
