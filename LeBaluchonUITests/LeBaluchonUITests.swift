//
//  LeBaluchonUITests.swift
//  LeBaluchonUITests
//
//  Created by Greg-Mini on 10/10/2022.


import XCTest

class LeBaluchonUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()


        let element3 = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let element = element3.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .other).element(boundBy: 1).children(matching: .textField).element.tap()

        let lKey = app/*@START_MENU_TOKEN@*/.keys["l"]/*[[".keyboards.keys[\"l\"]",".keys[\"l\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        lKey.tap()
        lKey.tap()

        let iKey = app/*@START_MENU_TOKEN@*/.keys["i"]/*[[".keyboards.keys[\"i\"]",".keys[\"i\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        iKey.tap()
        iKey.tap()
        lKey.tap()
        lKey.tap()
        lKey.tap()

        let eKey = app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        eKey.tap()
        eKey.tap()
        element3.tap()

        let app2 = app
        app2/*@START_MENU_TOKEN@*/.staticTexts["Let's go!"]/*[[".buttons[\"Let's go!\"].staticTexts[\"Let's go!\"]",".staticTexts[\"Let's go!\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        let tabBar = app.tabBars["Tab Bar"]
        let currencyButton = tabBar.buttons["currency"]
        currencyButton.tap()
        tabBar.buttons["translate"].tap()
        app.buttons["1"].tap()
        app2/*@START_MENU_TOKEN@*/.staticTexts["2"]/*[[".buttons[\"2\"].staticTexts[\"2\"]",".staticTexts[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["deleteTouch"]/*[[".buttons[\"backspace\"]",".buttons[\"deleteTouch\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        currencyButton.tap()

        let composeButton = app.buttons["compose"]
        composeButton.tap()
        app.buttons["microphone"].tap()
        app.buttons["camera"].tap()
        app2/*@START_MENU_TOKEN@*/.scrollViews/*[[".otherElements[\"Select your image\"].scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements.buttons["Cancel"].tap()
        composeButton.tap()

        let element2 = element.children(matching: .other).element.children(matching: .other).element
        element2.children(matching: .other).element(boundBy: 1).children(matching: .textView).element(boundBy: 0).tap()

        let vKey = app2/*@START_MENU_TOKEN@*/.keys["V"]/*[[".keyboards.keys[\"V\"]",".keys[\"V\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        vKey.tap()
        vKey.tap()
        eKey.tap()

        let rKey = app2/*@START_MENU_TOKEN@*/.keys["r"]/*[[".keyboards.keys[\"r\"]",".keys[\"r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        rKey.tap()
        rKey.tap()

        let yKey = app2/*@START_MENU_TOKEN@*/.keys["y"]/*[[".keyboards.keys[\"y\"]",".keys[\"y\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        yKey.tap()
        yKey.tap()
        element2.tap()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
