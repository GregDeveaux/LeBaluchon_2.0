//
//  APIWeather.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 22/10/2022.
//

import Foundation
import UIKit

extension API {
    enum Weather {

        struct DataForCity: Decodable {
            let name: String
            let weather: [Weather]
            let main: Main
            let visibility: Int
            let wind: Wind?
            let clouds: Clouds?
            let rain: Rain?
            let snow: Snow?
            let sys: Sys
            let date: Int

            enum CodingKeys: String, CodingKey {
                case name
                case weather
                case main
                case visibility
                case wind
                case clouds
                case rain
                case snow
                case sys
                case date = "dt"
            }
        }

        struct Weather: Decodable {
            var id: Int
            var main: String
            var description: String
        }

        struct Main: Decodable {
            let temp: Double
            let feelsLike: Double
            let tempMin: Double
            let tempMax: Double
            let pressure: Int
            let humidity: Int
            let seaLevel: Int?
            let groundLevel: Int?

            enum CodingKeys: String, CodingKey {
                case temp
                case feelsLike = "feels_like"
                case tempMin = "temp_min"
                case tempMax = "temp_max"
                case pressure
                case humidity
                case seaLevel = "sea_level"
                case groundLevel = "grnd_level"
            }
        }

        struct Wind: Decodable {
            let speed: Double
            let deg: Int
            let gust: Int?
        }

        struct Clouds: Decodable {
            // Cloudiness, %
            let all: Int
        }

        struct Rain: Decodable {
            let oneHour: Int
            let threeHour: Int

            enum CodingKeys: String, CodingKey {
                case oneHour = "1h"
                case threeHour = "3h"
            }
        }

        struct Snow: Decodable {
            let oneHour: Double
            let threeHour: Double?

            enum CodingKeys: String, CodingKey {
                case oneHour = "1h"
                case threeHour = "3h"
            }
        }

        struct Sys: Decodable {
            let country: String
            let sunrise: Int
            let sunset: Int
        }
    }
}
