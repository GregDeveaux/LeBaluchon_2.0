//
//  City.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 30/10/2022.
//

import Foundation

struct DestinationCity {
    var name: String
    var country: String
    var countryCode: String
    var coordinates: Coordinates
}

struct Coordinates {
    var latitude: Double
    var longitude: Double
}

