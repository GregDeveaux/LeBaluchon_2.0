//
//  APIWeatherTests.swift
//  LeBaluchonTests
//
//  Created by Greg Deveaux on 28/11/2022.
//

import XCTest
@testable import LeBaluchon

final class APIWeatherTests: XCTestCase {

    var urlSession: URLSession!
    var expectation: XCTestExpectation!

    var weatherAPI: API.Weather!
    let apiURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=Lille&units=metric&appid=\(APIKeys.Weather.key.rawValue.self)")

    let currencyUser = "Lille"
    let units = "metric"

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

    func test_GivenTheGoodURLRequestOfWeatherAPI_ThenTheGenerationOftheURLIsOk() {
        let urlEndpoint = API.EndPoint.weather(city: currencyUser, units: units).url
        XCTAssertEqual(urlEndpoint, apiURL)
    }

    func test_GivenTheGoodURLWithLilleAsCityName_WhenIAskTheWeather_ThenTheAnswerIs19DegresAndScatteredClouds() {
            // Given
        expectation = expectation(description: "Expectation")
        let name = "Lille"
        let descriptionSky = "scattered clouds"
        let degresLabel = 19.31
        let hightTempDay = 19.95
        let lowTempDay = 17.78
        let date = 1666445756

            //When
        let data = MockResponseData.weatherCorrectData

        MockURLProtocol.requestHandler = { request in
            let response = MockResponseData.responseOK
            return (response, data)
        }
            //Then
        API.QueryService.shared.getData(endpoint: .weather(city: currencyUser, units: units),
                                        type: API.Weather.DataForCity.self) { result in
            switch result {
                case .failure(let error):
                    XCTFail(error.localizedDescription)

                case .success(let result):
                    let weatherForCity = result
                    XCTAssertEqual(weatherForCity.name, name)
                    XCTAssertEqual(weatherForCity.weather.first?.description, descriptionSky)
                    XCTAssertEqual(weatherForCity.main.temp, degresLabel)
                    XCTAssertEqual(weatherForCity.main.tempMax, hightTempDay)
                    XCTAssertEqual(weatherForCity.main.tempMin, lowTempDay)
                    XCTAssertEqual(weatherForCity.date, date)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }


    func test_GivenIAskATranslation_WhenINotRecoverAStatusCode500_ThenMyResponseFailed() {

        baseQueryCurrency(data: MockResponseData.currencyCorrectData, response: MockResponseData.responseFailed)

        API.QueryService.shared.getData(endpoint: .weather(city: currencyUser, units: units),
                                        type: API.Weather.DataForCity.self) { result in
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

        API.QueryService.shared.getData(endpoint: .weather(city: currencyUser, units: units),
                                        type: API.Weather.DataForCity.self) { result in
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
