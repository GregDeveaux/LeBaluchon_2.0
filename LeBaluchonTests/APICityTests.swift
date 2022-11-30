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

    let latitude = "47.2862467"
    let longitude = "5.0414701"

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

    func test_GivenTheGoodURLRequestOfCityAPI_ThenTheGenerationOftheURLIsOk() {
        let urlEndpoint = API.EndPoint.city(latitude: latitude, longitude: longitude).url
        XCTAssertEqual(urlEndpoint, apiURL)
    }

    func test_GivenTheBadURLRequestOfCoordinatesAPI_ThenTheGenerationOftheURLIsFailed() {
        let latitude = "C3P0"
        let urlEndpoint = API.EndPoint.city(latitude: latitude, longitude: longitude).url
        XCTAssertNotEqual(urlEndpoint, apiURL)
    }

    func test_GivenTheGoodURLWithTheGoodCoordinates_WhenIAskTheCoordinates_ThenTheAnswerIsFranceAndHisCountryCodeIsFr() {
        expectation = expectation(description: "Expectation")
        let latitude = "47.2862467"
        let longitude = "5.0414701"
        let country = "France"
        let countryCode = "fr"

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


    func test_GivenIAskATranslation_WhenINotRecoverAStatusCode500_ThenMyResponseFailed() {

        baseQueryCurrency(data: MockResponseData.currencyCorrectData, response: MockResponseData.responseFailed)

        API.QueryService.shared.getData(endpoint: .city(latitude: latitude, longitude: longitude),
                                        type: API.City.Country.self) { result in
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

        API.QueryService.shared.getData(endpoint: .city(latitude: latitude, longitude: longitude),
                                        type: API.City.Country.self) { result in
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
