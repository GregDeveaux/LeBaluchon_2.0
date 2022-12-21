//
//  Destination.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 13/12/2022.
//

import Foundation

class Destination {
    var city = City()

        // -------------------------------------------------------
        // MARK: - private keys
        // -------------------------------------------------------

    private enum Keys: String {
        case cityDestinationName
        case cityDestinationLatitude
        case cityDestinationLongitude
        case cityDestinationCountryName
        case cityDestinationCountryCode
        case cityDestinationLanguageCode
        case cityDestinationCurrency
        case cityDestinationCurrencySymbol
    }


        // -------------------------------------------------------
        // MARK: - save destination city by userDefaults
        // -------------------------------------------------------

    var cityName: String {
        get {
            print("🔔🟡 Destination city name is call: \(UserDefaults.standard.string(forKey: Keys.cityDestinationName.rawValue) ?? "No Name")")
            return UserDefaults.standard.string(forKey: Keys.cityDestinationName.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue.capitalized, forKey: Keys.cityDestinationName.rawValue)
            print("🔔🟢 Destination city name is save \(newValue.capitalized)")
        }
    }

    var latitude: Double {
        get {
            print("🔔🟡 Destination city latitude is call: \(UserDefaults.standard.double(forKey: Keys.cityDestinationLatitude.rawValue))")
            return UserDefaults.standard.double(forKey: Keys.cityDestinationLatitude.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.cityDestinationLatitude.rawValue)
            print("🔔🟢 Destination city latitude is save \(newValue)")
        }
    }

    var longitude: Double {
        get {
            print("🔔🟡 Destination city longitude is call: \(UserDefaults.standard.double(forKey: Keys.cityDestinationLongitude.rawValue))")
            return UserDefaults.standard.double(forKey: Keys.cityDestinationLongitude.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.cityDestinationLongitude.rawValue)
            print("🔔🟢 Destination city longitude is save \(newValue)")
        }
    }

    var countryName: String {
        get {
            print("🔔🟡 Destination city country is call: \(UserDefaults.standard.string(forKey: Keys.cityDestinationCountryName.rawValue) ?? "No country")")
            return UserDefaults.standard.string(forKey: Keys.cityDestinationCountryName.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue.capitalized, forKey: Keys.cityDestinationCountryName.rawValue)
            print("🔔🟢 Destination city country is save \(newValue.capitalized)")
        }
    }

    var countryCode: String {
        get {
            print("🔔🟡 Destination city countryCode is call: \(UserDefaults.standard.string(forKey: Keys.cityDestinationCountryCode.rawValue) ?? "No countryCode")")
            return UserDefaults.standard.string(forKey: Keys.cityDestinationCountryCode.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue.uppercased(), forKey: Keys.cityDestinationCountryCode.rawValue)
            print("🔔🟢 Destination city countryCode is save \(newValue.uppercased())")
        }
    }

    var languageCode: String {
        get {
            print("🔔🟡 Destination city language region is call: \(UserDefaults.standard.string(forKey: Keys.cityDestinationLanguageCode.rawValue) ?? "No languageRegion")")
            return UserDefaults.standard.string(forKey: Keys.cityDestinationLanguageCode.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue.lowercased(), forKey: Keys.cityDestinationLanguageCode.rawValue)
            print("🔔🟢 Destination city language region is save \(newValue.lowercased())")
        }
    }

    var currencyCode: String {
        get {
            print("🔔🟡 Destination city currency is call: \(UserDefaults.standard.string(forKey: Keys.cityDestinationCurrency.rawValue) ?? "No Currency")")
            return UserDefaults.standard.string(forKey: Keys.cityDestinationCurrency.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue.uppercased(), forKey: Keys.cityDestinationCurrency.rawValue)
            print("🔔🟢 Destination city currency is save \(newValue.uppercased())")
        }
    }

    var currencySymbol: String {
        get {
            print("🔔🟡 Destination city currency symbol is call: \(UserDefaults.standard.string(forKey: Keys.cityDestinationCurrencySymbol.rawValue) ?? "No CurrencySymbol")")
            return UserDefaults.standard.string(forKey: Keys.cityDestinationCurrencySymbol.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.cityDestinationCurrencySymbol.rawValue)
            print("🔔🟢 Destination city currency symbol is save \(newValue)")
        }
    }
}
