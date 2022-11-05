//
//  CurrencyViewController.swift
//  LeBaluchon
//
//  Created by Greg-Mini on 10/10/2022.
//

import UIKit

class CurrencyViewController: UIViewController {

    @IBOutlet var numberButton: [UIButton]!

    @IBOutlet weak var textFieldEntryAmount: UITextField!
    @IBOutlet weak var textFieldResult: UITextField!
    @IBOutlet weak var buttonConvert: UIButton!
    @IBOutlet weak var flagLocalImageView: UIImageView!
    @IBOutlet weak var nameLocalCountryLabel: UILabel!
    @IBOutlet weak var flagDestinationImageView: UIImageView!
    @IBOutlet weak var nameDestinationCountryLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        API.QueryService.shared.getFlag(endpoint: .flag(codeIsoCountry: "FR"), method: .GET) { countryFlag in
            guard let countryFlag = countryFlag else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }
            DispatchQueue.main.async {
                self.flagLocalImageView.image = UIImage(data: countryFlag)
            }
        }

        API.QueryService.shared.getFlag(endpoint: .flag(codeIsoCountry: "US"), method: .GET) { countryFlag in
            guard let countryFlag = countryFlag else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }
            DispatchQueue.main.async {
                self.flagDestinationImageView.image = UIImage(data: countryFlag)
            }
        }
    }

    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else { return }
        self.textFieldEntryAmount.text?.append(numberText)
        print("tapped: \(numberText)")

}

    @IBAction func tappedToConvert(_ sender: UIButton) {

        API.QueryService.shared.getCurrency(endpoint: .currency(to: "EUR", from: "USD", amount: 165.0), method: .GET) { success, calculateExchangeRate in
            guard let calculateExchangeRate = calculateExchangeRate, success == true else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }
            DispatchQueue.main.async {
                self.textFieldEntryAmount.text = String(calculateExchangeRate.query.amount)

                self.textFieldResult.text = String(calculateExchangeRate.result)
            }

        }

    }
}
