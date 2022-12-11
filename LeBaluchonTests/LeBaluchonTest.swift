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
        let user = User(name:"Robert", coordinates: CoordinatesInfo(latitude: 49.5532646, longitude: 2.9392577), cityName: "", country: "", countryCode: "")
        XCTAssertEqual(user.name, "Robert")
        XCTAssertEqual(user.coordinates.latitude, 49.5532646)
        XCTAssertEqual(user.coordinates.longitude, 2.9392577)
        XCTAssertEqual(user.welcomeMessage, "Robert, what's up!")
    }

    func test_City() throws {
        let city = DestinationCity(name: "Dijon", coordinates: CoordinatesInfo(latitude: 47.3215806, longitude: 5.0414701), country: "France", countryCode: "fr")
        XCTAssertEqual(city.name, "Dijon")
        XCTAssertEqual(city.country, "France")
        XCTAssertEqual(city.countryCode, "fr")
        XCTAssertEqual(city.coordinates.latitude, 47.3215806)
        XCTAssertEqual(city.coordinates.longitude, 5.0414701)
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
        loginViewController.userDefaults.set("Bob", forKey: "userName")
        
        loginViewController.checkTheUserNameExistInBase()

        guard let text = loginViewController.nameTextField?.text else { return }

        XCTAssertEqual(text, "Bob")
        XCTAssertFalse(loginViewController.nameTextField.isEnabled)
    }

    func test_GetDestinationCitySavedByUserDefaults_WhenIWantToRecoverMyDestination_ThenIFoundTheGoodDestinationName() {
        loginViewController.userDefaults.set("Miami", forKey: "destinationCity")

        XCTAssertEqual("Miami", loginViewController.userDefaults.string(forKey: "destinationCity"))
    }

//    func test_GivenIWriteAUserNameAndADestinationCityOK_WhenIPushTheButtonLetsGo_ThenTheLetsGoButtonIsActived() {
//        loginViewController.nameTextField?.text = "Bob"
//        loginViewController.destinationTextField?.text = "BikiniBottom"
//
//        loginViewController.letsGoButton?.sendActions(for: .touchUpInside)
//
//        XCTAssertTrue(loginViewController.validateEntryTextFields)
//    }

    func test_GivenIWriteOnlyADestinationCityOK_WhenIPushTheButtonLetsGo_ThenTheLetsGoButtonIsNotActived() {
        loginViewController.destinationTextField?.text = "BikiniBottom"
        let message = "please enter an username"

        loginViewController.letsGoButton?.sendActions(for: .touchUpInside)

        XCTAssertFalse(loginViewController.validateEntryTextFields)
    }

    func test_GivenIWriteOnlyAUsernameOK_WhenIPushTheButtonLetsGo_ThenTheLetsGoButtonIsNotActived() {
        loginViewController.nameTextField?.text = "Patrick"
        let message = "please enter an username"

        loginViewController.letsGoButton?.sendActions(for: .touchUpInside)

        XCTAssertFalse(loginViewController.validateEntryTextFields)
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

//    func test_GivenTheCitySaved_WhenICallTheCity_ThenIRescueTheDatasByUserDefault() {
//        let cityname = "Madrid"
//        let latitude = 40.4167754
//        let longitude = -3.7037902
//        let country = "Spain"
//        let countryCode = "ES"
//        let userDefaults = UserDefaults()
//
//        let city = DestinationCity(name: cityname, coordinates: CoordinatesInfo(latitude: latitude, longitude: longitude), country: country , countryCode: countryCode)
//
//        XCTAssertEqual(cityname, userDefaults.string(forKey: "destinationCityName"))
//
//    }

    func test_PerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
