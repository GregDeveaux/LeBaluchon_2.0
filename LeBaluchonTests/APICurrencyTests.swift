//
//  APICurrencyTests.swift
//  LeBaluchonTests
//
//  Created by Greg Deveaux on 10/10/2022.
//

import XCTest
@testable import LeBaluchon

class APICurrencyTests: XCTestCase {

        // -------------------------------------------------------
        //MARK: - Properties
        // -------------------------------------------------------

    var urlSession: URLSession!
    var expectation: XCTestExpectation!

    var currencyAPI: API.Currency!
    var endpoint: API.EndPoint!
    let apiURL = URL(string: "https://api.apilayer.com/fixer/convert?to=EUR&from=USD&amount=150.0")

    var currencyUser = "EUR"
    var currencyDestination = "USD"
    var amountTapped = 150.0


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
        let urlEndpoint = API.EndPoint.currency(to: currencyUser, from: currencyDestination, amount: amountTapped).url
        XCTAssertEqual(urlEndpoint, apiURL)
    }

    func test_GivenTheBadURLRequestOfCurrencyAPI_ThenTheGenerationOftheURLIsFailed() {
        currencyUser = "EURO"
        let urlEndpoint = API.EndPoint.currency(to: currencyUser, from: currencyDestination, amount: amountTapped).url
        XCTAssertNotEqual(urlEndpoint, apiURL)
    }

    func test_GivenTheGoodURLWithAmountOf150EUR_WhenIAskAConversionInUSD_ThenTheAnswerIs154Point2675() {
        let currencyResult = 154.2675

        baseQueryCurrency(data: MockResponseData.currencyCorrectData, response: MockResponseData.responseOK)

        API.QueryService.shared.getData(endpoint: API.EndPoint.currency(to: currencyUser, from: currencyDestination, amount: amountTapped),
                                        type: API.Currency.CalculateExchangeRate.self) { result in

            XCTAssertNotNil(result)

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

    func test_GivenIAskAConversion_WhenINotRecoverAStatusCode500_ThenMyResponseFailed() {

        baseQueryCurrency(data: MockResponseData.currencyCorrectData, response: MockResponseData.responseFailed)

        API.QueryService.shared.getData(endpoint: API.EndPoint.currency(to: currencyUser, from: currencyDestination, amount: amountTapped),
                                        type: API.Currency.CalculateExchangeRate.self) { result in
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

        API.QueryService.shared.getData(endpoint: API.EndPoint.currency(to: currencyUser, from: currencyDestination, amount: amountTapped),
                                        type: API.Currency.CalculateExchangeRate.self) { result in
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


//    func testFailedData() {
//            //When
//        currencyUser = "EURO"
//        baseQueryCurrency(data: nil, response: MockResponseData.responseOK)
//
//            //Then
//        API.QueryService.shared.getData(endpoint: API.EndPoint.currency(to: currencyUser, from: currencyDestination, amount: amountTapped),
//                                        type: API.Currency.CalculateExchangeRate.self) { result in
//            XCTAssertNil(result)
//
//            switch result {
//            case .failure(let error):
//                    XCTAssertEqual(error.localizedDescription, "🛑 Generic error: there is not datas!")
//
//            case .success(let result):
//                    XCTAssertNil(result)
//                    XCTFail("shouldn't execute this block")
//            }
//            self.expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 10.0)
//    }


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
