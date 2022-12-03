//
//  APICityCoordinates.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 05/11/2022.
//

import Foundation

extension API {

        // -------------------------------------------------------
        // MARK: - parse Json
        // -------------------------------------------------------

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
                var village: String?
                var city: String?
                var town: String?
                var displayName: String?
                var country: String
                var countryCode: String

                enum CodingKeys: String, CodingKey {
                    case village
                    case city
                    case town
                    case displayName = "display_name"
                    case country
                    case countryCode = "country_code"
                }
            }
        }


            // -------------------------------------------------------------
            // MARK: - recover coordinates, name country and code country...
            // -------------------------------------------------------------
            // ...thanks to the writing of the destination by the destinationTextField

        static func recoverInfoOnTheCity(named city: String, completion: @escaping (CityInfo?) -> Void) {
            API.City.foundCoordinates(of: city) { recoverInfo in
                completion(recoverInfo)
            }
        }

        static private func foundCoordinates(of city: String, completion: @escaping(CityInfo) -> Void) {

            QueryService.shared.getData(endpoint: .coordinates(city: city),
                                        type: [City.Coordinates].self) { results in
                switch results {
                    case .failure(let error):
                        print(error.localizedDescription)

                    case .success(let results):
                        let coordinates = results

                        guard let latitude = coordinates.first?.latitude,
                              let longitude = coordinates.first?.longitude else { return }
                        print("✅ latitude of the destination: \(latitude)")
                        print("✅ longitude of the destination: \(longitude)")

                        API.City.foundCountryByCoordinates(latitude: latitude, longitude: longitude) { country in
                            completion(country)
                        }
                }
            }
        }

            // ...thanks to the writing of the latitude and longitude
        static func foundCountryByCoordinates(latitude: String, longitude: String, completion: @escaping(CityInfo) -> Void) {

            QueryService.shared.getData(endpoint: .city(latitude: latitude, longitude: longitude),
                                        type: City.Country.self) { result in
                switch result {
                    case .failure(let error):
                        print(error.localizedDescription)

                    case .success(let result):
                        let infoDestination = result

                        let city = createDestinationCity(destination: infoDestination)
                        completion(city)
                        print("✅ the found city is \(city)")
                }
            }
        }


            // -------------------------------------------------------
            // MARK: - create City info
            // -------------------------------------------------------

        static private func createDestinationCity(destination: API.City.Country) -> CityInfo {

            let name: String = {
                var name = ""
                if let city = destination.address.city {
                    name = city
                }
                else if let town = destination.address.town {
                    name = town
                }
                else if let village = destination.address.village {
                    name = village
                }
                return name
            }()

            let country = destination.address.country
            let countryCode = destination.address.countryCode
            let latitude = Double(destination.latitude)!
            let longitude = Double(destination.longitude)!

            return CityInfo(name: name, country: country, countryCode: countryCode, coordinates: CoordinatesInfo(latitude: latitude, longitude: longitude))
        }
    }
}
