//
//  APICityCoordinates.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 05/11/2022.
//

import Foundation

extension API {

    enum City {
        struct Coordinates: Decodable {
            var lattitude: String
            var longitude: String

            enum CodingKeys: String, CodingKey {
                case lattitude = "lat"
                case longitude = "lon"
            }
        }

        struct Adress: Decodable {
            var town: String
            var county: String
            var state: String
            var postcode: String
            var country: String
            var countryCode: String

            enum CodingKeys: String, CodingKey {
                case town
                case county
                case state
                case postcode
                case country
                case countryCode = "country_code"
            }
        }
    }
}
