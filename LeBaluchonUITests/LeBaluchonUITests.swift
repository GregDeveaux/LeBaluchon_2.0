//
//  LeBaluchonUITests.swift
//  LeBaluchonUITests
//
//  Created by Greg-Mini on 10/10/2022.


import XCTest

class LeBaluchonUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testLaucnchApp() throws {
        let app = XCUIApplication()
        app.launch()
    }


    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
