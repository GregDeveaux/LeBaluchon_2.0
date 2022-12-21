//
//  LeBaluchonTest.swift
//  LeBaluchonTests
//
//  Created by Greg Deveaux on 28/11/2022.
//

import XCTest
import CoreLocation

@testable import LeBaluchon

final class LeBaluchonTest: XCTestCase {

    var loginViewController: LoginViewController!


    override func setUpWithError() throws {
        loginViewController = LoginViewController()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_User() throws {
        let user = User()
        user.name = "Robert"
        user.cityName = "Ville"
        user.latitude = 49.5532646
        user.longitude = 2.9392577
        user.countryName = "France"
        user.countryCode = "FR"
        user.languageCode = "fr"
        user.currencyCode = "euR"
        user.currencySymbol = "€"

        XCTAssertNotNil(user)

        XCTAssertEqual(user.name, "Robert")
        XCTAssertEqual(user.cityName, "Ville")
        XCTAssertEqual(user.latitude, 49.5532646)
        XCTAssertEqual(user.longitude, 2.9392577)
        XCTAssertEqual(user.countryName, "France")
        XCTAssertEqual(user.countryCode, "FR")
        XCTAssertEqual(user.languageCode, "fr")
        XCTAssertEqual(user.currencyCode, "EUR")
        XCTAssertEqual(user.currencySymbol, "€")
        XCTAssertEqual(user.welcomeMessage, "Robert, what's up!")
    }

    func test_Destination() throws {
        let destination = Destination()
        destination.cityName = "Miami"
        destination.latitude = 25.7616798
        destination.longitude = -80.1917902
        destination.countryName = "États-Unis D'amérique"
        destination.countryCode = "Us"
        destination.languageCode = "en"
        destination.currencyCode = "USD"
        destination.currencySymbol = "$"

        XCTAssertNotNil(destination)

        XCTAssertEqual(destination.cityName, "Miami")
        XCTAssertEqual(destination.countryName, "États-Unis D'amérique")
        XCTAssertEqual(destination.countryCode, "US")
        XCTAssertEqual(destination.latitude, 25.7616798)
        XCTAssertEqual(destination.longitude, -80.1917902)
        XCTAssertEqual(destination.languageCode, "en")
        XCTAssertEqual(destination.currencyCode, "USD")
        XCTAssertEqual(destination.currencySymbol, "$")
    }

    func test_Destination_Error() throws {
        let city = City()
        city.name = "Miami"

        XCTAssertEqual(city.name, "Miami")
    }

    func test_PinMap() throws {
        let pinMap = PinMap(title: "you want to go to Dijon", coordinate: CLLocationCoordinate2D(latitude: 47.3215806, longitude: 5.0414701), info: "destination")
        XCTAssertEqual(pinMap.title, "you want to go to Dijon")
        XCTAssertEqual(pinMap.coordinate.latitude, 47.3215806)
        XCTAssertEqual(pinMap.coordinate.longitude, 5.0414701)
        XCTAssertEqual(pinMap.info, "destination")
    }

    func test_UIColorHexAndRGBA() {
        let cherryHex = UIColor(hex: 0xD2042D)
        let cherryRGBA = UIColor(red: 210, green: 4, blue: 45)
        XCTAssertEqual(cherryHex, cherryRGBA)
    }

    func test_GetcheckTheUserNameExistInBase_WhenAUserNameExistsInBase_ThenTheUserNameDontChang() {
        loginViewController.user.name = "Bob"
        
        loginViewController.checkTheUserNameExistInBase()

        guard let text = loginViewController.nameTextField?.text else { return }

        XCTAssertEqual(text, "Bob")
        XCTAssertFalse(loginViewController.nameTextField.isEnabled)
    }

    func test_GivenIGiveTheDescriptionWeather_WhenIUseFunction_ThenIRecoverAArrayOfImages() {
        let description = "clear sky"
        guard let weatherDescription = WeatherDescription(rawValue: description) else { return }
        let sunrise = 1670042925
        let sunset = 1670087381
        let hourOfCountry = 1670085891

        let imagesWeather = ImagesWeather.weatherImage(for: weatherDescription, sunrise: sunrise, sunset: sunset, hourOfCountry: hourOfCountry)

        XCTAssertEqual(imagesWeather[0], "veryLittleCloud.png")
        XCTAssertEqual(imagesWeather[1], "sun.max.fill")
        XCTAssertEqual(imagesWeather[2], "perso1.pdf")
    }

    func test_GivenTheCodeLanguage_WhenICallTheLanguageByEnum_ThenIcanRescueTheCodeForAPi() {
        let language = "French"
        let frenchLanguage = Language(rawValue: language)

        XCTAssertEqual(frenchLanguage?.code, "FR")
        XCTAssertEqual(frenchLanguage?.image, "sunWithFlagFrench.png")
    }

    func test_LanguageNumber() {
        var arrayOfLanguage = [Language]()
        for language in Language.allCases {
            arrayOfLanguage.append(language)
        }

        XCTAssertNotNil(arrayOfLanguage)
        XCTAssertTrue(arrayOfLanguage.count == 27)
        XCTAssertEqual(Language.french.code, "FR")
        XCTAssertEqual(Language.english.code, "EN")
        XCTAssertEqual(Language.bulgarian.code, "BG")
        XCTAssertEqual(Language.czech.code, "CS")
        XCTAssertEqual(Language.chinese.code, "ZH")
        XCTAssertEqual(Language.dutch.code, "NL")
        XCTAssertEqual(Language.danish.code, "DA")
        XCTAssertEqual(Language.estonian.code, "ET")
        XCTAssertEqual(Language.finnish.code, "FI")
        XCTAssertEqual(Language.german.code, "DE")
        XCTAssertEqual(Language.greek.code, "EL")
        XCTAssertEqual(Language.hungarian.code, "HU")
        XCTAssertEqual(Language.italian.code, "IT")
        XCTAssertEqual(Language.indonesian.code, "ID")
        XCTAssertEqual(Language.japanese.code, "JA")
        XCTAssertEqual(Language.latvian.code, "LV")
        XCTAssertEqual(Language.lithuanian.code, "LT")
        XCTAssertEqual(Language.polish.code, "PL")
        XCTAssertEqual(Language.portuguese.code, "PT")
        XCTAssertEqual(Language.russian.code, "RU")
        XCTAssertEqual(Language.romanian.code, "RO")
        XCTAssertEqual(Language.slovak.code, "SK")
        XCTAssertEqual(Language.spanish.code, "ES")
        XCTAssertEqual(Language.swedish.code, "SV")
        XCTAssertEqual(Language.slovenian.code, "SL")
        XCTAssertEqual(Language.turkish.code, "TR")
        XCTAssertEqual(Language.ukrainian.code, "UK")

        XCTAssertEqual(Language.french.image, "sunWithFlagFrench.png")
        XCTAssertEqual(Language.english.image, "sunWithFlagEnglish.png")
        XCTAssertEqual(Language.bulgarian.image, "sunWithFlagBulgarian.png")
        XCTAssertEqual(Language.czech.image, "sunWithFlagCzech.png")
        XCTAssertEqual(Language.chinese.image, "sunWithFlagChinese.png")
        XCTAssertEqual(Language.dutch.image, "sunWithFlagDutch.png")
        XCTAssertEqual(Language.danish.image, "sunWithFlagDanish.png")
        XCTAssertEqual(Language.estonian.image, "sunWithFlagEstonian.png")
        XCTAssertEqual(Language.finnish.image, "sunWithFlagFinnish.png")
        XCTAssertEqual(Language.german.image, "sunWithFlagGerman.png")
        XCTAssertEqual(Language.greek.image, "sunWithFlagGreek.png")
        XCTAssertEqual(Language.hungarian.image, "sunWithFlagHungarian.png")
        XCTAssertEqual(Language.italian.image, "sunWithFlagItalien.png")
        XCTAssertEqual(Language.indonesian.image, "sunWithFlagIndonesian.png")
        XCTAssertEqual(Language.japanese.image, "sunWithFlagJapanese.png")
        XCTAssertEqual(Language.latvian.image, "sunWithFlagLatvian.png")
        XCTAssertEqual(Language.lithuanian.image, "sunWithFlagLithuanian.png")
        XCTAssertEqual(Language.polish.image, "sunWithFlagPolish.png")
        XCTAssertEqual(Language.portuguese.image, "sunWithFlagPortuguese.png")
        XCTAssertEqual(Language.russian.image, "sunWithFlagRussian.png")
        XCTAssertEqual(Language.romanian.image, "sunWithFlagRomanian.png")
        XCTAssertEqual(Language.slovak.image, "sunWithFlagSlovak.png")
        XCTAssertEqual(Language.spanish.image, "sunWithFlagSpanish.png")
        XCTAssertEqual(Language.swedish.image, "sunWithFlagSwedish.png")
        XCTAssertEqual(Language.slovenian.image, "sunWithFlagSlovenian.png")
        XCTAssertEqual(Language.turkish.image, "sunWithFlagTurkish.png")
        XCTAssertEqual(Language.ukrainian.image, "sunWithFlagUkrainian.png")
    }

    func test_ImagesWeather() {
        let description = "light snow"

        guard let weatherDescription = WeatherDescription(rawValue: description) else { return }
        let weatherImages = ImagesWeather.weatherImage(for: weatherDescription,
                                                       sunrise: 1671088520,
                                                       sunset: 1671118589,
                                                       hourOfCountry: 3600)

        XCTAssertEqual(weatherImages[0], "snowByNight.png")
        XCTAssertEqual(weatherImages[1], "cloud.snow.fill")
    }

    func test_PerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
