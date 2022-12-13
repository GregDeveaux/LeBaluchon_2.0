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

    enum LocalisationCity {
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

        static func recoverInfoOnTheCity(named city: String, completion: @escaping (City?) -> Void) {
            API.LocalisationCity.foundCoordinates(of: city) { recoverInfo in
                completion(recoverInfo)
            }
        }

        static private func foundCoordinates(of city: String, completion: @escaping(City?) -> Void) {

            QueryService.shared.getData(endpoint: .coordinates(city: city),
                                        type: [LocalisationCity.Coordinates].self) { results in
                switch results {
                    case .failure(let error):
                        print(error.localizedDescription)

                    case .success(let results):
                        let coordinates = results

                        guard let latitude = coordinates.first?.latitude,
                              let longitude = coordinates.first?.longitude else { return }
                        print("✅ API COORDINATES: latitude of the destination: \(latitude)")
                        print("✅ API COORDINATES: longitude of the destination: \(longitude)")

                        API.LocalisationCity.foundCountryByCoordinates(latitude: latitude, longitude: longitude) { country in
                            completion(country)
                        }
                }
            }
        }

            // ...thanks to the writing of the latitude and longitude
        static func foundCountryByCoordinates(latitude: String, longitude: String, completion: @escaping(City?) -> Void) {

            QueryService.shared.getData(endpoint: .city(latitude: latitude, longitude: longitude),
                                        type: LocalisationCity.Country.self) { result in
                switch result {
                    case .failure(let error):
                        print(error.localizedDescription)

                    case .success(let result):
                        let city = result
                        completion(createInfoOfCity(city))

                        print("✅ API COUNTRY: the found city is \(city.address.city ?? "Nothing")")
                }
            }
        }


            // -------------------------------------------------------
            // MARK: - create City info
            // -------------------------------------------------------

        static private func createInfoOfCity(_ cityInfo: API.LocalisationCity.Country) -> City {

            let city = City()

            city.name = {
                var name = ""
                if let city = cityInfo.address.city {
                    name = city
                }
                else if let town = cityInfo.address.town {
                    name = town
                }
                else if let village = cityInfo.address.village {
                    name = village
                }
                return name
            }()

            city.country = cityInfo.address.country
            city.countryCode = cityInfo.address.countryCode
            city.latitude = Double(cityInfo.latitude)!
            city.longitude = Double(cityInfo.longitude)!

            return city
        }
    }
}
