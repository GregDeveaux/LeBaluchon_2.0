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

    override func setUpWithError() throws {

            // Transform URLProtocol from MockURLProtocol
        URLProtocol.registerClass(MockURLProtocol.self)

            // Setup a configuration to use our mock
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]

            // Create the URLSession configurated
        urlSession = URLSession(configuration: configuration)

            // this is the URLRequest of the API currency rescue by enum Endpoint
        let urlRequest = URLRequest(url: API.EndPoint.currency(to: "", from: "", amount: 0).url)
    }

    override func tearDownWithError() throws {
            // Stop the modification of class URLProtocol
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }

    func testRequestCurrenciesGenerationIsOk() {
            // Given
        let currencyUser = "Lille"
        let units = "metric"
            //When
        let urlEndpoint = API.EndPoint.weather(city: currencyUser, units: units).url
            //Then
        XCTAssertEqual(urlEndpoint, apiURL)
    }

    func testSuccessfulResponse() {
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
        API.QueryService.shared.getData(endpoint: .currency(to: "EUR", from: "USD", amount: 150.0),
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

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
