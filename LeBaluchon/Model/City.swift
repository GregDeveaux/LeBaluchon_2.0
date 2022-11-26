//
//  City.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 30/10/2022.
//

import Foundation

struct CityInfo {
    var name: String?
    var country: String
    var countryCode: String
    var coordinates: CoordinatesInfo
}

struct CoordinatesInfo {
    var latitude: Double
    var longitude: Double
}

