//
//  APICurrencyTest.swift
//  LeBaluchonTests
//
//  Created by Greg-Mini on 15/10/2022.
//

import XCTest
@testable import LeBaluchon

class ApiCurrencyTest: XCTestCase {

    func testGetCurrenciesShouldPostFailedCallbackIfError() {
        //Given
        let api = API.QueryService.shared
        let mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: MockResponseData.error)
        api.session = mockURLSession
        //When
        api.getQuery(endpoint: .currency(to: "USD", from: "EUR", amount: 150.00), method: .GET) { success, calculateExchangeRate in
            let expectation = XCTestExpectation(description: "Wait for a queue change")
            //Then
            XCTAssertFalse(success)
            XCTAssertNil(calculateExchangeRate)
            expectation.fulfill()
        }
//        wait(for: expectation, timeout: 0.01)
    }

    func testGetCurrenciesShouldPostFailedCallbackIfNoData() {
        //Given
        let api = API.QueryService.shared
        let mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        api.session = mockURLSession
        //When
        api.getQuery(endpoint: .currency(to: "USD", from: "EUR", amount: 150.00), method: .GET) { success, calculateExchangeRate in
            let expectation = XCTestExpectation(description: "Wait for a queue change")
            //Then
            XCTAssertFalse(success)
            XCTAssertNil(calculateExchangeRate)
            expectation.fulfill()
        }
    }

    func testGetCurrenciesShouldPostFailedCallbackIfIncorrectResponse() {
        //Given
        let api = API.QueryService.shared
        let mockURLSession = MockURLSession(data: MockResponseData.currencyCorrectData, urlResponse: MockResponseData.responseFailed, error: nil)
        api.session = mockURLSession
        //When
        api.getQuery(endpoint: .currency(to: "USD", from: "EUR", amount: 150.00), method: .GET) { success, calculateExchangeRate in
            let expectation = XCTestExpectation(description: "Wait for a queue change")
            //Then
            XCTAssertFalse(success)
            XCTAssertNil(calculateExchangeRate)
            expectation.fulfill()
        }
    }

    func testGetCurrenciesShouldPostFailedCallbackIfIncorrectData() {
        //Given
        let api = API.QueryService.shared
        let mockURLSession = MockURLSession(data: MockResponseData.mockCurrencyFailed, urlResponse: MockResponseData.responseOK, error: nil)
        api.session = mockURLSession
        //When
        api.getQuery(endpoint: .currency(to: "USD", from: "EUR", amount: 150.00), method: .GET) { success, calculateExchangeRate in
            let expectation = XCTestExpectation(description: "Wait for a queue change")
            //Then
            XCTAssertFalse(success)
            XCTAssertNil(calculateExchangeRate)
            expectation.fulfill()
        }
    }

    func testGetCurrenciesShouldPostFailedCallbackIsValid() {
        //Given
        let api = API.QueryService.shared
        let mockURLSession = MockURLSession(data: MockResponseData.currencyCorrectData, urlResponse: MockResponseData.responseOK, error: nil)
        api.session = mockURLSession
        //When
        api.getQuery(endpoint: .currency(to: "USD", from: "EUR", amount: 150.00), method: .GET) { success, calculateExchangeRate in
            let expectation = XCTestExpectation(description: "Wait for a queue change")
            let to = "USD"
            let from = "EUR"
            let amount = 150.00
            let rate = 1.02845
            let result = 154.2675
            
            //Then
            XCTAssertTrue(success)
            XCTAssertNotNil(calculateExchangeRate)

            XCTAssertEqual(from, calculateExchangeRate!.query.from)
            XCTAssertEqual(to, calculateExchangeRate!.query.to)
            XCTAssertEqual(amount, calculateExchangeRate!.query.amount)
            XCTAssertEqual(rate, calculateExchangeRate!.info.rate)
            XCTAssertEqual(result, calculateExchangeRate!.result)
            expectation.fulfill()
        }
    }
}
