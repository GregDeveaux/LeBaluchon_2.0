//
//  Person.swift
//  LeBaluchon
//
//  Created by Greg-Mini on 30/10/2022.
//

import Foundation

struct Person {
    let firstName: String
    let coordinates: [Coordinates]

    struct Coordinates {
        var lattitude: String
        var longitude: String
    }
}
