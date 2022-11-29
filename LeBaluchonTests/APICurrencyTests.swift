//
//  APICurrencyTests.swift
//  LeBaluchonTests
//
//  Created by Greg Deveaux on 10/10/2022.
//

import XCTest
@testable import LeBaluchon

class APICurrencyTests: XCTestCase {

    var urlSession: URLSession!
    var expectation: XCTestExpectation!

    var currencyAPI: API.Currency!
    var endpoint: API.EndPoint!
    let apiURL = URL(string: "https://api.apilayer.com/fixer/convert?to=EUR&from=USD&amount=150.0")

    var currencyUser = "EUR"
    var currencyDestination = "USD"
    var amountTapped = 150.0
    let currencyResult = 154.2675

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

    func testRequestCurrenciesGenerationIsOk() {
            //When
        let urlEndpoint = API.EndPoint.currency(to: currencyUser, from: currencyDestination, amount: amountTapped).url
            //Then
        XCTAssertEqual(urlEndpoint, apiURL)
    }

    func testSuccessfulResponse() {
            // Given
            //When
        baseQueryCurrency(data: MockResponseData.currencyCorrectData, response: MockResponseData.responseOK)

            //Then
        API.QueryService.shared.getData(endpoint: API.EndPoint.currency(to: currencyUser, from: currencyDestination, amount: amountTapped),
                                        type: API.Currency.CalculateExchangeRate.self) { result in

            XCTAssertNotNil(result)

            switch result {
            case .failure(let error):
                XCTFail(error.localizedDescription)

            case .success(let result):
                let calculateExchangeRate = result
                    XCTAssertEqual(calculateExchangeRate.result, self.currencyResult)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testFailedDecodeData() {
            //When
        baseQueryCurrency(data: MockResponseData.mockDataFailed, response: MockResponseData.responseOK)

            //Then
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
//        baseQueryCurrency(data: nil, response: MockResponseData.responseOK)
//
//            //Then
//        API.QueryService.shared.getData(endpoint: API.EndPoint.currency(to: currencyUser, from: currencyDestination, amount: amountTapped),
//                                        type: API.Currency.CalculateExchangeRate.self) { result in
//            XCTAssertNil(result)
//
//            switch result {
//            case .failure(let error):
//                    XCTAssertEqual(error.localizedDescription, "🛑 Interne error: there is not datas!")
//
//            case .success(let result):
//                    XCTAssertNil(result)
//                    XCTFail("shouldn't execute this block")
//            }
//            self.expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 10.0)
//    }


    func testFailedResponse() {
            //When
        baseQueryCurrency(data: MockResponseData.currencyCorrectData, response: MockResponseData.responseFailed)
                    //Then
        API.QueryService.shared.getData(endpoint: API.EndPoint.currency(to: currencyUser, from: currencyDestination, amount: amountTapped),
                                        type: API.Currency.CalculateExchangeRate.self) { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "🛑 Interne error: there is not a response!")

            case .success(let result):
                XCTAssertNil(result)
                XCTFail("shouldn't execute this block")
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

    private func baseQueryCurrency(data: Data?, response: HTTPURLResponse) {
        expectation = expectation(description: "Expectation")

        let data = data

        MockURLProtocol.requestHandler = { request in
            let response = response
            return (response, data)
        }
    }

}
