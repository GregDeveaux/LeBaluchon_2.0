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


        // MARK: Validate the user and the destination city
    @IBAction func validateButton(_ sender: UIButton) {

        API.recoverInfoOnTheCity(named: destinationTextField.text!) { destinationInfo in
            self.performSegue(withIdentifier: "goMapKitController", sender: destinationInfo)
        }

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
            let destinationCityInfo = sender as? DestinationCity
            destinationVC?.userName = nameTextField.text ?? "User unknow"
            destinationVC?.destinationCityName = destinationTextField.text ?? "Destination Unknow"
            destinationVC?.destinationCity.name = destinationCityInfo
            print("\(destinationCityInfo)")
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
