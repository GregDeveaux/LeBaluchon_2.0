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
    @IBOutlet weak var resetNumberButton: UIButton!
    @IBOutlet weak var destinationNameLabel: UILabel!

    var amountTapped: Double = 0.0

    let userDefaults = UserDefaults.standard
    let locale = Locale.current

    var countryCodeDestination: String = "DE"
    var localeCurrencyDestination: String = "FR"

    override func viewDidLoad() {
        super.viewDidLoad()

        flagLocalImageView.layer.cornerRadius = 5
        flagLocalImageView.layer.borderWidth = 1
        flagLocalImageView.layer.borderColor = .init(genericCMYKCyan: 50, magenta: 0, yellow: 50, black: 10, alpha: 0.5)
        flagDestinationImageView.layer.cornerRadius = 5
        flagDestinationImageView.layer.borderWidth = 1
        flagDestinationImageView.layer.borderColor = .init(genericCMYKCyan: 50, magenta: 0, yellow: 50, black: 10, alpha: 0.5)

        countryCodeDestination = userDefaults.string(forKey: "destinationCountryCode")?.uppercased()  ?? "BE"
        nameDestinationCountryLabel.text = userDefaults.string(forKey: "destinationCountry")?.uppercased() ?? "BELGIUM"
        destinationNameLabel.text = userDefaults.string(forKey: "destinationCityName")?.capitalized

        nameLocalCountryLabel.text = locale.localizedString(forRegionCode: locale.regionCode ?? "BE")?.uppercased()

        let localeDestination = Locale(identifier: countryCodeDestination)
//        if #available(iOS 16, *) {
//            guard let value = localeDestination.currency?.identifier else { return }
//            localeCurrencyDestination = value
//        } else {
//            guard let value = localeDestination.currencyCode else { return }
//            localeCurrencyDestination = value
//        }
            iconCurrencyDestination.text = localeDestination.currencySymbol

        print("🌐 the currency symbole is: \(String(describing: countryCodeDestination)))")
//        print("🌐 the currency symbole is: \(String(describing: localeDestination)))")
        print("🌐 the currency symbole is: \(String(describing: iconCurrencyDestination.text)))")
        print("🌐 the region name is: \(String(describing: nameLocalCountryLabel.text)))")
        print("🌐 the region code is: \(String(describing: locale.regionCode))")

        API.QueryService.shared.getFlag(endpoint: .flag(codeIsoCountry: locale.regionCode ?? "IT"), method: .GET) { countryFlag in
            guard let countryFlag = countryFlag else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }
            DispatchQueue.main.async {
                self.flagLocalImageView.image = UIImage(data: countryFlag)
                self.iconCurrencyPhone.text = self.locale.currencySymbol
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

    @IBAction func tappedResetButton(_ sender: UIButton) {
        if textFieldEntryAmount.text.count >= 1 {
            textFieldEntryAmount.text.removeLast()
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

        var localeCurrency = ""
        if #available(iOS 16, *) {
            guard let value  = locale.currency?.identifier else { return }
            localeCurrency = value
        } else {
            guard let value  = locale.currencyCode else { return }
            localeCurrency = value
        }

        API.QueryService.shared.getCurrency(endpoint: .currency(to: "", from: localeCurrency, amount: amountTapped), method: .GET) { success, calculateExchangeRate in
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
