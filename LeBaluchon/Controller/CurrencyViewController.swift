//
//  CurrencyViewController.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 10/10/2022.
//

import UIKit

class CurrencyViewController: UIViewController {

    @IBOutlet var numberButton: [UIButton]!

    @IBOutlet weak var iconCurrencyPhone: UILabel!
    @IBOutlet weak var iconCurrencyDestination: UILabel!
    @IBOutlet weak var textFieldEntryAmount: UITextView!
    @IBOutlet weak var textFieldResult: UITextField!
    @IBOutlet weak var buttonConvert: UIButton!
    @IBOutlet weak var flagLocalImageView: UIImageView!
    @IBOutlet weak var nameLocalCountryLabel: UILabel!
    @IBOutlet weak var flagDestinationImageView: UIImageView!
    @IBOutlet weak var nameDestinationCountryLabel: UILabel!

    var amountTapped: Double = 0.0

    let userDefaults = UserDefaults.standard

//    var countryHome: String {
//        didSet {
//            countryHome = self.userDefaults.string(forKey: "destinationCountry") ?? "Nothing"
//        }
//    }

    var countryDestination: String {
        didSet {
            countryDestination = self.userDefaults.string(forKey: "destinationCountry") ?? "FR"
        }
    }

//    var countryCodeHome = ""
    var countryCodeDestination: String {
        didSet {
            countryCodeDestination = self.userDefaults.string(forKey: "destinationCountryCode") ?? "US"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        flagLocalImageView.layer.cornerRadius = 5
        flagDestinationImageView.layer.cornerRadius = 5

        API.QueryService.shared.getFlag(endpoint: .flag(codeIsoCountry: "FR"), method: .GET) { countryFlag in
            guard let countryFlag = countryFlag else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }
            DispatchQueue.main.async {
                self.flagLocalImageView.image = UIImage(data: countryFlag)

                API.QueryService.shared.getFlag(endpoint: .flag(codeIsoCountry: self.countryCodeDestination), method: .GET) { countryFlag in
                    guard let countryFlag = countryFlag else {
                        print(API.Error.generic(reason: "not shown data"))
                        return
                    }
                    DispatchQueue.main.async {
                        self.flagDestinationImageView.image = UIImage(data: countryFlag)
                    }
                }
            }
        }
    }


    @IBAction func tappedNumberKey(_ sender: UIButton) {
        guard let numberText = sender.titleLabel?.text else { return }

        if textFieldEntryAmount.text == "0" {
            textFieldEntryAmount.text = ""
        } else if textFieldEntryAmount.text == "." {
            textFieldEntryAmount.text = "0."
        }

        textFieldEntryAmount.text.append(numberText)
        amountTapped = Double(textFieldEntryAmount.text) ?? 0.0
        print("tapped: \(numberText)")
    }

    @IBAction func tappedToConvert(_ sender: UIButton) {

        API.QueryService.shared.getCurrency(endpoint: .currency(to: "EUR", from: "USD", amount: amountTapped), method: .GET) { success, calculateExchangeRate in
            guard let calculateExchangeRate = calculateExchangeRate, success == true else {
                self.presentAlert()
                print(API.Error.generic(reason: "not shown data"))
                return
            }
            DispatchQueue.main.async {
                self.textFieldResult.text = String(calculateExchangeRate.result )
                print("💰result: \(String(describing: calculateExchangeRate.result))")
            }

        }


    }

    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "The result of currency failed", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alertVC, animated: true)
    }
}
