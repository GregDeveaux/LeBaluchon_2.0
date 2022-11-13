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

    var welcomeMessage: String {
        let message = "\(name), what's up!"
        return message
    }
}
