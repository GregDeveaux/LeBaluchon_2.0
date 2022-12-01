//
//  LeBaluchonTest.swift
//  LeBaluchonTests
//
//  Created by Greg Deveaux on 28/11/2022.
//

import XCTest
import CoreLocation

@testable import LeBaluchon

final class LeBaluchonTest: XCTestCase {

    var loginViewController: LoginViewController!


    override func setUpWithError() throws {
        loginViewController = LoginViewController()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_User() throws {
        let user = User(name: "Robert", coordinates: CoordinatesInfo(latitude: 49.5532646, longitude: 2.9392577))
        XCTAssertEqual(user.name, "Robert")
        XCTAssertEqual(user.coordinates.latitude, 49.5532646)
        XCTAssertEqual(user.coordinates.longitude, 2.9392577)
        XCTAssertEqual(user.welcomeMessage, "Robert, what's up!")
    }

    func test_City() throws {
        let city = CityInfo(name: "Dijon", country: "France", countryCode: "fr", coordinates: CoordinatesInfo(latitude: 47.3215806, longitude: 5.0414701))
        XCTAssertEqual(city.name, "Dijon")
        XCTAssertEqual(city.country, "France")
        XCTAssertEqual(city.countryCode, "fr")
        XCTAssertEqual(city.coordinates.latitude, 47.3215806)
        XCTAssertEqual(city.coordinates.longitude, 5.0414701)
    }

    func test_PinMap() throws {
        let pinMap = PinMap(title: "you want to go Dijon", coordinate: CLLocationCoordinate2D(latitude: 47.3215806, longitude: 5.0414701), info: "destination")
        XCTAssertEqual(pinMap.title, "you want to go Dijon")
        XCTAssertEqual(pinMap.coordinate.latitude, 47.3215806)
        XCTAssertEqual(pinMap.coordinate.longitude, 5.0414701)
        XCTAssertEqual(pinMap.info, "destination")
    }

    func test_UIColorHexAndRGBA() {
        let cherryHex = UIColor(hex: 0xD2042D)
        let cherryRGBA = UIColor(red: 210, green: 4, blue: 45)
        XCTAssertEqual(cherryHex, cherryRGBA)
    }

    func test_GetcheckTheUserNameExistInBase_WhenAUserNameExistsInBase_ThenTheUserNameDontChang() {
        loginViewController.userDefaults.set("Bob", forKey: "userName")
        
        loginViewController.checkTheUserNameExistInBase()

        guard let text = loginViewController.nameTextField?.text else { return }

        XCTAssertEqual(text, "Bob")
        XCTAssertFalse(loginViewController.nameTextField.isEnabled)
    }

    func test_GetDestinationCitySavedByUserDefaults_WhenIWantToRecoverMyDestination_ThenIFoundTheGoodDestinationName() {
        loginViewController.userDefaults.set("Miami", forKey: "destinationCity")

        XCTAssertEqual("Miami", loginViewController.userDefaults.string(forKey: "destinationCity"))
    }

    func test_GivenIWriteAUserNameAndADestinationCityOK_WhenIPushTheButtonLetsGo_ThenTheLetsGoButtonIsActived() {
        loginViewController.nameTextField?.text = "Bob"
        loginViewController.destinationTextField?.text = "BikiniBottom"

        loginViewController.letsGoButton?.sendActions(for: .touchUpInside)

        XCTAssertTrue(loginViewController.validateEntryTextFields)
    }

    func test_GivenIWriteOnlyADestinationCityOK_WhenIPushTheButtonLetsGo_ThenTheLetsGoButtonIsNotActived() {
        loginViewController.destinationTextField?.text = "BikiniBottom"
        let message = "please enter an username"

        loginViewController.letsGoButton?.sendActions(for: .touchUpInside)

        XCTAssertFalse(loginViewController.validateEntryTextFields)
    }

    func test_GivenIWriteOnlyAUsernameOK_WhenIPushTheButtonLetsGo_ThenTheLetsGoButtonIsNotActived() {
        loginViewController.nameTextField?.text = "Patrick"
        let message = "please enter an username"


        loginViewController.letsGoButton?.sendActions(for: .touchUpInside)

        XCTAssertTrue(loginViewController.presentAlert(with: message))
        XCTAssertFalse(loginViewController.validateEntryTextFields)
    }

    func presentBuyingErrorDialogue() {
          let alert = UIAlertController(title: "Warning", message: "Error purchasing item, please retry this action. If that doesn't help, try restarting or reinstalling the app.", preferredStyle: .alert)
          let okButton = UIAlertAction(title: "OK", style: .default)
          alert.addAction(okButton)
          UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }

        func testPresentBuyingErrorDialogue() {
          self.presentBuyingErrorDialogue()
          let expectation = XCTestExpectation(description: "testExample")
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            XCTAssertTrue(UIApplication.shared.keyWindow?.rootViewController?.presentedViewController is UIAlertController)
            expectation.fulfill()
          })
          wait(for: [expectation], timeout: 1.5)
       }

    func test_PerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
