//
//  APICurrencyTests.swift
//  LeBaluchonTests
//
//  Created by Greg Deveaux on 10/10/2022.
//

import XCTest
@testable import LeBaluchon

class APICurrencyTests: XCTestCase {

        // Create instance API
    var currencyAPI: API.Currency!
    var expectation: XCTestExpectation!
    let apiURL = URL(string: "https://api.apilayer.com/fixer/convert?to=EUR&from=USD&amount=150.0")

    override func setUpWithError() throws {

            // Transform URLProtocol from MockURLProtocol
        URLProtocol.registerClass(MockURLProtocol.self)

            // Setup a configuration to use our mock
       let configuration = URLSessionConfiguration.ephemeral
       configuration.protocolClasses = [MockURLProtocol.self]

            // Create the URLSession configurated
        let urlSession = URLSession.init(configuration: configuration)

            // this is the URLRequest of the API currency rescue by enum Endpoint
        let request = URLRequest(url: API.EndPoint.currency(to: "", from: "", amount: 0).url)

    }

    override func tearDownWithError() throws {
            // Stop the modification of class URLProtocol
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }

    func testRequestCurrenciesGenerationIsOk() {
            // Given
        let currencyUser = "EUR"
        let currencyDestination = "USD"
        let amountTapped = 150.0
            //When
        let urlEndpoint = API.EndPoint.currency(to: currencyUser, from: currencyDestination, amount: amountTapped).url
            //Then
        XCTAssertEqual(urlEndpoint, apiURL)
    }

    func testSuccessfulResponse() {
            // Given
        expectation = expectation(description: "Expectation")
        let currencyResult = 154.2675
            //When
        let data = MockResponseData.currencyCorrectData

        MockURLProtocol.requestHandler = { request in
            let response = MockResponseData.responseOK
            return (response, data)
        }
            //Then
        API.QueryService.shared.getData(endpoint: .currency(to: "EUR", from: "USD", amount: 150.0),
                                        type: API.Currency.CalculateExchangeRate.self) { result in
            switch result {
            case .failure(let error):
                XCTFail(error.localizedDescription)

            case .success(let result):
                let calculateExchangeRate = result
                    XCTAssertEqual(calculateExchangeRate.result, currencyResult)
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
