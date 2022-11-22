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

    @IBOutlet weak var bubbleTextView: UITextView!
    let welcomeText = "Hello, my friend! Welcome to the \"Le Baluchon\" App, to start you must write your name and your destination, thank you 😀"

    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

            // bubble explanation before to enter in the app.
//        bubbleTextView.typeOn(sentence: welcomeText)

        nameTextField.delegate = self
        destinationTextField.delegate = self
    }


        // MARK: Validate the user and the destination city
    @IBAction func validateButton(_ sender: UIButton) {
            
        guard let userName = nameTextField.text else { return }
        
        guard let destinationCityName = destinationTextField.text else { return }

            // recover the info on the city after than the user wrote your destination in the textField
        API.recoverInfoOnTheCity(named: destinationTextField.text!) { destinationInfo in

            self.userDefaults.set(userName, forKey: "userName")
            self.userDefaults.set(destinationCityName, forKey: "destinationCityName")
            self.userDefaults.set(destinationInfo?.coordinates.latitude, forKey: "destinationCityLatitude")
            self.userDefaults.set(destinationInfo?.coordinates.longitude, forKey: "destinationCityLongitude")
            self.userDefaults.set(destinationInfo?.country, forKey: "destinationCountry")
            self.userDefaults.set(destinationInfo?.countryCode, forKey: "destinationCountryCode")

            print("✅ user name is \(userName)")
            print("""
            ✅ the destination is \(destinationCityName),
            with as coordinates : - lat:\(destinationInfo?.coordinates.latitude ?? 0)
                                  - long:\(destinationInfo?.coordinates.longitude ?? 0)
            """)

                // used to move on the MainTabView if the fields "UserName" and "destination" is completed
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.window?.rootViewController = mainTabBarController
        }
    }

    private func presentAlert(with error: String) {
        let alert: UIAlertController = UIAlertController(title: "Erreur", message: error, preferredStyle: .alert)
        let action: UIAlertAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
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
