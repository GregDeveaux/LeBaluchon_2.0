//
//  LoginViewController.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 11/10/2022.
//

import UIKit

class LoginViewController: UIViewController {

        // -------------------------------------------------------
        // MARK: - properties
        // -------------------------------------------------------

    var validateEntryTextFields = false
    var user = User()
    var destination = Destination()


        // -------------------------------------------------------
        // MARK: - outlets
        // -------------------------------------------------------

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!

    @IBOutlet weak var baluchonLogo: UILabel!
    @IBOutlet weak var bubbleTextView: UITextView!
    @IBOutlet weak var SunImage: UIImageView!
    @IBOutlet weak var textNameLabel: UILabel!
    @IBOutlet weak var textDestinationLabel: UILabel!
    @IBOutlet weak var letsGoButton: UIButton!


        // -------------------------------------------------------
        // MARK: - viewDidLoad
        // -------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        checkTheUserNameExistInBase()

        nameTextField.delegate = self
        destinationTextField.delegate = self
    }


        // -------------------------------------------------------
        // MARK: - user name exist ?
        // -------------------------------------------------------

    func checkTheUserNameExistInBase() {
        if let text = nameTextField?.text, text.isEmpty {
            nameTextField.text = user.name
            print("✅ LOGIN: user name exists, don't change, it's \(nameTextField.text ?? "Nothing")")
        }
    }


        // -----------------------------------------------------
        // MARK: - recover the info on the City and play the app
        // -----------------------------------------------------

        // Validate the user and the destination city textField if aren't nil then save datas and change the viewController
    @IBAction func validateButton(_ sender: UIButton) {
        
        if destinationTextField.text?.last == " " {
            destinationTextField.text?.removeLast()
        }

        guard let userName = nameTextField.text, !userName.isEmpty else {
            presentAlert(with: "please enter an username")
            return
        }
        user.name = userName


        guard let destinationCityName = destinationTextField.text, !destinationCityName.isEmpty else {
            presentAlert(with: "please enter a destination city")
            return
        }
        destination.cityName = destinationCityName

        validateEntryTextFields = true

            // recover the info on the city after than the user wrote your destination in the textField
        API.LocalisationCity.recoverInfoOnTheCity(named: destinationCityName) { result in

            guard let destinationInfo = result else { return self.presentAlert(with: "We have nothing on the city")}

            self.destination.latitude = destinationInfo.latitude
            self.destination.longitude = destinationInfo.longitude
            self.destination.countryName = destinationInfo.country
            self.destination.countryCode = destinationInfo.countryCode

            print("""
            ✅ LOGIN: user name is \(self.user.name), you live in \(self.user.countryName)
            ✅ LOGIN: the destination is \(self.destination.cityName), \(self.destination.countryName)
                      with as coordinates : - lat:\(self.destination.latitude)
                                            - long:\(self.destination.longitude)
            """)

            self.changeViewController()
        }
    }


        // -------------------------------------------------------
        // MARK: - alert
        // -------------------------------------------------------

    func presentAlert(with error: String) {
        let alert: UIAlertController = UIAlertController(title: "Erreur", message: error, preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }


        // -------------------------------------------------------
        // MARK: - change ViewController after validation
        // -------------------------------------------------------

    func changeViewController() {
            // used to move on the MainTabView if the fields "UserName" and "destination" is completed
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = mainTabBarController
    }
}


    // -------------------------------------------------------
    // MARK: Keyboard setup dismiss
    // -------------------------------------------------------

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
