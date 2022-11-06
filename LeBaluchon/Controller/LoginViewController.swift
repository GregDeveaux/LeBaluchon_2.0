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

    var userName = ""

    var country = ""
    var countryCode = ""
    var latitude = ""
    var longitude = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        destinationTextField.delegate = self

    }

        // MARK: recover coordinates, name country and code country
    private func foundCoordinates(of city: String?) {
        API.QueryService.shared.getCoordinate(endpoint: .coordinates(city: city!), method: .GET) { success, coordinates in
            guard let coordinates = coordinates, success == true else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }
            DispatchQueue.main.async {
                print("avant \(coordinates[0])")

                let latitude = coordinates[0].latitude
                let longitude = coordinates[0].longitude
                print("après \(latitude), \(longitude))")

                self.foundCountryByCoordinates(latitude: latitude, longitude: longitude)
            }
        }
    }

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
    @IBAction func validateButton(_ sender: UIButton) {

        userName = nameTextField.text!
        foundCoordinates(of: destinationTextField.text)

        print(userName)

        performSegue(withIdentifier: "goMapKitController", sender: nil)
    }



    private func createDestinationCity(destination: API.City.Country) {
        guard let userName = destinationTextField.text else { return }

        country = destination.address.country
        countryCode = destination.address.countryCode
        latitude = destination.latitude
        longitude = destination.longitude

        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> \(userName)  \(country)  \(countryCode)  \(latitude)  \(longitude) >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ")
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
            if let destinationVC = segue.destination as? MapViewController {
                destinationVC.user?.name = userName

                destinationVC.destinationCity?.name = destinationTextField.text!
                destinationVC.destinationCity?.country = country
                destinationVC.destinationCity?.countryCode = countryCode
                destinationVC.destinationCity?.coordinates.latitude = Double(latitude)!
                destinationVC.destinationCity?.coordinates.longitude = Double(longitude)!

                print("la destination est \(String(describing: destinationVC.destinationCity))")
            }
        }
    }
}

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
