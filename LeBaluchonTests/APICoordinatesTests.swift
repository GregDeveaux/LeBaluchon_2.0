//
//  APICoordinatesTests.swift
//  LeBaluchonTests
//
//  Created by Greg Deveaux on 28/11/2022.
//

import XCTest
@testable import LeBaluchon

final class APICoordinatesTests: XCTestCase {

    var urlSession: URLSession!
    var expectation: XCTestExpectation!

    var coordinatesAPI: API.City.Coordinates!
    let apiURL = URL(string: "https://nominatim.openstreetmap.org/search?q=Dijon&format=json")

    override func setUpWithError() throws {
            // Transform URLProtocol from MockURLProtocol
        URLProtocol.registerClass(MockURLProtocol.self)

            // Setup a configuration to use our mock
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]

            // Create the URLSession configurated
        urlSession = URLSession(configuration: configuration)

            // this is the URLRequest of the API currency rescue by enum Endpoint
        let urlRequest = URLRequest(url: API.EndPoint.coordinates(city: "Lille").url)

    }

    override func tearDownWithError() throws {
            // Stop the modification of class URLProtocol
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }

    func testRequestCurrenciesGenerationIsOk() {
            // Given
        let city = "Dijon"
            //When
        let urlEndpoint = API.EndPoint.coordinates(city: city).url
            //Then
        XCTAssertEqual(urlEndpoint, apiURL)
    }

    func testSuccessfulResponse() {
            // Given
        expectation = expectation(description: "Expectation")
        let city = "Blois"
        let latitude = "47.5876861"
        let longitude = "1.3337639"
            //When
        let data = MockResponseData.coordinatesCorrectData

        MockURLProtocol.requestHandler = { request in
            let response = MockResponseData.responseOK
            return (response, data)
        }
            //Then
        API.QueryService.shared.getData(endpoint: .coordinates(city: city),
                                        type: [API.City.Coordinates].self) { result in
            switch result {
                case .failure(let error):
                    XCTFail(error.localizedDescription)

                case .success(let result):
                    let destinationInfo = result
                    XCTAssertEqual(destinationInfo.first?.latitude, latitude)
                    XCTAssertEqual(destinationInfo.first?.longitude, longitude)
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
