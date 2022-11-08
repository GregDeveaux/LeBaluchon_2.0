//
//  User.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 30/10/2022.
//

import Foundation

struct User {
    var name: String
    var coordinates: Coordinates

    func hello() -> String {
        var message = "\(name), what's up!"

        message = API.translate(sentence: message, sourceLang: "EN", targetLang: "FR")

        return message
    }
}
