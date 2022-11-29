//
//  APICityTests.swift
//  LeBaluchonTests
//
//  Created by Greg Deveaux on 28/11/2022.
//

import XCTest
@testable import LeBaluchon

final class APICityTests: XCTestCase {

    var urlSession: URLSession!
    var expectation: XCTestExpectation!

    var translationAPI: API.Translation!
    let apiURL = URL(string: "https://nominatim.openstreetmap.org/reverse?format=json&lat=47.2862467&lon=5.0414701&zoom=13&addressdetails=1")

    override func setUpWithError() throws {

            // Transform URLProtocol from MockURLProtocol
        URLProtocol.registerClass(MockURLProtocol.self)

            // Setup a configuration to use our mock
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]

            // Create the URLSession configurated
        urlSession = URLSession(configuration: configuration)

            // this is the URLRequest of the API currency rescue by enum Endpoint
        let urlRequest = URLRequest(url: API.EndPoint.city(latitude: "47.2862467", longitude: "5.0414701").url)

    }

    override func tearDownWithError() throws {
            // Stop the modification of class URLProtocol
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }

    func testRequestCurrenciesGenerationIsOk() {
            // Given
        let latitude = "47.2862467"
        let longitude = "5.0414701"
            //When
        let urlEndpoint = API.EndPoint.city(latitude: latitude, longitude: longitude).url
            //Then
        XCTAssertEqual(urlEndpoint, apiURL)
    }

    func testSuccessfulResponse() {
            // Given
        expectation = expectation(description: "Expectation")
        let latitude = "47.2862467"
        let longitude = "5.0414701"
        let country = "France"
        let countryCode = "fr"
            //When
        let data = MockResponseData.cityCorrectData

        MockURLProtocol.requestHandler = { request in
            let response = MockResponseData.responseOK
            return (response, data)
        }
            //Then
        API.QueryService.shared.getData(endpoint: .city(latitude: latitude, longitude: longitude),
                                        type: API.City.Country.self) { result in
            switch result {
                case .failure(let error):
                    XCTFail(error.localizedDescription)

                case .success(let result):
                    let infoDestination = result
                    XCTAssertEqual(infoDestination.address.country, country)
                    XCTAssertEqual(infoDestination.address.countryCode, countryCode)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
