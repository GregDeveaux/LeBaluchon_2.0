//
//  APITranslateTests.swift
//  LeBaluchonTests
//
//  Created by Greg Deveaux on 27/11/2022.
//

import XCTest
@testable import LeBaluchon

class APITranslateTests: XCTestCase {
    
    var urlSession: URLSession!
    var expectation: XCTestExpectation!

    var translationAPI: API.Translation!
    let apiURL = URL(string: "https://api-free.deepl.com/v2/translate?source_lang=EN&text=big&target_lang=FR&auth_key=\(APIKeys.Translation.key.rawValue.self)")
    
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

    func test_GivenTheGoodURLRequestOfTranslatationAPI_ThenTheGenerationOftheURLIsOk() {
        let sourceLanguage = "EN"
        let targetLanguage = "FR"
        let text = "big"
        let urlEndpoint = API.EndPoint.translation(sourceLang: sourceLanguage, text: text, targetLang: targetLanguage).url
        XCTAssertEqual(urlEndpoint, apiURL)
    }

    func test_GivenTheBadURLRequestOfTranslatationAPI_ThenTheGenerationOftheURLIsFailed() {
        let sourceLanguage = "RUSSE"
        let targetLanguage = "FR"
        let text = "big"
        let urlEndpoint = API.EndPoint.translation(sourceLang: sourceLanguage, text: text, targetLang: targetLanguage).url
        XCTAssertNotEqual(urlEndpoint, apiURL)
    }

    func test_GivenTheGoodURLWithATranslatedTextBig_WhenIAskATranslationInFrench_ThenTheAnswerIsGrand() {
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

    func test_GivenIAskATranslation_WhenINotRecoverAStatusCode500_ThenMyResponseFailed() {

        baseQueryCurrency(data: MockResponseData.currencyCorrectData, response: MockResponseData.responseFailed)

        API.QueryService.shared.getData(endpoint: .translation(sourceLang: "EN", text: "big", targetLang: "FR"),
                                        type: API.Translation.Recover.self) { result in
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

        API.QueryService.shared.getData(endpoint: .translation(sourceLang: "EN", text: "big", targetLang: "FR"),
                                        type: API.Translation.Recover.self) { result in
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

