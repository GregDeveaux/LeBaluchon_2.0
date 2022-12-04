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
    var currencyDestinationName: String = ""

    var countryCodeUser: String = ""
    var localeCurrencyUser: String = ""
    var currencyUserSymbol: String = ""


        // -------------------------------------------------------
        //MARK: - viewDidLoad
        // -------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        recoverDataOfUserDefaults()
        addFlagCountries()


        if #available(iOS 16, *) {
            localeDestination = Locale()
//            let currency = Locale.Currency(from: localeDestination as! Decoder)
//            iconCurrencyDestination.text = Locale.lo

        } else {
                // Fallback on earlier versions
        }

        print("🌐 the currency symbole is: \(String(describing: countryCodeDestination)))")
        print("🌐 the currency symbole is: \(String(describing: localeDestination)))")
        print("🌐 the currency symbole is: \(String(describing: iconCurrencyDestination.text)))")
        print("🌐 the region name is: \(String(describing: nameLocalCountryLabel.text)))")
        print("🌐 the region code is: \(String(describing: localeUser.regionCode))")


    }

    private func recoverDataOfUserDefaults() {
        countryCodeDestination = userDefaults.string(forKey: "destinationCountryCode")?.uppercased() ?? "BE"
        nameDestinationCountryLabel.text = userDefaults.string(forKey: "destinationCountry")?.uppercased() ?? "BELGIUM"
        destinationNameLabel.text = userDefaults.string(forKey: "destinationCityName")?.capitalized
    }

    func modifyTextOnView() {
            // write info Iphone parameter:
            // - country
        let regionCode = self.localeUser.regionCode
        nameLocalCountryLabel.text = self.localeUser.localizedString(forRegionCode: regionCode ?? "Nothing")?.uppercased()
        
            // - currency symbol
        iconCurrencyPhone.text = self.localeUser.currencySymbol

            // write info destination country:


            // - currency symbol
        localeDestination = Locale(identifier: countryCodeDestination)
        var countryMaxLanguageIdentifier = ""

        if #available(iOS 16, *) {
            countryMaxLanguageIdentifier = localeDestination.language.maximalIdentifier
            currencyDestinationName = localeDestination.currency?.identifier ?? "EUR"
        } else {
            countryMaxLanguageIdentifier = localeDestination.identifier
            currencyDestinationName = localeDestination.currencyCode ?? "EUR"
        }
        let localizedLanguage = Locale(identifier: countryMaxLanguageIdentifier)
        print("🟠🔶🔸identifier language: \(localizedLanguage)")
        iconCurrencyDestination.text = localizedLanguage.currencySymbol



    }

        // -------------------------------------------------------
        //MARK: - keyboard keys
        // -------------------------------------------------------

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

            // recover the currency code
        if #available(iOS 16, *) {
            guard let value  = localeUser.currency?.identifier else { return }
            localeCurrencyUser = value
        } else {
            guard let value  = localeUser.currencyCode else { return }
            localeCurrencyUser = value
        }

       API.QueryService.shared.getData(endpoint: .currency(to: currencyDestinationName, from: localeCurrencyUser, amount: amountTapped),
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


        // -------------------------------------------------------
        //MARK: - alert
        // -------------------------------------------------------

    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "The result of currency failed", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alertVC, animated: true)
    }


        // -------------------------------------------------------
        //MARK: - flag UIImageView
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

                API.QueryService.shared.getFlag(endpoint: .flag(codeIsoCountry: self.countryCodeDestination), method: .GET) { countryFlag in
                    guard let countryFlag = countryFlag else {
                        print(API.Error.generic(reason: "not shown data"))
                        return
                    }
                    DispatchQueue.main.async {
                        self.flagDestinationImageView.image = UIImage(data: countryFlag)
                        self.modifyTextOnView()
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
