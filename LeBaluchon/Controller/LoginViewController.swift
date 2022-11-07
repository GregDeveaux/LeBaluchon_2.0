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

        // MARK: recover coordinates, name country and code country...
        // ...thanks to the writing of the destination by the destinationTextField
    private func foundCoordinates(of city: String?) {
        API.QueryService.shared.getCoordinate(endpoint: .coordinates(city: city!), method: .GET) { success, coordinates in
            guard let coordinates = coordinates, success == true else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }
            DispatchQueue.main.async {
                let latitude = coordinates[0].latitude
                let longitude = coordinates[0].longitude

                self.foundCountryByCoordinates(latitude: latitude, longitude: longitude)
            }
        }
    }

        // ...thanks to the writing of the latitude and longitude
    private func foundCountryByCoordinates(latitude: String, longitude: String) {
        API.QueryService.shared.getAddress(endpoint: .city(latitude: latitude, longitude: longitude), method: .GET) { success, address in
            guard let address = address, success == true else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }
            DispatchQueue.main.async {
                print("----------------------------->>>>------------------\(address)")
                self.createDestinationCity(destination: address)
            }
        }
    }


        // MARK: Validate the user and the destination city
    @IBAction func validateButton(_ sender: Any) {

        let userName = nameTextField.text!
        foundCoordinates(of: destinationTextField.text)

        print(" le nom est ---------\(userName) et la ville ------------ \(foundCoordinates(of: destinationTextField.text))")
        performSegue(withIdentifier: "goMapKitController", sender: nil)
    }


    private func createDestinationCity(destination: API.City.Country) -> DestinationCity {

        let destinationName = destinationTextField.text
        let country = destination.address.country
        let countryCode = destination.address.countryCode
        let latitude = Double(destination.latitude)!
        let longitude = Double(destination.longitude)!

        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> \(String(describing: destinationName))  \(country)  \(countryCode)  \(latitude)  \(longitude) >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ")
        return DestinationCity(name: destinationName!, country: country, countryCode: countryCode, coordinates: Coordinates(latitude: latitude, longitude: longitude))
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
            print("****** \(destinationVC?.user?.name as Any) *******")

            destinationVC!.destinationCity?.name = destinationTextField.text!
            print("•••••• \(destinationVC?.destinationCity?.name as Any) •••••••")

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
