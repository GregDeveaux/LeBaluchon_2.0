//
//  APITranslateTests.swift
//  LeBaluchonTests
//
//  Created by Greg Deveaux on 27/11/2022.
//

import XCTest
@testable import LeBaluchon

class APITranslateTests: XCTestCase {
    
        // Create instance API
    var currencyAPI: API.Translation!
    var expectation: XCTestExpectation!
    let apiURL = URL(string: "https://api-free.deepl.com/v2/translate?source_lang=EN&text=big&target_lang=FR&auth_key=\(APIKeys.Translation.key.rawValue.self)")
    
    override func setUpWithError() throws {
        print("key=\(APIKeys.Translation.RawValue.self)")
        
            // Transform URLProtocol from MockURLProtocol
        URLProtocol.registerClass(MockURLProtocol.self)
        
            // Setup a configuration to use our mock
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        
            // Create the URLSession configurated
        let urlSession = URLSession.init(configuration: configuration)
        
            // this is the URLRequest of the API currency rescue by enum Endpoint
        let request = URLRequest(url: API.EndPoint.translation(sourceLang: "", text: "", targetLang: "").url)
        
    }
    
    override func tearDownWithError() throws {
            // Stop the modification of class URLProtocol
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }

    func testRequestCurrenciesGenerationIsOk() {
            // Given
        let sourceLanguage = "EN"
        let targetLanguage = "FR"
        let text = "big"
            //When
        let urlEndpoint = API.EndPoint.translation(sourceLang: sourceLanguage, text: text, targetLang: targetLanguage).url
            //Then
        XCTAssertEqual(urlEndpoint, apiURL)
    }

    func testSuccessfulResponse() {
            // Given
        expectation = expectation(description: "Expectation")
        let text = "grand"
            //When
        let data = MockResponseData.translationCorrectData
        
        MockURLProtocol.requestHandler = { request in
            let response = MockResponseData.responseOK
            return (response, data)
        }
            //Then
        API.QueryService.shared.getData(endpoint: .translation(sourceLang: "EN", text: "big", targetLang: "FR"),
                                        type: API.Translation.Recover.self) { result in
            switch result {
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                    
                case .success(let result):
                    let translatedSentence = result
                    XCTAssertEqual(translatedSentence.translations.first?.text, text)
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
