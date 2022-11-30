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
        let user = User(name: "Robert", coordinates: CoordinatesInfo(latitude: 49.5532646, longitude: 2.9392577))
        XCTAssertEqual(user.name, "Robert")
        XCTAssertEqual(user.coordinates.latitude, 49.5532646)
        XCTAssertEqual(user.coordinates.longitude, 2.9392577)
        XCTAssertEqual(user.welcomeMessage, "Robert, what's up!")
    }

    func test_City() throws {
        let city = CityInfo(name: "Dijon", country: "France", countryCode: "fr", coordinates: CoordinatesInfo(latitude: 47.3215806, longitude: 5.0414701))
        XCTAssertEqual(city.name, "Dijon")
        XCTAssertEqual(city.country, "France")
        XCTAssertEqual(city.countryCode, "fr")
        XCTAssertEqual(city.coordinates.latitude, 47.3215806)
        XCTAssertEqual(city.coordinates.longitude, 5.0414701)
    }

    func test_PinMap() throws {
        let pinMap = PinMap(title: "you want to go Dijon", coordinate: CLLocationCoordinate2D(latitude: 47.3215806, longitude: 5.0414701), info: "destination")
        XCTAssertEqual(pinMap.title, "you want to go Dijon")
        XCTAssertEqual(pinMap.coordinate.latitude, 47.3215806)
        XCTAssertEqual(pinMap.coordinate.longitude, 5.0414701)
        XCTAssertEqual(pinMap.info, "destination")
    }

    func test_UIColorHexAndRGBA() {
        let cherryHex = UIColor(hex: 0xD2042D)
        let cherryRGBA = UIColor(red: 210, green: 4, blue: 45)
        XCTAssertEqual(cherryHex, cherryRGBA)
    }

//    func test_GetWriteMyUserName_WhenIPushTheButtonValidate_ThenNothingHappensAndPresentAlert() {
//        loginViewController.nameTextField = "Bob"
//
//        
//    }

    func test_SavingUserNameByUserDefaults() {
        loginViewController.userDefaults.set("Miami", forKey: "destinationCity")

        XCTAssertEqual("Miami", loginViewController.userDefaults.string(forKey: "destinationCity"))
    }

    func test_PerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
