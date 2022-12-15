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

    var coordinatesAPI: API.LocalisationCity.Coordinates!
    let apiURL = URL(string: "https://nominatim.openstreetmap.org/search?q=Dijon&format=json")

    override func setUpWithError() throws {
            // Transform URLProtocol from MockURLProtocol
        URLProtocol.registerClass(MockURLProtocol.self)

            // Setup a configuration to use our mock
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]

            // Create the URLSession configurated
        urlSession = URLSession(configuration: configuration)
    }

    override func tearDownWithError() throws {
            // Stop the modification of class URLProtocol
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }

    func test_GivenTheGoodURLRequestOfCoordinatesAPI_ThenTheGenerationOftheURLIsOk() {
        let city = "Dijon"
        let urlEndpoint = API.EndPoint.coordinates(city: city).url
        XCTAssertEqual(urlEndpoint, apiURL)
    }

    func test_GivenTheBadURLRequestOfCoordinatesAPI_ThenTheGenerationOftheURLIsFailed() {
        let city = "R2D2"
        let urlEndpoint = API.EndPoint.coordinates(city: city).url
        XCTAssertNotEqual(urlEndpoint, apiURL)
    }

    func test_GivenTheGoodURLWithACityNamedBlois_WhenIAskTheCoordinates_ThenTheAnswerIsLatitude47Point5876861AndLongitude1Point3337639() {
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
                                        type: [API.LocalisationCity.Coordinates].self) { result in
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

    func test_GivenIAskATranslation_WhenINotRecoverAStatusCode500_ThenMyResponseFailed() {

        baseQueryCurrency(data: MockResponseData.currencyCorrectData, response: MockResponseData.responseFailed)

        API.QueryService.shared.getData(endpoint: .coordinates(city: "Miami"),
                                        type: [API.LocalisationCity.Coordinates].self) { result in
            switch result {
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, "🛑 Generic error: there is not a response!")

                case .success(let result):
                    XCTAssertNil(result)
                    XCTFail("shouldn't execute this block")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func test_GivenIAskAConversion_WhenIRecoverABadData_ThenDecodeJsonDataFailed() {

        baseQueryCurrency(data: MockResponseData.mockDataFailed, response: MockResponseData.responseOK)

        API.QueryService.shared.getData(endpoint: .coordinates(city: "Tokyo"),
                                        type: [API.LocalisationCity.Coordinates].self) { result in
            XCTAssertNotNil(result)

            switch result {
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, "🛑 Interne error: not decode data!")

                case .success(let result):
                    XCTAssertNil(result)
                    XCTFail("shouldn't execute this block")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }


        // -------------------------------------------------------
        //MARK: - Methode
        // -------------------------------------------------------

    private func baseQueryCurrency(data: Data?, response: HTTPURLResponse) {
        expectation = expectation(description: "Expectation")

        let data = data

        MockURLProtocol.requestHandler = { request in
            let response = response
            return (response, data)
        }
    }
}
