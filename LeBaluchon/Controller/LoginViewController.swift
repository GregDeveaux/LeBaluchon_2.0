//
//  LoginViewController.swift
//  LeBaluchon
//
//  Created by Greg-Mini on 11/10/2022.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!

    var destinationCity: City!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        destinationTextField.delegate = self
    }


    @IBAction func TappedLetsGoButton(_ sender: UIButton) {

        foundCoordinates()

        performSegue(withIdentifier: "goToTheDestination", sender: nil)
    }

    private func foundCoordinates() {
        API.QueryService.shared.getCoordinate(endpoint: .coordinates(city: destinationTextField.text!), method: .GET) { success, coordinates in
            guard let coordinates = coordinates, success == true else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }
            DispatchQueue.main.async {
                print("avant \(coordinates[0])")
                let lattitude = coordinates[0].lattitude
                let longitude = coordinates[0].longitude
                print("après \(lattitude), \(longitude))")

                self.foundCountry(lattitude: lattitude, longitude: longitude)
            }
        }
    }

    private func foundCountry(lattitude: String, longitude: String) {
        API.QueryService.shared.getAdress(endpoint: .city(lattitude: lattitude, longitude: longitude), method: .GET) { success, adress in
            guard let adress = adress, success == true else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }
            DispatchQueue.main.async {
                print(adress)
                self.destinationCity.country = adress.country
                self.destinationCity.countryCode = adress.countryCode
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTheDestination" {
            let destinationVC = segue.destination as? WelcomeViewController
            destinationVC?.helloWithName = nameTextField.text!
            destinationVC?.myDestination = destinationTextField.text!
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
