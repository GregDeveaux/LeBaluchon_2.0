//
//  City.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 30/10/2022.
//

import Foundation

struct DestinationCity {
    var name: String {
        didSet {
            userDefaults.set(name, forKey: "destinationCityName")
        }
    }
    var coordinates: CoordinatesInfo {
        didSet {
            userDefaults.set(coordinates.latitude, forKey: "destinationCoordinatesLatitude")
            userDefaults.set(coordinates.longitude, forKey: "destinationCoordinatesLongitude")
        }
    }
    var country: String {
        didSet {
            userDefaults.set(name, forKey: "destinationCountry")
        }
    }
    var countryCode: String {
        didSet {
            userDefaults.set(name, forKey: "destinationCountryCode")
        }
    }
    var languageCode: String? {
        didSet {
            userDefaults.set(name, forKey: "destinationLanguageCode")
        }
    }
    var languageRegion: String? {
        didSet {
            userDefaults.set(name, forKey: "destinationLanguageRegion")
        }
    }
    var currency: String? {
        didSet {
            userDefaults.set(name, forKey: "destinationUserCurrency")
        }
    }
    var currencySymbol: String? {
        didSet {
            userDefaults.set(name, forKey: "destinationCurrencySymbol")
        }
    }

    let userDefaults = UserDefaults()
}

struct CoordinatesInfo {
    var latitude: Double
    var longitude: Double
}

