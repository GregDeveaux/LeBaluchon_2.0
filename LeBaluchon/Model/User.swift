//
//  User.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 30/10/2022.
//

import Foundation

struct User {
    var name: String = ""
    var coordinates: Coordinates

    func hello(sourceLang: String, targetLang: String) -> String {
        var message = "\(name), what's up!"
        API.translate(sentence: message, sourceLang: sourceLang, targetLang: sourceLang, sentenceTranslate: { text in
            message = text
        })
        return message
    }
}
