//
//  LeBaluchonTest.swift
//  LeBaluchonTests
//
//  Created by Greg Deveaux on 28/11/2022.
//

import XCTest
@testable import LeBaluchon

final class LeBaluchonTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUser() throws {
        let user = User(name: "Robert", coordinates: CoordinatesInfo(latitude: 49.5532646, longitude: 2.9392577))
        XCTAssertEqual(user.name, "Robert")
        XCTAssertEqual(user.coordinates.latitude, 49.5532646)
        XCTAssertEqual(user.coordinates.longitude, 2.9392577)
        XCTAssertEqual(user.welcomeMessage, "Robert, what's up!")
    }

    func testcity() throws {
        let city = CityInfo(name: "Dijon", country: "France", countryCode: "fr", coordinates: CoordinatesInfo(latitude: 47.3215806, longitude: 5.0414701))
        XCTAssertEqual(city.name, "Dijon")
        XCTAssertEqual(city.country, "France")
        XCTAssertEqual(city.countryCode, "fr")
        XCTAssertEqual(city.coordinates.latitude, 47.3215806)
        XCTAssertEqual(city.coordinates.longitude, 5.0414701)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
