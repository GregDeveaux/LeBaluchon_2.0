//
//  UIColor+Hex.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 13/10/2022.
//

import UIKit

    //MARK: Init color with Hex name
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }

        //MARK: Flat colors of app
        // For background login page
    static let blueElectric = UIColor.init(hex: 0x4852FF)
    static let blueSky = UIColor.init(hex: 0x2E77FF)

        // For background meteo page
    static let blueNightUp = UIColor.init(hex: 0x341A5E)
    static let blueNightDown = UIColor.init(hex: 0x1C4478)

        // For background currency page
    static let greenAurora = UIColor.init(hex: 0x6FFCAF)

        // For background translation page
    static let pinkFlash = UIColor.init(hex: 0xFF5F71)
    static let pinkGranada = UIColor.init(hex: 0xFF5053)



}





