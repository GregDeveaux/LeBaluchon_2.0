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

    static func recoverInfoOnTheCity(named city: String, destinationCity: @escaping(DestinationCity?) -> Void) {
        let api = API()

        api.foundCoordinates(of: city) { recoverInfo in
            destinationCity(recoverInfo)
            print("-------++++**-___--------->>>>------------------\(destinationCity(recoverInfo))")
        }
    }

    private func foundCoordinates(of city: String, destinationCity: @escaping(DestinationCity) -> Void) {

        let city = city

        API.QueryService.shared.getCoordinate(endpoint: .coordinates(city: city), method: .GET) { success, coordinates in
            guard let coordinates = coordinates, success == true else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }
                let latitude = coordinates[0].latitude
                let longitude = coordinates[0].longitude

            self.foundCountryByCoordinates(latitude: latitude, longitude: longitude, destinationCity: { country in
                destinationCity(country)
            })
        }
    }

        // ...thanks to the writing of the latitude and longitude
    private func foundCountryByCoordinates(latitude: String, longitude: String, destinationCity: @escaping(DestinationCity) -> Void) {
        let latitude = latitude
        let longitude = longitude

        API.QueryService.shared.getAddress(endpoint: .city(latitude: latitude, longitude: longitude), method: .GET) { success, infoDestination in
            guard let infoDestination = infoDestination, success == true else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }
                print("----------------------------->>>>------------------\(infoDestination)")
            let city = self.createDestinationCity(destination: infoDestination)
                destinationCity(city)
        }
    }

    private func createDestinationCity(destination: API.City.Country) -> DestinationCity {

        let destinationName = ""
        let country = destination.address.country
        let countryCode = destination.address.countryCode
        let latitude = Double(destination.latitude)!
        let longitude = Double(destination.longitude)!

        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> \(String(describing: destinationName))  \(country)  \(countryCode)  \(latitude)  \(longitude) >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ")
        return DestinationCity(name: destinationName, country: country, countryCode: countryCode, coordinates: Coordinates(latitude: latitude, longitude: longitude))
    }
}
