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

        // MARK: recover coordinates, name country and code country...
        // ...thanks to the writing of the destination by the destinationTextField

    static func recoverInfoOnTheCity(named city: String, completion: @escaping (DestinationCity?) -> Void) {
        let api = API()

        api.foundCoordinates(of: city) { recoverInfo in
            completion(recoverInfo)
        }
    }

    private func foundCoordinates(of city: String, completion: @escaping(DestinationCity) -> Void) {

        API.QueryService.shared.getCoordinate(endpoint: .coordinates(city: city),
                                              method: .GET) { success, coordinates in
            guard let coordinates = coordinates, success == true else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }

            guard let latitude = coordinates.first?.latitude,
                  let longitude = coordinates.first?.longitude else { return }

            self.foundCountryByCoordinates(latitude: latitude, longitude: longitude, completion: { country in
                completion(country)
            })
        }
    }

        // ...thanks to the writing of the latitude and longitude
    private func foundCountryByCoordinates(latitude: String, longitude: String, completion: @escaping(DestinationCity) -> Void) {

        API.QueryService.shared.getAddress(endpoint: .city(latitude: latitude, longitude: longitude),
                                           method: .GET) { success, infoDestination in
            guard let infoDestination = infoDestination, success == true else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }

            let city = self.createDestinationCity(destination: infoDestination)
            completion(city)
        }
    }

    private func createDestinationCity(destination: API.City.Country) -> DestinationCity {

        let country = destination.address.country
        let countryCode = destination.address.countryCode
        let latitude = Double(destination.latitude)!
        let longitude = Double(destination.longitude)!

        return DestinationCity(country: country, countryCode: countryCode, coordinates: Coordinates(latitude: latitude, longitude: longitude))
    }
}
