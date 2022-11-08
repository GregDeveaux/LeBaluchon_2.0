//
//  LoginViewController.swift
//  LeBaluchon
//
//  Created by Greg Deveaux  on 11/10/2022.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        destinationTextField.delegate = self

    }


    func recoverInfoOfTheCity(named city: String) -> DestinationCity? {
        let city = city

        let destinationCity = foundCoordinates(of: city)

        return destinationCity

    }
        // MARK: recover coordinates, name country and code country...
        // ...thanks to the writing of the destination by the destinationTextField
    private func foundCoordinates(of city: String) -> DestinationCity? {

        let city = city
        var foundCountry: DestinationCity!

        API.QueryService.shared.getCoordinate(endpoint: .coordinates(city: city), method: .GET) { success, coordinates in
            guard let coordinates = coordinates, success == true else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }
                let latitude = coordinates[0].latitude
                let longitude = coordinates[0].longitude

                foundCountry = self.foundCountryByCoordinates(latitude: latitude, longitude: longitude)
        }
        return foundCountry
    }

        // ...thanks to the writing of the latitude and longitude
    private func foundCountryByCoordinates(latitude: String, longitude: String) -> DestinationCity? {
        let latitude = latitude
        let longitude = longitude
        var destinationCity: DestinationCity!

        API.QueryService.shared.getAddress(endpoint: .city(latitude: latitude, longitude: longitude), method: .GET) { success, address in
            guard let address = address, success == true else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }
                print("----------------------------->>>>------------------\(address)")
                destinationCity = self.createDestinationCity(destination: address)
        }
        return destinationCity
    }


        // MARK: Validate the user and the destination city
    @IBAction func validateButton(_ sender: UIButton) {

        let userName = nameTextField.text!
        let destinationCity = recoverInfoOfTheCity(named: destinationTextField.text!)
        let cityName = destinationCity?.name

        print(" le nom est ---------\(userName) et la ville ------------ \(String(describing: cityName))")
        performSegue(withIdentifier: "goMapKitController", sender: nil)
    }


    private func createDestinationCity(destination: API.City.Country) -> DestinationCity {

        let destinationName = destinationTextField.text!
        let country = destination.address.country
        let countryCode = destination.address.countryCode
        let latitude = Double(destination.latitude)!
        let longitude = Double(destination.longitude)!

        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> \(String(describing: destinationName))  \(country)  \(countryCode)  \(latitude)  \(longitude) >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ")
        return DestinationCity(name: destinationName, country: country, countryCode: countryCode, coordinates: Coordinates(latitude: latitude, longitude: longitude))
    }


    private func presentAlert(with error: String) {
        let alert: UIAlertController = UIAlertController(title: "Erreur", message: error, preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }


        //MARK: Send data for mapKitController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goMapKitController" {
            let destinationVC = segue.destination as? MapViewController

            destinationVC?.user?.name = nameTextField.text!
            print("****** \(nameTextField.text!) *******")

            destinationVC!.destinationCity?.name = destinationTextField.text!
            print("•••••• \(destinationTextField.text!) •••••••")

//                destinationVC.destinationCity?.country = country
//                destinationVC.destinationCity?.countryCode = countryCode
//                destinationVC.destinationCity?.coordinates.latitude = Double(latitude)!
//                destinationVC.destinationCity?.coordinates.longitude = Double(longitude)!
//
//                print("la destination est \(String(describing: destinationVC.destinationCity))")
//            }
        }
    }
}


    //MARK: Keyboard setup dismiss
extension LoginViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        destinationTextField.resignFirstResponder()
        return true
    }
}
