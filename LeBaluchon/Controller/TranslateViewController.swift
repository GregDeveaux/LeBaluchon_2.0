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

    var textToTanslate: String? {
        didSet {
            textToTanslate = baseTextView.text
            print("✅ the text to translate is: \(textToTanslate ?? "empty")")

            
        }
    }

    var textTranslated = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        baseTextView.delegate = self
    }

}

extension TranslateViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        baseTextView.enablesReturnKeyAutomatically = false
        API.QueryService.shared.getTranslate(endpoint: .translation(sourceLang: "FR", text: textToTanslate ?? "empty" , targetLang: "EN"), method: .POST) { success, recover in
            guard let recover = recover, success == true else {
                print(API.Error.generic(reason: "not shown data"))
                return
            }

            if let text = recover.translations.first?.text {
                self.translateTextView.text = text
            }
        }
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        baseTextView.text = ""
        baseTextView.textColor = .pinkGranada
        baseTextView.usesStandardTextScaling = true

        baseTextView.enablesReturnKeyAutomatically = true
    }

    func textViewDidChange(_ textView: UITextView) {
        if baseTextView.text.isEmpty {
            baseTextView.text = "Écris un mot ou une phrase à traduire ici"
            baseTextView.textColor = .lightGray
        }

        print(baseTextView.text!)

    }
}

