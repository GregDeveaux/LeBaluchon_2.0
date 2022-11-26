//
//  APIEndPoint.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 17/10/2022.
//

import Foundation

extension API {

        // -------------------------------------------------------
        // MARK: It's here that we create URLs used by App
        // -------------------------------------------------------

    enum EndPoint {

            // -------------------------------------------------------
            // MARK: Init Endpoints
            // -------------------------------------------------------

        case currency(to: String, from: String, amount: Double)
        case weather(city: String, units: String)
        case translation(sourceLang: String, text: String, targetLang: String)
        case flag(codeIsoCountry: String)
        case coordinates(city: String)
        case city(latitude: String, longitude: String)


            // -------------------------------------------------------
            // MARK: Base URL Endpoints
            // -------------------------------------------------------

        var url: URL {
            var components = URLComponents()
            components.scheme = "https"

            switch self {
                case .currency(let to, let from, let amount):
                    components.host = "api.apilayer.com"
                    components.path = "/fixer/convert"
                    components.queryItems = [
                        URLQueryItem(name: "to", value: to),
                        URLQueryItem(name: "from", value: from),
                        URLQueryItem(name: "amount", value: String(amount))
                    ]

                case .weather(let city, let units):
                    let appid = APIKeys.Weather.key.rawValue
                    components.host = "api.openweathermap.org"
                    components.path = "/data/2.5/weather"
                    components.queryItems = [
                        URLQueryItem(name: "q", value: city),
                        URLQueryItem(name: "units", value: units),
                        URLQueryItem(name: "appid", value: appid)
                    ]

                case .translation(let sourceLang, let text, let targetLang):
                    let appid = APIKeys.Translation.key.rawValue
                    components.host = "api-free.deepl.com"
                    components.path = "/v2/translate"
                    components.queryItems = [
                        URLQueryItem(name: "source_lang", value: sourceLang),
                        URLQueryItem(name: "text", value: text),
                        URLQueryItem(name: "target_lang", value: targetLang),
                        URLQueryItem(name: "auth_key", value: appid),
                    ]

                case .flag(let codeIsoCountry):
                    components.host = "flagcdn.com"
                    components.path = "/h40/\(codeIsoCountry.lowercased()).png"

                case .coordinates(let city):
                    components.host = "nominatim.openstreetmap.org"
                    components.path = "/search"
                    components.queryItems = [
                        URLQueryItem(name: "q", value: city),
                        URLQueryItem(name: "format", value: "json")
                    ]

                case .city(let latitude, let longitude):
                    components.host = "nominatim.openstreetmap.org"
                    components.path = "/reverse"
                    components.queryItems = [
                        URLQueryItem(name: "format", value: "json"),
                        URLQueryItem(name: "lat", value: latitude),
                        URLQueryItem(name: "lon", value: longitude),
                        URLQueryItem(name: "zoom", value: "13"),
                        URLQueryItem(name: "addressdetails", value: "1")
                    ]
            }
            return components.url!
        }


            // -------------------------------------------------------
            // MARK: Header Endpoints
            // -------------------------------------------------------

        var header: [String: String] {
            var key = ""
            var value = ""
            switch self {
                case .currency:
                    key = APIKeys.Currency.key.rawValue
                    value = APIKeys.Currency.value.rawValue
                default:
                    break
            }
            return [key: value]
        }
    }
}
