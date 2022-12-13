//
//  Destination.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 13/12/2022.
//

import Foundation

struct Destination {
    var city = City()

        // -------------------------------------------------------
        // MARK: - private keys
        // -------------------------------------------------------

    private enum Keys: String {
        case cityDestinationName
        case cityDestinationLatitude
        case cityDestinationLongitude
        case cityDestinationCountry
        case cityDestinationCountryCode
        case cityDestinationLanguageCode
        case cityDestinationLanguageRegion
        case cityDestinationCurrency
        case cityDestinationCurrencySymbol
    }


        // -------------------------------------------------------
        // MARK: - save destination city by userDefaults
        // -------------------------------------------------------

    var cityName: String {
        get {
            print("🔔🟡 City user name is call: \(UserDefaults.standard.string(forKey: Keys.cityDestinationName.rawValue) ?? "No Name")")
            return UserDefaults.standard.string(forKey: Keys.cityDestinationName.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(city.name, forKey: Keys.cityDestinationName.rawValue)
            print("🔔🟢 User name is save \(city.name ?? "")")
        }
    }

    var latitude: Double {
        get {
            print("🔔🟡 City user name is call: \(UserDefaults.standard.string(forKey: Keys.cityDestinationLatitude.rawValue) ?? "No Name")")
            return UserDefaults.standard.double(forKey: Keys.cityDestinationLatitude.rawValue)
        }
        set {
            UserDefaults.standard.set(city.latitude, forKey: Keys.cityDestinationLatitude.rawValue)
            print("🔔🟢 User name is save \(city.latitude ?? 0)")
        }
    }

    var longitude: Double {
        get {
            print("🔔🟡 City user name is call: \(UserDefaults.standard.string(forKey: Keys.cityDestinationLongitude.rawValue) ?? "No Name")")
            return UserDefaults.standard.double(forKey: Keys.cityDestinationLongitude.rawValue)
        }
        set {
            UserDefaults.standard.set(city.longitude, forKey: Keys.cityDestinationLongitude.rawValue)
            print("🔔🟢 User name is save \(city.longitude ?? 0)")
        }
    }

    var country: String {
        get {
            print("🔔🟡 City user name is call: \(UserDefaults.standard.string(forKey: Keys.cityDestinationCountry.rawValue) ?? "No Name")")
            return UserDefaults.standard.string(forKey: Keys.cityDestinationCountry.rawValue) ?? "No Land"
        }
        set {
            UserDefaults.standard.set(city.country, forKey: Keys.cityDestinationCountry.rawValue.capitalized)
            print("🔔🟢 User name is save \(city.country ?? "")")
        }
    }

    var countryCode: String {
        get {
            print("🔔🟡 City user name is call: \(UserDefaults.standard.string(forKey: Keys.cityDestinationCountryCode.rawValue) ?? "No Name")")
            return UserDefaults.standard.string(forKey: Keys.cityDestinationCountryCode.rawValue) ?? "No Code"
        }
        set {
            UserDefaults.standard.set(city.countryCode, forKey: Keys.cityDestinationCountryCode.rawValue)
            print("🔔🟢 User name is save \(city.countryCode ?? "")")
        }
    }

    var languageCode: String? {
        get {
            print("🔔🟡 City user name is call: \(UserDefaults.standard.string(forKey: Keys.cityDestinationLanguageCode.rawValue) ?? "No Name")")
            return UserDefaults.standard.string(forKey: Keys.cityDestinationLanguageCode.rawValue) ?? "No L Code"
        }
        set {
            UserDefaults.standard.set(city.languageCode, forKey: Keys.cityDestinationLanguageCode.rawValue)
            print("🔔🟢 User name is save \(city.languageCode ?? "")")
        }
    }

    var languageRegion: String? {
        get {
            print("🔔🟡 City user name is call: \(UserDefaults.standard.string(forKey: Keys.cityDestinationLanguageRegion.rawValue) ?? "No Name")")
            return UserDefaults.standard.string(forKey: Keys.cityDestinationLanguageRegion.rawValue) ?? "No L Region"
        }
        set {
            UserDefaults.standard.set(city.languageRegion, forKey: Keys.cityDestinationLanguageRegion.rawValue)
            print("🔔🟢 User name is save \(city.languageRegion ?? "")")
        }
    }

    var currency: String? {
        get {
            print("🔔🟡 City user name is call: \(UserDefaults.standard.string(forKey: Keys.cityDestinationCurrency.rawValue) ?? "No Name")")
            return UserDefaults.standard.string(forKey: Keys.cityDestinationCurrency.rawValue) ?? "No Currency"
        }
        set {
            UserDefaults.standard.set(city.currency, forKey: Keys.cityDestinationCurrency.rawValue.uppercased())
            print("🔔🟢 User name is save \(city.currency ?? "")")
        }
    }

    var currencySymbol: String? {
        get {
            print("🔔🟡 City user name is call: \(UserDefaults.standard.string(forKey: Keys.cityDestinationCurrencySymbol.rawValue) ?? "No Name")")
            return UserDefaults.standard.string(forKey: Keys.cityDestinationCurrencySymbol.rawValue) ?? "No Symbol"
        }
        set {
            UserDefaults.standard.set(city.currencySymbol, forKey: Keys.cityDestinationCurrencySymbol.rawValue)
            print("🔔🟢 User name is save \(city.currencySymbol ?? "")")
        }
    }
}
