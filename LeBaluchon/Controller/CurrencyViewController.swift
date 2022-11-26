//
//  CurrencyViewController.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 10/10/2022.
//

import UIKit

class CurrencyViewController: UIViewController {

        // -------------------------------------------------------
        //MARK: - properties init
        // -------------------------------------------------------

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
    let localeUser = Locale.current
    var localeDestination: Locale!

    var countryCodeDestination: String = ""
    var localeCurrencyDestination: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        addFlagCountries()
        recoverDataOfUserDefaults()

        localeDestination = Locale(identifier: countryCodeDestination)
        iconCurrencyDestination.text = localeDestination.currencySymbol



//        if #available(iOS 16, *) {
//            let localeDestination = Locale.Region(countryCodeDestination)
//            iconCurrencyDestination.text = Locale.Currency(from: localeDestination)
//
//        } else {
//                // Fallback on earlier versions
//        }

        print("🌐 the currency symbole is: \(String(describing: countryCodeDestination)))")
//        print("🌐 the currency symbole is: \(String(describing: localeDestination)))")
        print("🌐 the currency symbole is: \(String(describing: iconCurrencyDestination.text)))")
        print("🌐 the region name is: \(String(describing: nameLocalCountryLabel.text)))")
        print("🌐 the region code is: \(String(describing: localeUser.regionCode))")


    }

    private func recoverDataOfUserDefaults() {
        countryCodeDestination = userDefaults.string(forKey: "destinationCountryCode")?.uppercased()  ?? "BE"
        nameDestinationCountryLabel.text = userDefaults.string(forKey: "destinationCountry")?.uppercased() ?? "BELGIUM"
        destinationNameLabel.text = userDefaults.string(forKey: "destinationCityName")?.capitalized
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

        var localeCurrencyUser = ""
        var localeCurrencyDestination = "EUR"

        if #available(iOS 16, *) {
            guard let value  = localeUser.currency?.identifier else { return }
            localeCurrencyUser = value
        } else {
            guard let value  = localeUser.currencyCode else { return }
            localeCurrencyUser = value
        }

       API.QueryService.shared.getData(endpoint: .currency(to: localeCurrencyDestination, from: localeCurrencyUser, amount: amountTapped),
                                    type: API.Currency.CalculateExchangeRate.self) { result in
                switch result {
                case .failure(let error):
                    self.presentAlert()
                    print(error.localizedDescription)

                case .success(let result):
                    let calculateExchangeRate = result
                    DispatchQueue.main.async {
                        self.textFieldResult.text = String(calculateExchangeRate.result)
                        print("💰result: \(String(describing: calculateExchangeRate.result))")
                    }
                }
            }
        }
//        API.QueryService.shared.getCurrency(endpoint: .currency(to: "", from: localeCurrency, amount: amountTapped), method: .GET) { success, calculateExchangeRate in
//            guard let calculateExchangeRate = calculateExchangeRate, success == true else {
//                self.presentAlert()
//                print(API.Error.generic(reason: "not shown data"))
//                return
//            }
//            DispatchQueue.main.async {
//                self.textFieldResult.text = String(calculateExchangeRate.result )
//                print("💰result: \(String(describing: calculateExchangeRate.result))")
//            }
//        }
//    }

    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "The result of currency failed", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alertVC, animated: true)
    }


        // -------------------------------------------------------
        //MARK: - Flag UIImageView
        // -------------------------------------------------------

    func addFlagCountries() {
        designFlag(to: flagLocalImageView)
        designFlag(to: flagDestinationImageView)

        API.QueryService.shared.getFlag(endpoint: .flag(codeIsoCountry: localeUser.regionCode ?? "IT"), method: .GET) { countryFlag in
            guard let countryFlag = countryFlag else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }
            DispatchQueue.main.async {
                self.flagLocalImageView.image = UIImage(data: countryFlag)
                self.iconCurrencyPhone.text = self.localeUser.currencySymbol
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

    func designFlag(to flag: UIImageView) {
        flag.layer.cornerRadius = 5
        flag.layer.borderWidth = 1
        flag.layer.borderColor = .init(genericCMYKCyan: 50, magenta: 0, yellow: 50, black: 10, alpha: 0.5)
    }
}
