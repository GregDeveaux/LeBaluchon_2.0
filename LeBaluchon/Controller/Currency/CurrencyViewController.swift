//
//  CurrencyViewController.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 10/10/2022.
//
import UIKit

class CurrencyViewController: UIViewController {

        // -------------------------------------------------------
        //MARK: - properties
        // -------------------------------------------------------

    var user = User()
    var destination = Destination()

    var amountTapped: Double = 0.0

    let localeUser = Locale.current
    var localeDestination: Locale!

    var currencyDestinationName: String = ""
    var currencyDestinationSymbol: String = ""

    var currencyUserName: String = ""
    var currencyUserSymbol: String = ""


        // -------------------------------------------------------
        //MARK: - outlets
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
    @IBOutlet weak var nameDestinationLabel: UILabel!
    @IBOutlet var whiteBoardView: [UIView]!


        // -------------------------------------------------------
        //MARK: - viewDidLoad
        // -------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        recoverDataOfUserDefaults()
        whiteBoardView[0].currencyDesign()
        whiteBoardView[1].currencyDesign()
        addFlagCountries()
    }

    private func recoverDataOfUserDefaults() {
        nameDestinationCountryLabel.text = destination.countryName.uppercased()
        nameDestinationLabel.text = "You have chosen as destination: \(destination.cityName.capitalized)"
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
            // check number tapped is different of zero
        if textFieldEntryAmount.text != "0" {
            buttonFrontBack(name: buttonConvert, imageCheck: "piece.png")
            API.QueryService.shared.getData(endpoint: .currency(to: currencyDestinationName, from: currencyUserName, amount: amountTapped),
                                            type: API.Currency.CalculateExchangeRate.self) { result in
                switch result {
                    case .failure(let error):
                        self.presentAlert(message: "The result of currency failed")
                        print(error.localizedDescription)

                    case .success(let result):
                        let calculateExchangeRate = result
                        DispatchQueue.main.async {
                            self.textFieldResult.text = String(calculateExchangeRate.result)
                            print("CURRENCY: 💰result: \(String(describing: calculateExchangeRate.result))")
                        }
                }
            }
        } else {
            presentAlert(message: "please entry a number who different of zero, thank you")
        }
    }


        // -------------------------------------------------------
        //MARK: - found the currency of the destination city
        // -------------------------------------------------------
    func giveMeTheCurrencySymbolDestination(countryCode: String) {
        if #available(iOS 16, *) {
                // for user part
            currencyUserName = localeUser.currency?.identifier ?? "unknow"
                // for destination city part
            let regionCode = Locale.Region(countryCode)
            localeDestination = Locale(languageCode: "", languageRegion: regionCode)
            currencyDestinationName = localeDestination.currency?.identifier ?? "unknow"
        } else {
                // for user part
            currencyUserName  = localeUser.currencyCode ?? "unknow"
                // for destination city part
            currencyDestinationName = localeDestination.currencyCode ?? "unknow"
        }
        currencyDestinationSymbol = localeDestination.currencySymbol ?? "unknow"

            // show symbol on the view
        let regionCode = self.localeUser.regionCode
        nameLocalCountryLabel.text = self.localeUser.localizedString(forRegionCode: regionCode ?? "Nothing")?.uppercased()
        iconCurrencyPhone.text = self.localeUser.currencySymbol
        iconCurrencyDestination.text = currencyDestinationSymbol

        print("✅ CURRENCY: user currency code is \(currencyUserName)")
        print("✅ CURRENCY: destination currency code is \(currencyDestinationName)")
        print("✅ CURRENCY: user symbol is \(String(describing: self.localeUser.currencySymbol))")
        print("✅ CURRENCY: destination symbol is \(currencyDestinationSymbol)")

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

                API.QueryService.shared.getFlag(endpoint: .flag(codeIsoCountry: self.destination.countryCode), method: .GET) { countryFlag in
                    guard let countryFlag = countryFlag else {
                        print(API.Error.generic(reason: "not shown data"))
                        return
                    }
                    DispatchQueue.main.async { [self] in
                        flagDestinationImageView.image = UIImage(data: countryFlag)
                        giveMeTheCurrencySymbolDestination(countryCode: destination.countryCode)
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


        // -------------------------------------------------------
        //MARK: - animations
        // -------------------------------------------------------
        // animation button template
    private func buttonFrontBack(name button: UIButton, imageCheck: String) {
        button.setImage(UIImage(named: imageCheck), for: .normal)
        UIView.transition(with: button,
                          duration: 0.25,
                          options: UIView.AnimationOptions.transitionFlipFromLeft,
                          animations: nil)
    }
}
