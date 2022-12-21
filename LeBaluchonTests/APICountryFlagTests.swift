//
//  APICountryFlagTests.swift
//  LeBaluchonTests
//
//  Created by Greg Deveaux on 02/12/2022.
//

import XCTest
@testable import LeBaluchon

class APICountryFlagTests: XCTestCase {

        // -------------------------------------------------------
        //MARK: - Properties
        // -------------------------------------------------------

    var urlSession: URLSession!
    var expectation: XCTestExpectation!

    var currencyAPI: API.CountryFlag!
    var endpoint: API.EndPoint!
    let apiURL = URL(string: "https://flagcdn.com/h40/fr.png")

    var countryCode = "fr"

        // -------------------------------------------------------
        //MARK: - SetUp
        // -------------------------------------------------------

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


        // -------------------------------------------------------
        //MARK: - Tests
        // -------------------------------------------------------

    func test_GivenTheGoodURLRequestOfCurrencyAPI_ThenTheGenerationOftheURLIsOk() {
        let urlEndpoint = API.EndPoint.flag(codeIsoCountry: countryCode).url
        XCTAssertEqual(urlEndpoint, apiURL)
    }

    func test_GivenTheBadURLRequestOfCurrencyAPI_ThenTheGenerationOftheURLIsFailed() {
        countryCode = "France"
        let urlEndpoint = API.EndPoint.flag(codeIsoCountry: countryCode).url
        XCTAssertNotEqual(urlEndpoint, apiURL)
    }

    func test_GivenIGiveFranceAsCountry_WhenIAskAFlag_ThenIShowTheFranceFlag() {

        baseQueryCurrency(data: MockResponseData.contryFlagImage, response: MockResponseData.responseOK)

        API.QueryService.shared.getFlag(endpoint: .flag(codeIsoCountry: self.countryCode), method: .GET) { countryFlag in
            DispatchQueue.main.async {
                XCTAssertNotNil(countryFlag)
                XCTAssertEqual((self.countryCode + ".png").data(using: .utf8)!, countryFlag)
            }

            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func test_GivenResponseError_WhenIAskAFlag_ThenPrintError() {

        baseQueryCurrency(data: MockResponseData.mockDataFailed, response: MockResponseData.responseFailed)

        API.QueryService.shared.getFlag(endpoint: .flag(codeIsoCountry: self.countryCode), method: .GET) { countryFlag in

            DispatchQueue.main.async {
                XCTAssertNil(countryFlag)
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
