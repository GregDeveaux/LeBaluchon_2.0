//
//  MockResponseData.swift
//  LeBaluchonTests
//
//  Created by Greg Deveaux on 16/10/2022.
//

import XCTest

    // simulation of the different calls of currency API
class MockResponseData {

    static var apiURL = URL(string: "www.apple.fr")!

        // Create mock URL with statusCode Ok or failed
    static let responseOK = HTTPURLResponse(url: apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let responseFailed = HTTPURLResponse(url: apiURL, statusCode: 500, httpVersion: nil, headerFields: nil)!

        // Create instance protocol Error
    class ResponseError: Error {}
    static let error = ResponseError()

        // recover bundle correct data for test
    static var currencyCorrectData: Data {
        let bundle = Bundle(for: MockResponseData.self)
        let urlExample = bundle.url(forResource: "APICurrencyExample", withExtension: ".json")
        let data = try! Data(contentsOf: urlExample!)
        return data
    }

        // recover bundle correct data for test
    static var weatherCorrectData: Data {
        let bundle = Bundle(for: MockResponseData.self)
        let urlExample = bundle.url(forResource: "APIWeatherExample", withExtension: ".json")
        let data = try! Data(contentsOf: urlExample!)
        return data
    }

        // recover bundle correct data for test
    static var translationCorrectData: Data {
        let bundle = Bundle(for: MockResponseData.self)
        let urlExample = bundle.url(forResource: "APITranslationExample", withExtension: ".json")
        let data = try! Data(contentsOf: urlExample!)
        return data
    }

        // recover bundle correct data for test
    static var coordinatesCorrectData: Data {
        let bundle = Bundle(for: MockResponseData.self)
        let urlExample = bundle.url(forResource: "APICoordinatesExample", withExtension: ".json")
        let data = try! Data(contentsOf: urlExample!)
        return data
    }

        // recover bundle correct data for test
    static var cityCorrectData: Data {
        let bundle = Bundle(for: MockResponseData.self)
        let urlExample = bundle.url(forResource: "APICityExample", withExtension: ".json")
        let data = try! Data(contentsOf: urlExample!)
        return data
    }

        // create failed response of the simulation
    static let mockDataFailed = "notGood".data(using: .utf8)
}
