//
//  TranslateViewController.swift
//  LeBaluchon
//
//  Created by Greg Deveaux on 10/10/2022.
//

import UIKit

class TranslateViewController: UIViewController {

    @IBOutlet weak var baseTextView: UITextView!
    @IBOutlet weak var translateTextView: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()

    }

        let baseText = "Je viens de manger une pomme"

    @IBAction func tappedTranslationNow(_ sender: UIButton) {

        baseTextView.text = String(self.baseText)

        API.QueryService.shared.getTranslate(endpoint: .translation(sourceLang: "FR", text: baseText, targetLang: "EN"), method: .POST) { success, recover in
            guard let recover = recover, success == true else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }

            if let text = recover.translations.first?.text {
                self.translateTextView.text = text
            }

        }


    }
}
