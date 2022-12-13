//
//  User.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 30/10/2022.
//

import Foundation



struct User {

        // -------------------------------------------------------
        // MARK: - private keys
        // -------------------------------------------------------

    private enum Keys: String {
        case name
        case cityUserName
        case cityUserLatitude
        case cityUserLongitude
        case cityUserCountry
        case cityUserCountryCode
        case cityUserLanguageCode
        case cityUserLanguageRegion
        case cityUserCurrency
        case cityUserCurrencySymbol
    }


        // -------------------------------------------------------
        // MARK: save userName
        // -------------------------------------------------------

    var name: String {
        get {
            print("🔔🟡 User name is call: \(UserDefaults.standard.string(forKey: Keys.name.rawValue) ?? "No Name")")
            return UserDefaults.standard.string(forKey: Keys.name.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.name.rawValue)
            print("🔔🟢 User name is save \(newValue)")
        }
    }

    var city = City()


        // -------------------------------------------------------
        // MARK: - save user city by userDefaults
        // -------------------------------------------------------

    var cityName: String {
        get {
            print("🔔🟡 City user name is call: \(UserDefaults.standard.string(forKey: Keys.cityUserName.rawValue) ?? "No Name")")
            return UserDefaults.standard.string(forKey: Keys.cityUserName.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(city.name, forKey: Keys.cityUserName.rawValue)
            print("🔔🟢 User name is save \(city.name ?? "")")
        }
    }

    var latitude: Double {
        get {
            print("🔔🟡 City user name is call: \(UserDefaults.standard.string(forKey: Keys.cityUserLatitude.rawValue) ?? "No Name")")
            return UserDefaults.standard.double(forKey: Keys.cityUserLatitude.rawValue)
        }
        set {
            UserDefaults.standard.set(city.latitude, forKey: Keys.cityUserLatitude.rawValue)
            print("🔔🟢 User name is save \(city.latitude ?? 0)")
        }
    }

    var longitude: Double {
        get {
            print("🔔🟡 City user name is call: \(UserDefaults.standard.string(forKey: Keys.cityUserLongitude.rawValue) ?? "No Name")")
            return UserDefaults.standard.double(forKey: Keys.cityUserLongitude.rawValue)
        }
        set {
            UserDefaults.standard.set(city.longitude, forKey: Keys.cityUserLongitude.rawValue)
            print("🔔🟢 User name is save \(city.longitude ?? 0)")
        }
    }

    var country: String {
        get {
            print("🔔🟡 City user name is call: \(UserDefaults.standard.string(forKey: Keys.cityUserCountry.rawValue) ?? "No Name")")
            return UserDefaults.standard.string(forKey: Keys.cityUserCountry.rawValue) ?? "No Land"
        }
        set {
            UserDefaults.standard.set(city.country, forKey: Keys.cityUserCountry.rawValue.capitalized)
            print("🔔🟢 User name is save \(city.country ?? "")")
        }
    }

    var countryCode: String {
        get {
            print("🔔🟡 City user name is call: \(UserDefaults.standard.string(forKey: Keys.cityUserLanguageCode.rawValue) ?? "No Name")")
            return UserDefaults.standard.string(forKey: Keys.cityUserLanguageCode.rawValue) ?? "No Code"
        }
        set {
            UserDefaults.standard.set(city.countryCode, forKey: Keys.cityUserLanguageCode.rawValue)
            print("🔔🟢 User name is save \(city.countryCode ?? "")")
        }
    }

    var languageCode: String? {
        get {
            print("🔔🟡 City user name is call: \(UserDefaults.standard.string(forKey: Keys.cityUserLanguageCode.rawValue) ?? "No Name")")
            return UserDefaults.standard.string(forKey: Keys.cityUserLanguageCode.rawValue) ?? "No L Code"
        }
        set {
            UserDefaults.standard.set(city.languageCode, forKey: Keys.cityUserLanguageCode.rawValue)
            print("🔔🟢 User name is save \(city.languageCode ?? "")")
        }
    }

    var languageRegion: String? {
        get {
            print("🔔🟡 City user name is call: \(UserDefaults.standard.string(forKey: Keys.cityUserLanguageRegion.rawValue) ?? "No Name")")
            return UserDefaults.standard.string(forKey: Keys.cityUserLanguageRegion.rawValue) ?? "No L Region"
        }
        set {
            UserDefaults.standard.set(city.languageRegion, forKey: Keys.cityUserLanguageRegion.rawValue)
            print("🔔🟢 User name is save \(city.languageRegion ?? "")")
        }
    }

    var currency: String? {
        get {
            print("🔔🟡 City user name is call: \(UserDefaults.standard.string(forKey: Keys.cityUserCurrency.rawValue) ?? "No Name")")
            return UserDefaults.standard.string(forKey: Keys.cityUserCurrency.rawValue) ?? "No Currency"
        }
        set {
            UserDefaults.standard.set(city.currency, forKey: Keys.cityUserCurrency.rawValue.uppercased())
            print("🔔🟢 User name is save \(city.currency ?? "")")
        }
    }

    var currencySymbol: String? {
        get {
            print("🔔🟡 City user name is call: \(UserDefaults.standard.string(forKey: Keys.cityUserCurrencySymbol.rawValue) ?? "No Name")")
            return UserDefaults.standard.string(forKey: Keys.cityUserCurrencySymbol.rawValue) ?? "No Symbol"
        }
        set {
            UserDefaults.standard.set(city.currencySymbol, forKey: Keys.cityUserCurrencySymbol.rawValue)
            print("🔔🟢 User name is save \(city.currencySymbol ?? "")")
        }
    }

    var welcomeMessage: String {
        let message = "\(name), what's up!"
        return message
    }
}
