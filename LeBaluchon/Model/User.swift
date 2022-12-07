//
//  User.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 30/10/2022.
//

import Foundation

struct User {
    var name: String {
        didSet {
            userDefaults.set(name, forKey: "userName")
        }
    }
    var coordinates: CoordinatesInfo {
        didSet {
            userDefaults.set(coordinates.latitude, forKey: "userCoordinatesLatitude")
            userDefaults.set(coordinates.longitude, forKey: "userCoordinatesLongitude")
        }
    }
    var cityName: String {
        didSet {
            userDefaults.set(cityName, forKey: "userCityName")
        }
    }
    var country: String {
        didSet {
            userDefaults.set(country, forKey: "userCountry")
        }
    }
    var countryCode: String {
        didSet {
            userDefaults.set(name, forKey: "userCountryCode")
        }
    }
    var languageCode: String? {
        didSet {
            userDefaults.set(name, forKey: "userLanguageRegion")
        }
    }
    var languageRegion: String? {
        didSet {
            userDefaults.set(name, forKey: "userLanguageRegion")
        }
    }
    var currency: String? {
        didSet {
            userDefaults.set(name, forKey: "userCurrency")
        }
    }
    var currencySymbol: String? {
        didSet {
            userDefaults.set(name, forKey: "userCurrencySymbol")
        }
    }

    var welcomeMessage: String {
        let message = "\(name), what's up!"
        return message
    }

    let userDefaults = UserDefaults()
}
