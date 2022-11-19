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

    @IBOutlet weak var firstLanguageButton: UIButton!
    @IBOutlet weak var secondLanguageButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!

    var textToTanslate = ""
    var textTranslated = ""

    var sourceLanguage = "EN"
    var targetLanguage = "FR"

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTranslate()
        setupButtonsLanguage()
    }

    private func setupTranslate() {
        setupTextView(baseTextView)
        setupTextView(translateTextView)

        textToTanslate = baseTextView.text
        baseTextView.text = textTranslated
    }

    private func setupTextView(_ textView: UITextView) {
        textView.layer.cornerRadius = 10
        textView.delegate = self

        textView.font = UIFont(name: "HelveticaNeue", size: 25)
        textView.textColor = .pinkGranada

    }

        //MARK: - Buttons language
    func setupButtonsLanguage() {
        setupActionMenu(firstLanguageButton)
        setupActionMenu(secondLanguageButton)

        recognizeButtonLanguage(firstLanguageButton, codeLanguage: sourceLanguage)
        recognizeButtonLanguage(secondLanguageButton, codeLanguage: targetLanguage)

        print("✅ you chose first language -> \(sourceLanguage)")
        print("✅ you chose second language -> \(targetLanguage)")
    }

    func recognizeButtonLanguage(_ languageButton: UIButton, codeLanguage: String) {
        if languageButton == self.firstLanguageButton {
            self.sourceLanguage = codeLanguage
        } else {
            self.targetLanguage = codeLanguage
        }
    }
}

extension TranslateViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if text == "\n" {
                textView.resignFirstResponder()
                return false
            }

        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        baseTextView.text = ""
        baseTextView.usesStandardTextScaling = true

        baseTextView.enablesReturnKeyAutomatically = true
    }

    func textViewDidChange(_ textView: UITextView) {
        print("the text changes")
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        if baseTextView.text.isEmpty {
            baseTextView.text = "Write a word or phrase to translate here"
            baseTextView.textColor = .lightGray
        }

            API.QueryService.shared.getTranslate(endpoint: .translation(sourceLang: sourceLanguage, text: baseTextView.text, targetLang: targetLanguage), method: .POST) { success, recover in
                guard let recover = recover, success == true else {
                    print(API.Error.generic(reason: "not shown data"))
                    return
                }

                if let text = recover.translations.first?.text {
                    self.translateTextView.text = text
            }
        }

        print("✅ le texte nouveau texte :\(baseTextView.text!)")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
