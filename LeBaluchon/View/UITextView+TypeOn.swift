//
//  UITextView+Extensions.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 17/11/2022.
//

import UIKit

import Foundation

extension UITextView {
    func typeOn(sentence: String) {
        let characters = Array(sentence)
        var charactersIndex = 0

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.text.append(characters[charactersIndex])
                charactersIndex += 1

            if charactersIndex == characters.count {
                timer.invalidate()
            }
        }
    }
}
