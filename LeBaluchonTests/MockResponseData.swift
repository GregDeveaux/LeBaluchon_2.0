//
//  MockResponseData.swift
//  LeBaluchonTests
//
//  Created by Greg-Mini on 16/10/2022.
//

import Foundation

    // simulation of the different calls of currency API
class MockResponseData {

        // Create mock URL with statusCode Ok or failed
    static let responseOK = HTTPURLResponse(url: URL(string: "www.apple.fr")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let responseFailed = HTTPURLResponse(url: URL(string: "www.apple.fr")!, statusCode: 500, httpVersion: nil, headerFields: nil)!

        // Create instance protocol Error
    class CurrencyError: Error {}
    static let error = CurrencyError()

        // recover bundle correct data for test
    static var currencyCorrectData: Data {
        let bundle = Bundle(for: MockResponseData.self)
        let urlExample = bundle.url(forResource: "ApiCurrencyExample", withExtension: ".json")
        let data = try! Data(contentsOf: urlExample!)
        return data
    }

        // create failed response of the simulation
    static let mockCurrencyFailed = "notGood".data(using: .utf8)

}
