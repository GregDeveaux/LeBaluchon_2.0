//
//  User.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 30/10/2022.
//

import Foundation



class User {

        // -------------------------------------------------------
        // MARK: - private keys
        // -------------------------------------------------------

    private enum Keys: String {
        case name
        case cityUserName
        case cityUserLatitude
        case cityUserLongitude
        case cityUserCountryName
        case cityUserCountryCode
        case cityUserLanguageCode
        case cityUserCurrency
        case cityUserCurrencySymbol
    }


        // -------------------------------------------------------
        // MARK: save userName
        // -------------------------------------------------------

    var name: String {
        get {
            print("🔔🟡 User name is call: \(UserDefaults.standard.string(forKey: Keys.name.rawValue) ?? "No name")")
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
            print("🔔🟡 User city name is call: \(UserDefaults.standard.string(forKey: Keys.cityUserName.rawValue) ?? "No city name")")
            return UserDefaults.standard.string(forKey: Keys.cityUserName.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue.capitalized, forKey: Keys.cityUserName.rawValue)
            print("🔔🟢 User city is save \(newValue.capitalized)")
        }
    }

    var latitude: Double {
        get {
            print("🔔🟡 User city latitude is call: \(UserDefaults.standard.double(forKey: Keys.cityUserLatitude.rawValue) )")
            return UserDefaults.standard.double(forKey: Keys.cityUserLatitude.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.cityUserLatitude.rawValue)
            print("🔔🟢 User city latitude is save \(newValue)")
        }
    }

    var longitude: Double {
        get {
            print("🔔🟡 User city longitude is call: \(UserDefaults.standard.double(forKey: Keys.cityUserLongitude.rawValue) )")
            return UserDefaults.standard.double(forKey: Keys.cityUserLongitude.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.cityUserLongitude.rawValue)
            print("🔔🟢 User city longitude is save \(newValue)")
        }
    }

    var countryName: String {
        get {
            print("🔔🟡 User city country is call: \(UserDefaults.standard.string(forKey: Keys.cityUserCountryName.rawValue) ?? "No Land")")
            return UserDefaults.standard.string(forKey: Keys.cityUserCountryName.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue.capitalized, forKey: Keys.cityUserCountryName.rawValue)
            print("🔔🟢 User city country is save \(newValue.capitalized)")
        }
    }

    var countryCode: String {
        get {
            print("🔔🟡 User city countryCode is call: \(UserDefaults.standard.string(forKey: Keys.cityUserLanguageCode.rawValue) ?? "No Code")")
            return UserDefaults.standard.string(forKey: Keys.cityUserLanguageCode.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue.uppercased(), forKey: Keys.cityUserLanguageCode.rawValue)
            print("🔔🟢 User city countryCode is save \(newValue.uppercased())")
        }
    }

    var languageCode: String {
        get {
            print("🔔🟡 User city language region is call: \(UserDefaults.standard.string(forKey: Keys.cityUserLanguageCode.rawValue) ?? "No L Region")")
            return UserDefaults.standard.string(forKey: Keys.cityUserLanguageCode.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue.lowercased(), forKey: Keys.cityUserLanguageCode.rawValue)
            print("🔔🟢 User city language region is save \(newValue.lowercased())")
        }
    }

    var currencyCode: String {
        get {
            print("🔔🟡 User city currency is call: \(UserDefaults.standard.string(forKey: Keys.cityUserCurrency.rawValue) ?? "No Currency")")
            return UserDefaults.standard.string(forKey: Keys.cityUserCurrency.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue.uppercased(), forKey: Keys.cityUserCurrency.rawValue.uppercased())
            print("🔔🟢 User city currency is save \(newValue.uppercased())")
        }
    }

    var currencySymbol: String {
        get {
            print("🔔🟡 User city currencySymbol is call: \(UserDefaults.standard.string(forKey: Keys.cityUserCurrencySymbol.rawValue) ?? "No Symbol")")
            return UserDefaults.standard.string(forKey: Keys.cityUserCurrencySymbol.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.cityUserCurrencySymbol.rawValue)
            print("🔔🟢 User city currencySymbol is save \(newValue)")
        }
    }

    var welcomeMessage: String {
        let message = "\(name), what's up!"
        return message
    }
}
