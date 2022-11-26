//
//  APICurrencyTest.swift
//  LeBaluchonTests
//
//  Created by Greg-Mini on 15/10/2022.
//

import XCTest
@testable import LeBaluchon

class ApiCurrencyTest: XCTestCase {

    let api = API.QueryService.shared

    func testGetCurrenciesShouldPostFailedCallbackIfError() {
        //Given
        setupAPICurrency(data: nil, url: nil, error: MockResponseData.error)
        //When
        api.getData(endpoint: .currency(to: "USD", from: "EUR", amount: 150.00), type: API.Currency.CalculateExchangeRate.self) { result in
            switch result {
                case .failure(let error):
                    XCTAssertThrowsError(MockResponseData.error)
                    XCTAssertNil(error)

                case .success(let result):
                    let expectation = XCTestExpectation(description: "Wait for a queue change")
                    let calculateExchangeRate = result
                        //Then
                        XCTAssertNil(calculateExchangeRate)
                        expectation.fulfill()
            }


        }
//        wait(for: expectation, timeout: 0.01)
    }

    func testGetCurrenciesShouldPostFailedCallbackIfNoData() {
        //Given
        let mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        api.session = mockURLSession
        //When
        api.getData(endpoint: .currency(to: "USD", from: "EUR", amount: 150.00), type: API.Currency.CalculateExchangeRate.self) { result in
            let expectation = XCTestExpectation(description: "Wait for a queue change")
            //Then
            XCTAssertNil(result)
            expectation.fulfill()
        }
    }

    func testGetCurrenciesShouldPostFailedCallbackIfIncorrectResponse() {
        //Given
        let mockURLSession = MockURLSession(data: MockResponseData.currencyCorrectData, urlResponse: MockResponseData.responseFailed, error: nil)
        api.session = mockURLSession
        //When
        api.getData(endpoint: .currency(to: "USD", from: "EUR", amount: 150.00), type: API.Currency.CalculateExchangeRate.self) { result in
            let expectation = XCTestExpectation(description: "Wait for a queue change")
            //Then
            XCTAssertNil(result)
            expectation.fulfill()
        }
    }

    func testGetCurrenciesShouldPostFailedCallbackIfIncorrectData() {
        //Given
        let mockURLSession = MockURLSession(data: MockResponseData.mockCurrencyFailed, urlResponse: MockResponseData.responseOK, error: nil)
        api.session = mockURLSession
        //When
        api.getData(endpoint: .currency(to: "USD", from: "EUR", amount: 150.00), type: API.Currency.CalculateExchangeRate.self) { result in
            let expectation = XCTestExpectation(description: "Wait for a queue change")
            //Then
            XCTAssertNil(result)
            expectation.fulfill()
        }
    }

    func testGetCurrenciesShouldPostFailedCallbackIsValid() {
        //Given
        setupAPICurrency(data: MockResponseData.currencyCorrectData, url: MockResponseData.responseOK, error: nil)
        //When
        api.getData(endpoint: .currency(to: "USD", from: "EUR", amount: 150.00), type: API.Currency.CalculateExchangeRate.self) { currencyResult in
            let expectation = XCTestExpectation(description: "Wait for a queue change")
            let to = "USD"
            let from = "EUR"
            let amount = 150.00
            let rate = 1.02845
            let result = 154.2675
            
            //Then
            XCTAssertNotNil(result)

//            XCTAssertEqual(from, result!.query.from)
//            XCTAssertEqual(to, result!.query.to)
//            XCTAssertEqual(amount, result!.query.amount)
//            XCTAssertEqual(rate, result!.info.rate)
//            XCTAssertEqual(result, result!.result)
            expectation.fulfill()
        }
    }

    private func setupAPICurrency(data: Data?, url: URLResponse?, error: Error?) {
        let mockURLSession = MockURLSession(data: data, urlResponse: url, error: error)
        api.session = mockURLSession
    }
}
