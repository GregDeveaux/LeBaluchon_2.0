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
            var latitude: String
            var longitude: String

            enum CodingKeys: String, CodingKey {
                case latitude = "lat"
                case longitude = "lon"
            }
        }

        struct Country: Decodable {
            var address: Address
            var latitude: String
            var longitude: String

            enum CodingKeys: String, CodingKey {
                case address
                case latitude = "lat"
                case longitude = "lon"
            }

            struct Address: Decodable {
                var country: String
                var countryCode: String

                enum CodingKeys: String, CodingKey {
                    case country
                    case countryCode = "country_code"
                }
            }
        }
        

    }
}
